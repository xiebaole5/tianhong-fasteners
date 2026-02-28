# DEPLOY_QWEN3_LOCAL.md
# 本地 Qwen-3-8B (4-bit) 部署与企业微信桥接指南

> **适用场景**: 在 16核/32GB RAM/NVIDIA RTX 4070 8GB 的本地笔记本上运行 Qwen-3-8B 量化模型，并通过企业微信与之交互。

---

## 目录

1. [环境准备](#1-环境准备)
2. [模型下载与许可](#2-模型下载与许可)
3. [量化建议](#3-量化建议)
4. [启动方式选择：Ollama vs text-generation-webui](#4-启动方式选择)
5. [text-generation-webui 启动步骤](#5-text-generation-webui-启动步骤)
6. [Ollama 启动示例](#6-ollama-启动示例)
7. [WeCom Bridge 配置与启动](#7-wecom-bridge-配置与启动)
8. [Cloudflared 隧道配置](#8-cloudflared-隧道配置)
9. [Docker Compose 一键启动](#9-docker-compose-一键启动)
10. [Cursor Auto 集成说明](#10-cursor-auto-集成说明)
11. [常见 OOM 处理策略](#11-常见-oom-处理策略)
12. [安全注意事项](#12-安全注意事项)

---

## 1. 环境准备

### 硬件要求

| 组件 | 最低 | 推荐 |
|------|------|------|
| GPU 显存 | 6 GB (Q4) | 8 GB (Q4_K_M) |
| 内存 | 16 GB | 32 GB |
| 磁盘 | 10 GB | 20 GB（模型 ~5.5GB + 系统） |
| CPU | 8核 | 16核 |

### 软件依赖

```bash
# 1. NVIDIA 驱动（≥ 525）和 CUDA Toolkit（≥ 12.1）
nvidia-smi   # 验证驱动正常

# 2. Docker 和 NVIDIA Container Toolkit
sudo apt install -y docker.io
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list \
  | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt update && sudo apt install -y nvidia-container-toolkit
sudo systemctl restart docker

# 3. Docker Compose v2
docker compose version   # 验证版本 ≥ 2.0

# 4. cloudflared（可选，若不使用 Docker 版本）
# 见第 8 节

# 5. Python 3.11+（若不使用 Docker 运行 bridge）
python3 --version
pip install fastapi uvicorn httpx python-dotenv
```

---

## 2. 模型下载与许可

### Qwen3-8B 许可证

> ⚠️ **重要**: Qwen3 系列模型使用 [Apache 2.0 许可证](https://huggingface.co/Qwen/Qwen3-8B/blob/main/LICENSE)。商业使用前请阅读并确认符合许可证要求。

### 下载方式

**方式 A: 通过 Hugging Face CLI**

```bash
pip install huggingface-hub
# 下载 GGUF 量化版本（约 5.5 GB）
huggingface-cli download \
  bartowski/Qwen3-8B-GGUF \
  Qwen3-8B-Q4_K_M.gguf \
  --local-dir ./models/

# 或下载原始模型（约 16 GB，需自行量化）
huggingface-cli download Qwen/Qwen3-8B --local-dir ./models/Qwen3-8B/
```

**方式 B: 通过 ModelScope（国内推荐）**

```bash
pip install modelscope
python -c "
from modelscope import snapshot_download
snapshot_download('qwen/Qwen3-8B', local_dir='./models/Qwen3-8B')
"
```

### 磁盘需求

| 量化版本 | 文件大小 | 显存占用 |
|----------|----------|----------|
| Q4_K_M (推荐) | ~5.5 GB | ~6.5 GB |
| Q5_K_M | ~6.4 GB | ~7.5 GB |
| Q8_0 | ~8.6 GB | ~9.5 GB（RTX 4070 不推荐）|

---

## 3. 量化建议

**RTX 4070 8GB 的最佳实践**：

- ✅ 使用 **Q4_K_M** 格式（GGUF），在显存与质量之间取得最优平衡
- ✅ 限制上下文长度为 **4096 token**（减少 KV Cache 显存占用）
- ✅ 使用 `--n-gpu-layers 35` 将大部分层卸载到 GPU（剩余层在 CPU）
- ⚠️ 避免同时运行其他 GPU 密集型应用

**自行量化（使用 llama.cpp）**：

```bash
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp && make LLAMA_CUDA=1

# 将 HuggingFace 模型转换为 GGUF
python convert_hf_to_gguf.py ./models/Qwen3-8B/ --outtype f16 --outfile ./models/Qwen3-8B-f16.gguf

# 量化为 Q4_K_M
./llama-quantize ./models/Qwen3-8B-f16.gguf ./models/Qwen3-8B-Q4_K_M.gguf Q4_K_M
```

---

## 4. 启动方式选择

| 对比项 | Ollama | text-generation-webui |
|--------|--------|-----------------------|
| 安装难度 | ⭐ 简单（单二进制） | ⭐⭐ 中等（需 Python 环境） |
| API 兼容性 | Ollama 原生 + OpenAI 兼容 | OpenAI 兼容 |
| 界面 | 无（需 Open WebUI） | ✅ 内置 Web 界面 |
| GPU 支持 | ✅ 自动检测 | ✅ 需手动配置 |
| Docker 支持 | ✅ 官方镜像 | ✅ 官方镜像 |
| 推荐场景 | 快速启动、API 调用 | 需要 Web 界面或精细参数控制 |

**建议**: 新手或快速原型 → **Ollama**；需要 Web 调试界面 → **text-generation-webui**

---

## 5. text-generation-webui 启动步骤

### 5.1 不使用 Docker（直接运行）

```bash
git clone https://github.com/oobabooga/text-generation-webui
cd text-generation-webui

# 安装（自动检测 CUDA）
./start_linux.sh  # 首次运行会自动安装依赖

# 后续启动（带 API 服务器）
python server.py \
  --model models/Qwen3-8B-Q4_K_M.gguf \
  --load-in-4bit \
  --n-gpu-layers 35 \
  --n_ctx 4096 \
  --api \
  --listen
```

### 5.2 使用 Docker（推荐）

```bash
# 创建模型目录
mkdir -p ./models

# 将下载好的 GGUF 文件放入 ./models/

# 启动
docker run -d \
  --name qwen-webui \
  --gpus all \
  -p 7860:7860 \
  -p 5000:5000 \
  -v $(pwd)/models:/home/user/text-generation-webui/models \
  ghcr.io/oobabooga/text-generation-webui:latest \
  --model Qwen3-8B-Q4_K_M.gguf \
  --load-in-4bit \
  --n-gpu-layers 35 \
  --n_ctx 4096 \
  --api \
  --listen

# 验证 API 可用
curl http://localhost:5000/v1/models
```

### 5.3 API 接口地址

- WebUI 界面: `http://localhost:7860`
- OpenAI 兼容 API: `http://localhost:5000/v1/chat/completions`

---

## 6. Ollama 启动示例

```bash
# 安装 Ollama
curl -fsSL https://ollama.com/install.sh | sh

# 下载并运行 Qwen3 8B（自动量化为 Q4_K_M）
ollama pull qwen3:8b

# 验证运行
ollama run qwen3:8b "你好，请介绍一下天宏紧固件"

# 作为后台服务运行（监听所有接口）
OLLAMA_HOST=0.0.0.0 ollama serve &

# 或使用 Docker（GPU 版本）
docker run -d \
  --gpus all \
  --name qwen-ollama \
  -p 11434:11434 \
  -v $(pwd)/models:/root/.ollama \
  -e OLLAMA_HOST=0.0.0.0 \
  ollama/ollama:latest

# 在 Ollama 容器内拉取模型
docker exec qwen-ollama ollama pull qwen3:8b

# API 测试
curl http://localhost:11434/api/chat -d '{
  "model": "qwen3:8b",
  "messages": [{"role": "user", "content": "你好"}],
  "stream": false
}'
```

若使用 Ollama，在 `.env` 中设置：
```
MODEL_API_BASE=http://localhost:11434
MODEL_BACKEND=ollama
MODEL_NAME=qwen3:8b
```

---

## 7. WeCom Bridge 配置与启动

### 7.1 企业微信配置前置步骤

1. 登录[企业微信管理后台](https://work.weixin.qq.com/wework_admin/frame)
2. 进入 **应用管理 → 自建应用 → 创建应用**
3. 记录 **AgentId**、**Secret** 和 **CorpId**
4. 在应用设置中配置 **接收消息 API**：
   - URL: `https://ai.tnho-fasteners.com/wecom/callback`（通过 Cloudflared 暴露）
   - Token: 随机生成的字符串（写入 `.env` 的 `WECHAT_TOKEN`）
   - EncodingAESKey: 随机生成（TODO: 加密模式需在 bridge 中实现解密）

### 7.2 配置 .env 文件

```bash
cp .env.example .env
# 编辑 .env，填入所有必要的环境变量
nano .env
```

### 7.3 不使用 Docker 启动 Bridge

```bash
cd services/
pip install fastapi uvicorn httpx python-dotenv
uvicorn wecom_bridge:app --host 0.0.0.0 --port 3000 --reload
```

### 7.4 验证 Bridge 运行

```bash
# 健康检查
curl http://localhost:3000/health

# 测试内部触发端点（需设置 BRIDGE_SECRET）
curl -X POST http://localhost:3000/internal/trigger \
  -H "X-Bridge-Secret: your_bridge_secret" \
  -H "Content-Type: application/json" \
  -d '{"task": "generate_boilerplate", "args": ["--template", "rest-api"]}'
```

---

## 8. Cloudflared 隧道配置

详细步骤见 `cloudflared/config.yml` 文件中的注释。

### 快速启动

```bash
# 1. 安装 cloudflared
brew install cloudflared   # macOS
# 或 Linux: 见 cloudflared/config.yml

# 2. 登录并创建隧道
cloudflared tunnel login
cloudflared tunnel create tianhong-local-ai
# 记录输出的 <TUNNEL_ID>

# 3. 修改 cloudflared/config.yml，填入 TUNNEL_ID

# 4. 在 Cloudflare DNS 添加 CNAME 记录（见 cloudflared/config.yml 注释）

# 5. 运行隧道
cloudflared tunnel --config cloudflared/config.yml run

# 或使用 Token 方式（Docker 部署时推荐）
export CLOUDFLARED_TOKEN="从 Dashboard 获取的 Token"
cloudflared tunnel --no-autoupdate run --token $CLOUDFLARED_TOKEN
```

### systemd 服务配置（Linux 开机自启）

```bash
# 安装为系统服务
sudo cloudflared service install $CLOUDFLARED_TOKEN
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
sudo systemctl status cloudflared
```

---

## 9. Docker Compose 一键启动

```bash
# 1. 准备环境变量
cp .env.example .env
nano .env  # 填写所有变量

# 2. 准备模型文件
mkdir -p models/
# 将 Qwen3-8B-Q4_K_M.gguf 放入 models/ 目录

# 3. 启动核心服务（model-webui + wecom-bridge）
docker compose -f deployments/docker-compose.qwen_local.yml up -d

# 4. 可选：同时启动 cloudflared 隧道
docker compose -f deployments/docker-compose.qwen_local.yml \
  --profile tunnel up -d

# 5. 查看日志
docker compose -f deployments/docker-compose.qwen_local.yml logs -f wecom-bridge

# 6. 停止所有服务
docker compose -f deployments/docker-compose.qwen_local.yml down
```

---

## 10. Cursor Auto 集成说明

### 工作流程

```
企业微信消息
    ↓
WeCom Bridge（wecom_bridge.py）
    ↓ 消息以 /task 开头
trigger_cursor()（安全调用）
    ↓ 白名单校验通过
services/scripts/trigger_generate_boilerplate.sh
    ↓ TODO: 调用 Cursor Auto CLI
生成样板代码并返回结果
```

### 触发示例

在企业微信中发送：
```
/task generate_boilerplate --template rest-api
```

Bridge 将执行 `services/scripts/trigger_generate_boilerplate.sh --template rest-api` 并回复执行结果。

### 安全机制

- **白名单控制**: `ALLOWED_SCRIPTS` 字典限定可执行的脚本（在 `wecom_bridge.py` 中配置）
- **路径校验**: 通过 `Path.resolve()` 防止路径穿越攻击
- **参数校验**: 只允许字母、数字、下划线、连字符等安全字符
- **审计日志**: 所有触发事件写入 `logs/audit.log`
- ⚠️ **TODO**: 生产环境建议添加二次确认机制（如回复"确认"才执行）

---

## 11. 常见 OOM 处理策略

### 显存不足（CUDA Out of Memory）

```bash
# 方案 1: 减少 GPU 层数（更多层在 CPU 计算，速度变慢）
--n-gpu-layers 20   # 从 35 降至 20

# 方案 2: 减少上下文窗口
--n_ctx 2048   # 从 4096 降至 2048

# 方案 3: 使用更激进的量化（Q4_0 代替 Q4_K_M）
# 下载 Qwen3-8B-Q4_0.gguf 并替换

# 方案 4: 启用内存映射（仅 CPU）
--no-mmap false

# 方案 5: 限制批处理大小
--n_batch 128   # 默认 512
```

### 系统内存不足

```bash
# 检查内存使用
free -h
htop

# 增加 swap（临时）
sudo dd if=/dev/zero of=/swapfile bs=1G count=16
sudo mkswap /swapfile
sudo swapon /swapfile
```

### 查看 GPU 实时状态

```bash
watch -n 1 nvidia-smi
```

---

## 12. 安全注意事项

### 必须在生产使用前完成

- [ ] 实现企业微信消息**加解密**（WXBizMsgCrypt，当前 bridge 仅处理明文）
- [ ] 实现**消息签名验证**（校验 `msg_signature`，而非仅 `signature`）
- [ ] 使用安全存储（Redis 或数据库）管理企业微信 **access_token** 的刷新
- [ ] 对企业微信回调 IP 进行**白名单限制**（企业微信 IP 段：`101.226.0.0/17`等）
- [ ] 在 Cloudflare Zero Trust 中为管理端点设置**访问策略**
- [ ] 定期轮换 `BRIDGE_SECRET` 和 `WECHAT_TOKEN`

### 环境变量管理

- ❌ 绝不将 `.env` 文件提交到 Git 仓库
- ✅ 使用 `.env.example` 作为模板，`.env` 已在 `.gitignore` 中排除
- ✅ 生产环境使用密钥管理服务（如 HashiCorp Vault、AWS Secrets Manager）

### 模型许可合规

- Qwen3 使用 Apache 2.0 许可证，允许商业使用
- 请定期检查 [Qwen GitHub](https://github.com/QwenLM/Qwen3) 是否有许可证变更
- 使用量化模型时，确保量化工具（如 llama.cpp）的许可证也符合您的使用场景

### 审计日志

- 所有 bridge 操作写入 `logs/audit.log`
- 建议定期归档和审查审计日志
- 日志中不得包含完整的模型输出或用户消息内容（PII 保护）
