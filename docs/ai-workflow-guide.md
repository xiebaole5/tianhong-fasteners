# AI 工作流与自动化平台指南

> 本文档适用于 **天宏紧固件 ERP/自动化环境**，介绍对中文友好的开源 AI 工作流与执行平台。

---

## ⚠️ 关于"NexusCore"的说明

网络上流传的"NexusCore（中国版 OpenClaw/OpenCloud，AI 执行中枢）"及其安装命令（`get.nexuscore.ai`、`nexuscore/nexuscore` Docker 镜像、`nexuscore-sdk` PyPI 包）**均未对应任何可验证的真实开源项目**，其相关描述很可能来自 AI 大模型的虚构输出（幻觉）。

如果你正在寻找：
- 对中文友好的 AI 工作流平台
- 可本地私有化部署
- 支持飞书/企业微信等国内系统对接

→ 请参考下方**真实存在、持续维护的开源替代方案**。

---

## 一、真实替代方案概览

| 工具 | 定位 | 中文支持 | 开源协议 | GitHub |
|------|------|----------|----------|--------|
| **Dify** | LLM 应用开发 + 工作流编排 | ✅ 原生支持 | Apache-2.0 | https://github.com/langgenius/dify |
| **FastGPT** | 知识库 + AI 问答 | ✅ 原生支持 | MIT | https://github.com/labring/FastGPT |
| **Coze（扣子）** | AI Bot 平台（字节跳动） | ✅ 国内版 | 商业（免费层） | https://www.coze.cn |

---

## 二、Dify —— 推荐首选

[Dify](https://github.com/langgenius/dify) 是国内团队（上海应流科技）主导的开源 LLM 应用开发平台，最接近"AI 执行中枢"的描述，支持：

- 可视化 Workflow 编排（类似 n8n + LangChain）
- 知识库 RAG（检索增强生成）
- API 集成与飞书机器人对接
- 国内主流大模型（文心、通义、智谱、Kimi 等）

### 在哪里

- **官网**: https://dify.ai
- **GitHub**: https://github.com/langgenius/dify
- **文档**: https://docs.dify.ai/zh-hans

### 本地部署（Docker，推荐）

```bash
# 1. 克隆仓库
git clone https://github.com/langgenius/dify.git
cd dify/docker

# 2. 复制环境配置
cp .env.example .env

# 3. 启动服务（包含 Web、API、Worker、数据库）
docker compose up -d

# 访问地址: http://localhost
```

> 国内网络若拉取 Docker 镜像较慢，可先配置 Docker 镜像加速（阿里云/腾讯云）。

### Python SDK

```bash
pip install dify-client
```

```python
from dify_client import ChatClient

client = ChatClient(api_key="your-api-key", base_url="http://your-dify-host/v1")
response = client.create_chat_message(
    inputs={},
    query="你好，请介绍天宏紧固件的产品",
    user="erp-user-001"
)
print(response.get_answer())
```

---

## 三、FastGPT —— 知识库问答

[FastGPT](https://github.com/labring/FastGPT) 专注于企业知识库搭建，适合将产品手册、ERP 操作文档向量化后进行智能问答。

- **GitHub**: https://github.com/labring/FastGPT
- **文档**: https://doc.fastgpt.in

### Docker 部署

```bash
# 使用官方 docker-compose 一键部署
git clone https://github.com/labring/FastGPT.git
cd FastGPT/files/docker
docker compose up -d
```

---

## 四、与问题中描述的对比

| 描述（问题原文） | 真实对应方案 |
|------------------|--------------|
| "中文极友好" | Dify、FastGPT 均原生支持中文界面和提示词 |
| "AI 执行中枢" | Dify 的 Workflow 编排功能 |
| `curl -fsSL https://get.nexuscore.ai \| sh` | `docker compose up -d`（Dify 官方推荐方式） |
| `docker run nexuscore/nexuscore:latest` | `docker compose up -d`（Dify docker 目录） |
| `pip install nexuscore-sdk` | `pip install dify-client` |
| 飞书自动化对接 | Dify 支持飞书机器人 Webhook 集成 |

---

## 五、飞书 + Dify 快速上手

1. **部署 Dify**（见上方 Docker 部署步骤）
2. **创建 Dify 应用** → 在 Dify 管理界面新建"聊天助手"或"工作流"应用
3. **获取 API Key** → 应用设置 → 访问 API → 复制 API Key
4. **飞书机器人配置**：
   - 在飞书开放平台创建自定义机器人
   - 将机器人 Webhook URL 作为触发器
   - 在 Dify Workflow 中添加 HTTP 请求节点，POST 到 Dify API

```bash
# 测试 Dify API（替换为实际地址和 Key）
curl -X POST http://localhost/v1/chat-messages \
  -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{"inputs":{},"query":"今天有哪些订单需要跟进？","response_mode":"blocking","user":"feishu-bot"}'
```

---

## 六、相关资源

- **Dify GitHub**: https://github.com/langgenius/dify
- **FastGPT GitHub**: https://github.com/labring/FastGPT
- **Coze（扣子）国内版**: https://www.coze.cn
- **飞书开放平台**: https://open.feishu.cn
- **Docker 国内镜像加速**: https://docker.mirrors.ustc.edu.cn

---

*文档维护：天宏紧固件技术团队 | 最后更新：2026 年 3 月*
