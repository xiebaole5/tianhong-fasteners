# AI 系统依赖说明

## Phase 0 (当前阶段)

只需要安装一个依赖：

```bash
pip install openai
```

`openai` Python SDK 支持所有 OpenAI 兼容接口，包括：
- Minimax API
- Ollama 本地模型
- OpenAI 官方接口
- 其他任何兼容接口

## 快速开始

### 方案 A：使用 Minimax（推荐）

1. 在 `ai/core/dialogue/orchestrator.py` 中修改 `LLM_CONFIG`：
```python
LLM_CONFIG = {
    "base_url": "https://api.minimax.chat/v1",
    "api_key": "your-minimax-api-key",
    "model": "abab6.5s-chat",
}
```

2. 运行：
```bash
python ai/core/dialogue/orchestrator.py
```

### 方案 B：使用 Ollama 本地模型（免费，无需网络）

1. 安装 Ollama: https://ollama.com
2. 下载模型（3080Ti 推荐 7B 量化版）：
```bash
ollama pull qwen2.5:7b
```
3. 启动 Ollama 服务（后台运行）：
```bash
ollama serve
```
4. 运行（默认配置已指向 Ollama）：
```bash
python ai/core/dialogue/orchestrator.py
```

## Phase 1 以后需要增加的依赖

```bash
pip install fastapi uvicorn faiss-cpu sentence-transformers
```
