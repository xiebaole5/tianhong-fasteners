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

## 二、Dify 详解 —— 它到底是什么？

### 2.1 一句话定义

> **Dify 是一个开源的 LLM（大语言模型）应用开发平台**，让你无需深入编程就能把 AI 模型变成可用的产品、工作流或 API 服务。

- **不是**某个 AI 模型本身（它不会"想"东西）
- **不是**聊天机器人 App（它是制造聊天机器人的工厂）
- **是**把 ChatGPT / 文心 / 通义等大模型**接进来、管起来、用起来**的中间平台

---

### 2.2 背景与来源

| 项目 | 详情 |
|------|------|
| 主导团队 | LangGenius（朗极科技），上海，2023 年成立 |
| 开源协议 | Apache-2.0（可免费商用，须保留版权声明） |
| GitHub 地址 | https://github.com/langgenius/dify |
| GitHub Stars | 80,000+（截至 2026 年，活跃度极高） |
| 官网 | https://dify.ai |
| 中文文档 | https://docs.dify.ai/zh-hans |
| 使用方式 | ① 直接用官网 SaaS 云版本（免费起步）② 自己服务器本地私有化部署 |

---

### 2.3 核心模块（它能做什么）

Dify 的界面由以下几个核心模块组成：

#### 🔵 聊天助手（Chatbot）
最基础的模块。把大模型接进来，加上你自己写的**系统提示词**（System Prompt），就得到一个专属的 AI 对话助手。

**天宏紧固件用途示例**：
- "产品查询助手"：输入螺丝规格，AI 自动回答库存、价格、交期
- "客服回复助手"：根据历史邮件模板，自动起草外贸回复

---

#### 🟣 工作流（Workflow）
这是 Dify 最强大的模块，也是它最接近"AI 执行中枢"的地方。

**原理**：用可视化拖拽画板，把多个步骤串成流水线。每一步可以是：
- 调用 AI 模型生成文字
- 调用外部 HTTP API（如查 ERP 数据库、发飞书消息）
- 执行代码（Python/JavaScript）
- 条件判断（if/else 分支）
- 循环处理列表数据

```
用户输入订单号
    ↓
[HTTP 节点] 查询 ERP 系统获取订单详情
    ↓
[AI 节点] 让大模型分析交期风险并生成中文摘要
    ↓
[HTTP 节点] 把摘要通过飞书 Webhook 发给销售负责人
    ↓
输出"已通知"
```

---

#### 🟠 知识库（Knowledge Base）
把你自己的文档（PDF、Word、Excel、网页等）上传进来，Dify 会把它们向量化存储。用户提问时，AI 先在知识库里检索相关内容，再结合大模型生成准确答案——这就是 **RAG（检索增强生成）**。

**天宏紧固件用途示例**：
- 上传所有产品规格书 PDF → AI 能准确回答"M8×30 的抗拉强度是多少"
- 上传质量体系文件 → 员工可直接问 AI 操作规程，不用翻文件

---

#### 🟡 Agent（智能体）
赋予 AI 使用"工具"的能力。你可以注册工具（如搜索引擎、计算器、自定义 API），AI 会自主判断什么时候该调用哪个工具，直到完成目标。

与工作流的区别：工作流是**固定流程**，Agent 是 AI **自主规划步骤**。

---

#### ⚪ API 服务（API-as-a-Service）
每个 Dify 应用创建后，Dify 自动为它生成一套 REST API。你的其他系统（ERP、网站、飞书机器人）可以直接调用这个 API，不需要懂 AI 开发。

---

### 2.4 支持哪些 AI 大模型

Dify 支持 100+ 个模型供应商，包括：

| 类型 | 模型 |
|------|------|
| 国内模型（推荐） | 文心一言（百度）、通义千问（阿里）、智谱 GLM（清华）、Kimi（月之暗面）、豆包（字节）、DeepSeek |
| 国际模型 | OpenAI GPT-4o、Claude 3.5、Gemini |
| 本地私有部署 | Ollama（本地运行开源模型，完全离线） |

> **工厂/企业网络建议**：优先接入国内模型（文心/通义/DeepSeek），稳定、快速、无需翻墙，且数据不出国境。

---

### 2.5 技术架构（了解即可）

```
┌─────────────────────────────────────────┐
│              Dify 服务组成               │
├──────────┬──────────┬────────┬──────────┤
│ Web 前端  │  API 后端 │ Worker │  向量数据库 │
│ (Next.js)│ (Python) │(Celery)│(Weaviate) │
├──────────┴──────────┴────────┴──────────┤
│         PostgreSQL（业务数据）           │
│         Redis（缓存/队列）               │
└─────────────────────────────────────────┘
```

Docker Compose 一键启动以上所有组件，无需分别安装。

---

### 2.6 在哪里

- **官网 SaaS（直接用，无需部署）**: https://cloud.dify.ai
- **GitHub**: https://github.com/langgenius/dify
- **中文文档**: https://docs.dify.ai/zh-hans

### 本地/私有化部署（Docker，推荐）

```bash
# 1. 克隆仓库
git clone https://github.com/langgenius/dify.git
cd dify/docker

# 2. 复制环境配置
cp .env.example .env

# 3. 启动所有服务（Web + API + Worker + 数据库，约需 2~3 分钟首次启动）
docker compose up -d

# 查看运行状态
docker compose ps

# 访问地址: http://localhost
# 首次访问需设置管理员账号
```

**服务器最低配置要求**：
- CPU：2 核
- 内存：4 GB（建议 8 GB）
- 硬盘：20 GB（知识库文件另算）

> 国内网络拉取 Docker 镜像较慢时，可在 `/etc/docker/daemon.json` 中添加镜像加速（URL 以各云厂商最新文档为准，以下仅供参考）：
> ```json
> { "registry-mirrors": ["https://mirror.ccs.tencentyun.com", "https://registry.cn-hangzhou.aliyuncs.com"] }
> ```
> 请到 [腾讯云容器镜像服务](https://cloud.tencent.com/document/product/457/9113) 或 [阿里云镜像加速](https://help.aliyun.com/document_detail/60750.html) 获取当前有效地址。

### Python SDK（从代码中调用 Dify）

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
