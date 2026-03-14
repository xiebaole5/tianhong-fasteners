"""
orchestrator.py — Phase 0: 命令行版 AI 客服编排器
天宏紧固件 AI 数字人 · 核心对话管理

用法:
    pip install openai
    python ai/core/dialogue/orchestrator.py

    (支持任何 OpenAI 兼容接口，如 Minimax、Ollama 等)
"""

import json
import os
import sys
from pathlib import Path

# ---------------------------------------------------------------------------
# 配置：修改这里来切换 LLM 提供商
# ---------------------------------------------------------------------------
BASE_DIR = Path(__file__).resolve().parents[3]  # 仓库根目录

LLM_CONFIG = {
    # 使用 Minimax API（推荐，你已有账号）
    # "base_url": "https://api.minimax.chat/v1",
    # "api_key": os.environ.get("MINIMAX_API_KEY", "your-key-here"),
    # "model": "abab6.5s-chat",

    # 使用 Ollama 本地模型（免费，3080Ti 可跑）
    "base_url": "http://localhost:11434/v1",
    "api_key": "ollama",
    "model": "qwen2.5:7b",

    # 使用 OpenAI
    # "base_url": "https://api.openai.com/v1",
    # "api_key": os.environ.get("OPENAI_API_KEY", ""),
    # "model": "gpt-4o-mini",
}

MAX_CONTEXT_TURNS = 12  # 保留最近 N 轮对话上下文


# ---------------------------------------------------------------------------
# 加载角色配置
# ---------------------------------------------------------------------------
def load_persona() -> dict:
    path = BASE_DIR / "ai" / "character" / "persona.json"
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def load_knowledge_base() -> dict:
    path = BASE_DIR / "ai" / "character" / "knowledge_base.json"
    with open(path, encoding="utf-8") as f:
        return json.load(f)


# ---------------------------------------------------------------------------
# 构建 System Prompt
# ---------------------------------------------------------------------------
def build_system_prompt(persona: dict, kb: dict) -> str:
    products_summary = "\n".join(
        f"- {p['name_zh']} ({p['name_en']}): {p.get('spec', '')} | {', '.join(p.get('materials', []))}"
        for p in kb.get("products", [])
    )
    dacromet = kb.get("dacromet_info", {})
    contact = persona.get("contact", {})

    return f"""你是{persona['company']}的AI客服顾问，名字叫{persona['name']}。

【角色设定】
- 公司：{persona['company']} ({persona['company_en']})，成立于{persona['founded']}年
- 性格：{persona['personality']['style']}
- 语言：根据用户使用语言自动切换中文或英文回复
- 禁止：{' | '.join(persona['personality']['forbidden'])}

【公司介绍】
{kb['company_intro']['zh']}
{kb['company_intro']['en']}

【主要产品（支持M3~M100规格，可定制）】
{products_summary}

【达克罗涂层专业知识】
{dacromet.get('description_zh', '')}
{dacromet.get('description_en', '')}

【联系方式】
WhatsApp: {contact.get('whatsapp', '')}
Email: {contact.get('email', '')}

【回复规范】
- 回复简洁，不超过200字
- 如买家问及报价或定制，主动引导其提供：规格、数量、材质要求、表面处理
- 无法确定的问题，建议买家通过 WhatsApp 或邮件联系业务团队
- 不要编造产品规格或交期
"""


# ---------------------------------------------------------------------------
# 短期记忆：在内存中保存对话历史
# ---------------------------------------------------------------------------
class ShortTermMemory:
    def __init__(self, max_turns: int = MAX_CONTEXT_TURNS):
        self.max_turns = max_turns
        self.history: list[dict] = []

    def add(self, role: str, content: str):
        self.history.append({"role": role, "content": content})
        # 保留最近 N 轮（每轮 = user + assistant）
        if len(self.history) > self.max_turns * 2:
            self.history = self.history[-(self.max_turns * 2):]

    def get_messages(self, system_prompt: str) -> list[dict]:
        return [{"role": "system", "content": system_prompt}] + self.history


# ---------------------------------------------------------------------------
# LLM 调用
# ---------------------------------------------------------------------------
def call_llm(messages: list[dict]) -> str:
    try:
        from openai import OpenAI
    except ImportError:
        print("[错误] 请先安装 openai: pip install openai")
        sys.exit(1)

    client = OpenAI(
        base_url=LLM_CONFIG["base_url"],
        api_key=LLM_CONFIG["api_key"],
    )

    response = client.chat.completions.create(
        model=LLM_CONFIG["model"],
        messages=messages,
        temperature=0.7,
        max_tokens=400,
    )
    return response.choices[0].message.content.strip()


# ---------------------------------------------------------------------------
# 主循环
# ---------------------------------------------------------------------------
def main():
    print("加载角色配置...", end=" ", flush=True)
    persona = load_persona()
    kb = load_knowledge_base()
    system_prompt = build_system_prompt(persona, kb)
    memory = ShortTermMemory()
    print("✓")

    print(f"\n{'='*60}")
    print(f"  天宏紧固件 AI 客服 · {persona['name']}")
    print(f"  模型: {LLM_CONFIG['model']} @ {LLM_CONFIG['base_url']}")
    print(f"  输入 'quit' 或 Ctrl+C 退出")
    print(f"{'='*60}\n")

    # 开场问候
    greeting = persona["greetings"]["zh"]
    print(f"[{persona['name']}]: {greeting}\n")
    memory.add("assistant", greeting)

    while True:
        try:
            user_input = input("[你]: ").strip()
        except (KeyboardInterrupt, EOFError):
            print(f"\n[{persona['name']}]: 再见！如需询盘请随时联系我们。")
            break

        if not user_input:
            continue
        if user_input.lower() in ("quit", "exit", "退出"):
            print(f"[{persona['name']}]: 感谢您的咨询！如有需要欢迎随时联系。")
            break

        memory.add("user", user_input)

        print(f"[{persona['name']}]: ", end="", flush=True)
        try:
            reply = call_llm(memory.get_messages(system_prompt))
        except Exception as e:
            reply = f"[系统错误: {e}]\n请检查 LLM 配置（LLM_CONFIG），确认服务已启动。"

        print(reply)
        print()
        memory.add("assistant", reply)


if __name__ == "__main__":
    main()
