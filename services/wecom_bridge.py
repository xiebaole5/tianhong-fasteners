"""
wecom_bridge.py
===============
企业微信（WeCom）→ 本地 Qwen-3-8B 模型 桥接服务
基于 FastAPI，监听企业微信回调，调用本地模型 API 生成回复，并可触发白名单脚本。

功能列表：
  - /wecom/callback  : 接收企业微信 GET（服务器验证）和 POST（消息推送）
  - /health          : 健康检查端点
  - 本地模型调用      : 兼容 text-generation-webui（OpenAI /v1 格式）和 Ollama
  - 白名单任务触发    : trigger_cursor() 只允许执行 SCRIPTS_DIR 内的脚本
  - 审计日志         : 所有请求和操作写入 logs/audit.log

环境变量（从 .env 读取，见 .env.example）：
  WECHAT_CORP_ID      企业 ID
  WECHAT_AGENT_ID     应用 AgentID
  WECHAT_SECRET       应用 Secret
  WECHAT_TOKEN        消息令牌（用于签名验证）
  BRIDGE_SECRET       内部鉴权密钥（X-Bridge-Secret 请求头）
  MODEL_API_BASE      模型 API 地址（如 http://localhost:5000/v1）
  MODEL_BACKEND       webui | ollama
  MODEL_NAME          模型名称（如 Qwen3-8B-Q4_K_M）
  SCRIPTS_DIR         白名单脚本目录（默认 /app/scripts）
  LOG_DIR             审计日志目录（默认 /app/logs）
  MAX_TOKENS          模型最大输出 Token（默认 512）

TODO（生产前必须完成）：
  1. 实现企业微信消息加解密（WXBizMsgCrypt），当前仅处理明文消息。
  2. 实现消息签名验证（校验 msg_signature、timestamp、nonce）。
  3. access_token 应定期刷新并存储到安全的持久化介质（Redis/数据库），不得明文写入日志。
  4. 生产环境需启用 HTTPS，或通过 Cloudflared 隧道加密传输。
  5. 对企业微信回调的 IP 来源进行白名单限制。

用法：
  pip install fastapi uvicorn httpx python-dotenv
  uvicorn wecom_bridge:app --host 0.0.0.0 --port 3000 --reload
"""

import hashlib
import hmac
import json
import logging
import os
import re
import subprocess
import time
import xml.etree.ElementTree as ET
from datetime import datetime
from pathlib import Path
from typing import Optional

import httpx
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Query, Request, Response
from fastapi.responses import JSONResponse, PlainTextResponse

# ─────────────────────────────────────────────────────────────────────────────
# 配置加载
# ─────────────────────────────────────────────────────────────────────────────

load_dotenv()

WECHAT_CORP_ID: str = os.getenv("WECHAT_CORP_ID", "")
WECHAT_AGENT_ID: str = os.getenv("WECHAT_AGENT_ID", "")
WECHAT_SECRET: str = os.getenv("WECHAT_SECRET", "")
WECHAT_TOKEN: str = os.getenv("WECHAT_TOKEN", "")
BRIDGE_SECRET: str = os.getenv("BRIDGE_SECRET", "")
MODEL_API_BASE: str = os.getenv("MODEL_API_BASE", "http://localhost:5000/v1")
MODEL_BACKEND: str = os.getenv("MODEL_BACKEND", "webui")  # webui | ollama
MODEL_NAME: str = os.getenv("MODEL_NAME", "Qwen3-8B-Q4_K_M")
MAX_TOKENS: int = int(os.getenv("MAX_TOKENS", "512"))
SCRIPTS_DIR: Path = Path(os.getenv("SCRIPTS_DIR", "/app/scripts")).resolve()
LOG_DIR: Path = Path(os.getenv("LOG_DIR", "/app/logs"))
SYSTEM_PROMPT: str = os.getenv(
    "SYSTEM_PROMPT",
    "你是天宏紧固件公司的智能助手，请用中文简洁专业地回答问题。",
)

# ─────────────────────────────────────────────────────────────────────────────
# 日志配置（审计日志写文件，INFO+ 同时输出到控制台）
# ─────────────────────────────────────────────────────────────────────────────

LOG_DIR.mkdir(parents=True, exist_ok=True)
_audit_log_path = LOG_DIR / "audit.log"

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler(_audit_log_path, encoding="utf-8"),
    ],
)
logger = logging.getLogger("wecom_bridge")

# ─────────────────────────────────────────────────────────────────────────────
# FastAPI 应用
# ─────────────────────────────────────────────────────────────────────────────

app = FastAPI(
    title="WeCom Bridge",
    description="WeCom -> 本地 Qwen-3-8B 模型桥接服务",
    version="1.0.0",
)

# ─────────────────────────────────────────────────────────────────────────────
# 白名单脚本列表（仅允许此列表中的脚本被触发，且脚本必须位于 SCRIPTS_DIR）
# ─────────────────────────────────────────────────────────────────────────────

ALLOWED_SCRIPTS: dict[str, str] = {
    "generate_boilerplate": "trigger_generate_boilerplate.sh",
    # 在此处添加更多允许的脚本名称 -> 文件名映射
}

# ─────────────────────────────────────────────────────────────────────────────
# 辅助函数
# ─────────────────────────────────────────────────────────────────────────────


def _verify_bridge_secret(secret: Optional[str]) -> bool:
    """验证内部鉴权密钥（使用恒时比较防止时序攻击）。"""
    if not BRIDGE_SECRET:
        logger.warning("BRIDGE_SECRET 未设置，内部鉴权已跳过（仅开发环境可接受）")
        return True
    if not secret:
        return False
    return hmac.compare_digest(secret, BRIDGE_SECRET)


def _verify_wechat_signature(
    token: str, timestamp: str, nonce: str, signature: str
) -> bool:
    """
    验证企业微信消息签名。
    TODO: 加密模式下需使用 WXBizMsgCrypt 验证 msg_signature，当前为明文模式。
    """
    items = sorted([token, timestamp, nonce])
    sha1 = hashlib.sha1("".join(items).encode("utf-8")).hexdigest()
    return hmac.compare_digest(sha1, signature)


def _audit(event: str, detail: dict) -> None:
    """写审计日志。所有敏感字段在写入前应脱敏。"""
    record = {
        "ts": datetime.utcnow().isoformat() + "Z",
        "event": event,
        **detail,
    }
    logger.info("[AUDIT] %s", json.dumps(record, ensure_ascii=False))


async def _call_model(prompt: str, system: str = "") -> str:
    """
    调用本地模型 API，兼容两种后端：
      - webui: POST /v1/chat/completions（OpenAI 格式）
      - ollama: POST /api/chat（Ollama 原生格式）
    """
    if MODEL_BACKEND == "ollama":
        url = MODEL_API_BASE.rstrip("/").replace("/v1", "") + "/api/chat"
        payload = {
            "model": MODEL_NAME,
            "messages": [
                {"role": "system", "content": system} if system else None,
                {"role": "user", "content": prompt},
            ],
            "stream": False,
            "options": {"num_predict": MAX_TOKENS},
        }
        # 移除 None（无 system prompt 时）
        payload["messages"] = [m for m in payload["messages"] if m]
    else:
        # text-generation-webui 的 OpenAI 兼容端点
        url = MODEL_API_BASE.rstrip("/") + "/chat/completions"
        messages = []
        if system:
            messages.append({"role": "system", "content": system})
        messages.append({"role": "user", "content": prompt})
        payload = {
            "model": MODEL_NAME,
            "messages": messages,
            "max_tokens": MAX_TOKENS,
            "temperature": 0.7,
        }

    logger.info("调用模型 backend=%s url=%s", MODEL_BACKEND, url)

    async with httpx.AsyncClient(timeout=120.0) as client:
        resp = await client.post(url, json=payload)
        resp.raise_for_status()
        data = resp.json()

    # 提取回复文本
    if MODEL_BACKEND == "ollama":
        return data.get("message", {}).get("content", "（模型无回复）")
    else:
        choices = data.get("choices", [])
        if choices:
            return choices[0].get("message", {}).get("content", "（模型无回复）")
        return "（模型无回复）"


async def _send_wecom_message(user_id: str, content: str) -> None:
    """
    通过企业微信应用消息接口将回复发送给用户。
    TODO: access_token 需定期刷新（有效期 7200 秒），应存储在安全的持久化介质，不得明文写入日志。
    """
    # 获取 access_token
    token_url = (
        f"https://qyapi.weixin.qq.com/cgi-bin/gettoken"
        f"?corpid={WECHAT_CORP_ID}&corpsecret={WECHAT_SECRET}"
    )
    async with httpx.AsyncClient(timeout=10.0) as client:
        token_resp = await client.get(token_url)
        token_data = token_resp.json()

    if token_data.get("errcode", 0) != 0:
        logger.error("获取 access_token 失败: errcode=%s", token_data.get("errcode"))
        return

    access_token = token_data["access_token"]
    # 注意：access_token 不得写入日志（敏感凭证）。
    # TODO: 实现带 TTL 的缓存（有效期 7200 秒），避免每次消息都重新请求。

    # 发送消息
    msg_url = f"https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token={access_token}"
    payload = {
        "touser": user_id,
        "msgtype": "text",
        "agentid": WECHAT_AGENT_ID,
        "text": {"content": content},
    }
    async with httpx.AsyncClient(timeout=10.0) as client:
        send_resp = await client.post(msg_url, json=payload)
        result = send_resp.json()

    if result.get("errcode", 0) != 0:
        logger.error("发送企业微信消息失败: %s", result)
    else:
        logger.info("企业微信消息已发送至用户 %s", user_id)


def trigger_cursor(task_name: str, args: Optional[list[str]] = None) -> dict:
    """
    触发白名单脚本（Cursor Auto Hook）。

    安全机制：
    1. task_name 必须在 ALLOWED_SCRIPTS 白名单内。
    2. 脚本路径通过 resolve() 验证，必须位于 SCRIPTS_DIR 目录下（防止路径穿越）。
    3. 通过 subprocess 执行，不使用 shell=True。

    参数：
      task_name: 任务名称（映射到白名单脚本文件名）
      args:      可选的额外参数列表（每个参数须通过简单字符集校验）

    返回：
      {"success": bool, "task": str, "stdout": str, "stderr": str, "returncode": int}
    """
    if task_name not in ALLOWED_SCRIPTS:
        _audit("trigger_cursor_rejected", {"reason": "not_in_whitelist", "task": task_name})
        return {"success": False, "task": task_name, "error": "任务不在白名单内"}

    script_file = SCRIPTS_DIR / ALLOWED_SCRIPTS[task_name]
    # 路径安全校验：必须仍在 SCRIPTS_DIR 下
    try:
        script_file = script_file.resolve()
        script_file.relative_to(SCRIPTS_DIR)
    except (ValueError, RuntimeError):
        _audit("trigger_cursor_rejected", {"reason": "path_traversal", "task": task_name})
        return {"success": False, "task": task_name, "error": "路径校验失败"}

    if not script_file.is_file():
        _audit("trigger_cursor_missing", {"task": task_name, "path": str(script_file)})
        return {"success": False, "task": task_name, "error": "脚本文件不存在"}

    # 参数校验：仅允许字母、数字、下划线、连字符、点和斜杠
    safe_args: list[str] = []
    if args:
        for arg in args:
            if not re.fullmatch(r"[\w.\-/]+", arg):
                _audit(
                    "trigger_cursor_rejected",
                    {"reason": "unsafe_arg", "task": task_name, "arg": arg},
                )
                return {"success": False, "task": task_name, "error": f"不安全的参数: {arg}"}
            safe_args.append(arg)

    cmd = ["/bin/bash", str(script_file)] + safe_args
    _audit("trigger_cursor_start", {"task": task_name, "cmd": cmd})

    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=60,
        )
        _audit(
            "trigger_cursor_end",
            {
                "task": task_name,
                "returncode": result.returncode,
                "stdout_len": len(result.stdout),
            },
        )
        return {
            "success": result.returncode == 0,
            "task": task_name,
            "stdout": result.stdout,
            "stderr": result.stderr,
            "returncode": result.returncode,
        }
    except subprocess.TimeoutExpired:
        _audit("trigger_cursor_timeout", {"task": task_name})
        return {"success": False, "task": task_name, "error": "脚本执行超时"}
    except Exception as exc:
        _audit("trigger_cursor_error", {"task": task_name, "error": str(exc)})
        return {"success": False, "task": task_name, "error": str(exc)}


# ─────────────────────────────────────────────────────────────────────────────
# API 端点
# ─────────────────────────────────────────────────────────────────────────────


@app.get("/health")
async def health_check():
    """健康检查端点，供 Docker healthcheck 和监控使用。"""
    return {"status": "ok", "ts": datetime.utcnow().isoformat() + "Z"}


@app.get("/wecom/callback")
async def wecom_verify(
    msg_signature: str = Query(default=""),
    timestamp: str = Query(default=""),
    nonce: str = Query(default=""),
    echostr: str = Query(default=""),
) -> PlainTextResponse:
    """
    企业微信服务器地址验证（首次配置时调用一次）。
    校验签名后返回 echostr 明文。
    TODO: 加密模式下 echostr 为密文，需使用 WXBizMsgCrypt 解密后返回。
    """
    if not _verify_wechat_signature(WECHAT_TOKEN, timestamp, nonce, msg_signature):
        _audit("wecom_verify_failed", {"timestamp": timestamp, "nonce": nonce})
        raise HTTPException(status_code=403, detail="签名验证失败")
    _audit("wecom_verify_ok", {"timestamp": timestamp})
    return PlainTextResponse(content=echostr)


@app.post("/wecom/callback")
async def wecom_callback(
    request: Request,
    msg_signature: str = Query(default=""),
    timestamp: str = Query(default=""),
    nonce: str = Query(default=""),
) -> Response:
    """
    接收企业微信消息回调，调用本地模型生成回复，并可触发白名单脚本。

    消息格式（明文 XML）：
      <xml>
        <ToUserName>企业微信 ID</ToUserName>
        <FromUserName>发送者 UserID</FromUserName>
        <CreateTime>时间戳</CreateTime>
        <MsgType>text</MsgType>
        <Content>消息内容</Content>
        <MsgId>消息 ID</MsgId>
        <AgentID>应用 AgentID</AgentID>
      </xml>

    TODO:
      1. 加密模式下需解密消息体（WXBizMsgCrypt.DecryptMsg）。
      2. 校验 msg_signature（目前仅校验基础 signature）。
    """
    body = await request.body()

    # 基础签名验证
    if WECHAT_TOKEN and not _verify_wechat_signature(
        WECHAT_TOKEN, timestamp, nonce, msg_signature
    ):
        _audit("wecom_callback_sig_fail", {"timestamp": timestamp})
        raise HTTPException(status_code=403, detail="签名验证失败")

    # 解析 XML 消息体
    try:
        root = ET.fromstring(body.decode("utf-8"))
    except ET.ParseError as exc:
        _audit("wecom_callback_xml_error", {"error": str(exc)})
        raise HTTPException(status_code=400, detail="XML 解析失败") from exc

    msg_type = root.findtext("MsgType", "").strip()
    from_user = root.findtext("FromUserName", "").strip()
    content = root.findtext("Content", "").strip()
    msg_id = root.findtext("MsgId", "")

    _audit(
        "wecom_message_received",
        {"from": from_user, "msg_type": msg_type, "msg_id": msg_id, "content_len": len(content)},
    )

    # 仅处理文本消息
    if msg_type != "text":
        return Response(content="success")

    # ── 任务触发检测 ──────────────────────────────────────────
    # 若消息以 "/task " 开头，尝试触发白名单脚本
    if content.lower().startswith("/task "):
        task_name = content[6:].strip().split()[0]
        extra_args = content[6:].strip().split()[1:]
        task_result = trigger_cursor(task_name, extra_args if extra_args else None)
        reply_text = (
            f"✅ 任务 {task_name} 已执行。\n"
            f"返回码: {task_result.get('returncode', 'N/A')}\n"
            f"输出:\n{task_result.get('stdout', '')[:500]}"
            if task_result.get("success")
            else f"❌ 任务 {task_name} 执行失败: {task_result.get('error', '')}"
        )
        await _send_wecom_message(from_user, reply_text)
        return Response(content="success")

    # ── 普通消息 → 本地模型 ────────────────────────────────────
    try:
        reply = await _call_model(
            prompt=content,
            system=SYSTEM_PROMPT,
        )
    except httpx.HTTPError as exc:
        logger.error("模型调用失败: %s", exc)
        _audit("model_call_error", {"error": str(exc), "from": from_user})
        reply = "抱歉，模型服务暂时不可用，请稍后再试。"

    _audit("model_reply_sent", {"to": from_user, "reply_len": len(reply)})
    await _send_wecom_message(from_user, reply)

    # 企业微信要求 5 秒内返回 "success"
    return Response(content="success")


@app.post("/internal/trigger")
async def internal_trigger(request: Request) -> JSONResponse:
    """
    内部触发端点（供本地服务调用），直接触发白名单脚本。
    需要在请求头中提供 X-Bridge-Secret。

    请求体 JSON：
      {"task": "generate_boilerplate", "args": ["--template", "rest-api"]}

    返回 JSON：
      {"success": bool, "task": str, "stdout": str, "stderr": str, "returncode": int}
    """
    secret = request.headers.get("X-Bridge-Secret")
    if not _verify_bridge_secret(secret):
        _audit("internal_trigger_unauthorized", {"ip": request.client.host if request.client else "unknown"})
        raise HTTPException(status_code=401, detail="鉴权失败")

    body = await request.json()
    task_name = body.get("task", "")
    args = body.get("args", [])

    if not task_name:
        raise HTTPException(status_code=400, detail="缺少 task 参数")

    result = trigger_cursor(task_name, args)
    return JSONResponse(content=result)


# ─────────────────────────────────────────────────────────────────────────────
# 直接运行（开发模式）
# ─────────────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    import uvicorn

    uvicorn.run("wecom_bridge:app", host="0.0.0.0", port=3000, reload=True)
