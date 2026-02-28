#!/usr/bin/env bash
# =============================================================================
# trigger_generate_boilerplate.sh
# =============================================================================
# 白名单任务脚本：生成项目样板代码（Boilerplate）
# 由 wecom_bridge.py 的 trigger_cursor() 调用。
#
# 用法（直接执行）：
#   bash services/scripts/trigger_generate_boilerplate.sh [--template rest-api] [--output ./output]
#
# 用法（通过企业微信触发）：
#   在企业微信中发送: /task generate_boilerplate --template rest-api
#
# 输出：
#   - 标准输出: JSON 格式的执行结果
#   - 日志文件: /app/logs/tasks.log（若环境变量 LOG_DIR 已设置则使用该目录）
#
# 安全注意：
#   - 此脚本由 wecom_bridge.py 以非交互方式调用，不得依赖 tty。
#   - 所有参数已在调用方经过白名单校验，但脚本自身仍应防御性地校验参数。
#   - 不得执行任意用户提供的命令或路径。
#
# TODO: 将此脚本替换为调用 Cursor Auto CLI 的实际命令，例如：
#   cursor --headless generate --template "$TEMPLATE" --output "$OUTPUT_DIR"
# =============================================================================

set -euo pipefail

# ─── 常量 ───────────────────────────────────────────────────────────────────
SCRIPT_NAME="trigger_generate_boilerplate"
LOG_DIR="${LOG_DIR:-/app/logs}"
LOG_FILE="${LOG_DIR}/tasks.log"
START_TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# 允许的模板名称（防止路径穿越/命令注入）
ALLOWED_TEMPLATES="rest-api fastapi-service react-component nodejs-cli"

# ─── 日志函数 ────────────────────────────────────────────────────────────────
log() {
    local level="$1"
    shift
    local msg="$*"
    local ts
    ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "${ts} [${level}] [${SCRIPT_NAME}] ${msg}" | tee -a "${LOG_FILE}" >&2
}

# ─── 结果输出函数（JSON）────────────────────────────────────────────────────
output_result() {
    local success="$1"
    local message="$2"
    local output_dir="${3:-}"
    local end_ts
    end_ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # 使用 printf 确保 JSON 特殊字符被正确转义
    printf '{"success":%s,"task":"%s","message":"%s","output_dir":"%s","started_at":"%s","finished_at":"%s"}\n' \
        "$success" \
        "$SCRIPT_NAME" \
        "$message" \
        "$output_dir" \
        "$START_TS" \
        "$end_ts"
}

# ─── 参数解析 ────────────────────────────────────────────────────────────────
TEMPLATE="rest-api"
OUTPUT_DIR="./generated_output"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --template)
            TEMPLATE="$2"
            shift 2
            ;;
        --output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        *)
            log "WARN" "未知参数: $1，已忽略"
            shift
            ;;
    esac
done

# ─── 参数安全校验 ────────────────────────────────────────────────────────────
log "INFO" "参数: template=${TEMPLATE}, output=${OUTPUT_DIR}"

# 校验模板名称（仅允许白名单内的值）
if ! echo "${ALLOWED_TEMPLATES}" | grep -qw "${TEMPLATE}"; then
    log "ERROR" "不允许的模板名称: ${TEMPLATE}"
    output_result "false" "不允许的模板名称: ${TEMPLATE}"
    exit 1
fi

# 校验输出路径（不允许路径穿越）
if case "${OUTPUT_DIR}" in *..*) true ;; *) false ;; esac; then
    log "ERROR" "输出路径包含路径穿越序列: ${OUTPUT_DIR}"
    output_result "false" "不安全的输出路径"
    exit 1
fi

# ─── 确保日志目录存在 ────────────────────────────────────────────────────────
mkdir -p "${LOG_DIR}" 2>/dev/null || true

# ─── 主逻辑（样板代码生成）──────────────────────────────────────────────────
log "INFO" "开始生成样板代码: template=${TEMPLATE}"

mkdir -p "${OUTPUT_DIR}"

case "${TEMPLATE}" in
    rest-api)
        cat > "${OUTPUT_DIR}/main.py" << 'PYEOF'
"""
REST API 样板 - 由 trigger_generate_boilerplate.sh 生成
TODO: 根据实际需求修改此文件
"""
from fastapi import FastAPI

app = FastAPI(title="Generated REST API")

@app.get("/")
def root():
    return {"message": "Hello from generated REST API"}
PYEOF
        log "INFO" "已生成 rest-api 样板: ${OUTPUT_DIR}/main.py"
        ;;

    fastapi-service)
        cat > "${OUTPUT_DIR}/service.py" << 'PYEOF'
"""
FastAPI 服务样板 - 由 trigger_generate_boilerplate.sh 生成
TODO: 根据实际需求修改此文件
"""
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Generated FastAPI Service")

class Item(BaseModel):
    name: str
    value: str

@app.post("/items")
def create_item(item: Item):
    return {"created": item.dict()}
PYEOF
        log "INFO" "已生成 fastapi-service 样板: ${OUTPUT_DIR}/service.py"
        ;;

    react-component)
        cat > "${OUTPUT_DIR}/Component.tsx" << 'TSXEOF'
// React 组件样板 - 由 trigger_generate_boilerplate.sh 生成
// TODO: 根据实际需求修改此文件
import React from "react";

interface Props {
  title: string;
}

export const GeneratedComponent: React.FC<Props> = ({ title }) => {
  return <div className="generated-component">{title}</div>;
};
TSXEOF
        log "INFO" "已生成 react-component 样板: ${OUTPUT_DIR}/Component.tsx"
        ;;

    nodejs-cli)
        cat > "${OUTPUT_DIR}/cli.js" << 'JSEOF'
#!/usr/bin/env node
// Node.js CLI 样板 - 由 trigger_generate_boilerplate.sh 生成
// TODO: 根据实际需求修改此文件
const args = process.argv.slice(2);
console.log("Generated CLI, args:", args);
JSEOF
        log "INFO" "已生成 nodejs-cli 样板: ${OUTPUT_DIR}/cli.js"
        ;;
esac

# ─── TODO: 集成 Cursor Auto ──────────────────────────────────────────────────
# 取消注释以下代码以通过 Cursor Auto CLI 进一步优化生成的代码：
#
# if command -v cursor &>/dev/null; then
#     log "INFO" "通过 Cursor Auto 优化代码..."
#     cursor --headless improve "${OUTPUT_DIR}" \
#         --instruction "请优化这段代码，添加错误处理和注释" \
#         >> "${LOG_FILE}" 2>&1
# else
#     log "WARN" "Cursor CLI 未找到，跳过 AI 优化步骤"
# fi

# ─── 完成 ────────────────────────────────────────────────────────────────────
log "INFO" "样板代码生成完成: ${OUTPUT_DIR}"
output_result "true" "样板代码生成成功" "${OUTPUT_DIR}"
exit 0
