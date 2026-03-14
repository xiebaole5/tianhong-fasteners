# 仓库评估 & AI 数字人下一步架构方案

> **Repository Assessment & Recommended AI Digital-Human Architecture**
>
> 评估日期 / Date: 2026-03-14  
> 适用项目 / Project: 浙江天宏紧固件有限公司外贸独立站 (`tianhong-fasteners`)

---

## 一、当前仓库现状评估 / Current Repository Assessment

### 1.1 已完成的工作 ✅

| 模块 | 内容 | 状态 |
|------|------|------|
| **中文首页** | `index.html` — 全功能双语外贸独立站首页 | ✅ 完成 |
| **英文首页** | `en.html` — 专业英文版首页 | ✅ 完成 |
| **中文产品页** | `products.html` + `category-zh.php` — 产品展示 | ✅ 完成 |
| **英文产品页** | `en-products.html` + `category-en.php` — 英文产品展示 | ✅ 完成 |
| **产品数据** | `data/products.json` + `data/products_data.json` — 结构化产品数据 | ✅ 完成 |
| **HS 编码** | `data/hs-codes.json` — 海关编码数据 | ✅ 完成 |
| **样式系统** | Tailwind CSS 4 + Font Awesome — 响应式设计 | ✅ 完成 |
| **图片资源** | `imgs/` + `images/products/` — 专业产品图库 | ✅ 完成 |
| **CI/CD** | `.github/workflows/deploy.yml` — GitHub Pages 自动部署 | ✅ 完成 |
| **Cloudflare** | `wrangler.toml` — CDN 加速配置 | ✅ 完成 |
| **SEO 基础** | Open Graph、meta description、keywords | ✅ 完成 |

### 1.2 技术栈总结

```
前端:  HTML5 + Tailwind CSS 4 + Vanilla JavaScript
数据:  静态 JSON 文件 (products.json, hs-codes.json)
后端:  PHP 分类页 (category-zh.php / category-en.php)
部署:  GitHub Pages (静态托管) + Cloudflare CDN
构建:  npm + @tailwindcss/cli
语言:  双语 (中文 / 英文)
```

### 1.3 现有优势

- **双语完备**：中英文页面均有，适合国内外买家
- **产品数据结构化**：JSON 格式，易于扩展和接入 AI
- **部署自动化**：push 即部署，运维成本低
- **响应式设计**：支持桌面/平板/手机
- **性能优化**：CDN 加速、图片懒加载支持

### 1.4 当前缺口（相对 AI 化目标）

| 缺口 | 影响 | 优先级 |
|------|------|--------|
| 无客户交互系统 | 询盘只能靠邮件/WhatsApp，无实时响应 | 🔴 高 |
| 无知识库检索 | 买家问产品规格无法自动回答 | 🔴 高 |
| 无后端 API | AI 模块无法与网站数据联动 | 🔴 高 |
| 无语音交互 | 缺少"有生命感"的关键能力 | 🟡 中 |
| 无数字人形象 | 没有视觉载体，体验偏平 | 🟡 中 |
| 无长期记忆 | 每次对话都从零开始 | 🟡 中 |

---

## 二、推荐架构：AI 智能客服 + 数字人系统 / Recommended Architecture

基于你的情况（单人开发 + 双机硬件 + Cursor/Windsurf/Minimax 等工具链），
推荐一个**可以先活起来、再慢慢养成**的分阶段架构。

### 2.1 总体架构图

```
┌─────────────────────────────────────────────────────────────────┐
│                  天宏紧固件网站 + AI 数字人系统                    │
│                                                                   │
│  ┌─────────────┐   ┌──────────────┐   ┌──────────────────────┐  │
│  │  用户界面层  │   │   认知内核层   │   │     表达输出层        │  │
│  │  (前端+音视频)│   │  (对话+记忆)  │   │  (TTS+头像+动作)     │  │
│  └──────┬──────┘   └──────┬───────┘   └──────────┬───────────┘  │
│         │                 │                        │              │
│  ┌──────▼──────────────────▼──────────────────────▼──────────┐  │
│  │                    编排层 / Orchestrator                    │  │
│  │     状态管理 · 工具调用 · 安全过滤 · 日志 · 回放              │  │
│  └────────────────────────────────────────────────────────────┘  │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │                    数据 & 知识层                          │     │
│  │  产品JSON · 规格数据 · HS编码 · 对话记忆 · 用户档案        │     │
│  └─────────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 推荐目录结构（新增部分）

在现有网站基础上，建议新增以下结构：

```
tianhong-fasteners/
│
├── (现有网站文件，保持不变)
│   ├── index.html
│   ├── en.html
│   ├── products.html
│   ├── data/products.json
│   └── ...
│
└── ai/                              # 新增：AI 系统根目录
    │
    ├── core/                        # 认知内核
    │   ├── dialogue/                # 对话管理
    │   │   ├── orchestrator.py      # 主编排器（状态机 + 工具调用）
    │   │   ├── prompt_builder.py    # Prompt 构建（注入角色/记忆/状态）
    │   │   └── response_filter.py  # 安全过滤 + 品牌一致性
    │   │
    │   ├── memory/                  # 记忆系统
    │   │   ├── short_term.py        # 短期会话上下文
    │   │   ├── long_term.py         # 长期记忆（用户偏好、历史询盘）
    │   │   └── memory.db            # SQLite 本地存储
    │   │
    │   └── state/                   # 状态系统
    │       ├── agent_state.py       # 数字人状态变量
    │       └── state.json           # 当前状态快照
    │
    ├── character/                   # 角色配置（数字人"灵魂"）
    │   ├── persona.json             # 角色设定（名字/风格/价值观）
    │   ├── knowledge_base.json      # 产品专业知识 FAQ
    │   └── style_rules.md          # 回复风格约束
    │
    ├── voice/                       # 语音模块
    │   ├── asr.py                   # 语音识别（流式 ASR）
    │   ├── tts.py                   # 语音合成（流式 TTS）
    │   └── vad.py                   # 语音活动检测
    │
    ├── avatar/                      # 数字人形象
    │   ├── live2d/                  # 2D 头像驱动
    │   └── vrm/                     # 轻量 3D 头像（可选）
    │
    ├── api/                         # 后端 API 服务
    │   ├── chat.py                  # 聊天接口 (FastAPI)
    │   ├── inquiry.py               # 询盘处理
    │   └── product_search.py        # 产品检索
    │
    ├── ui/                          # 前端聊天组件
    │   ├── chat-widget.js           # 嵌入网站的聊天气泡
    │   ├── chat-widget.css          # 样式
    │   └── avatar-player.js         # 头像渲染 + 口型同步
    │
    └── data/                        # AI 专用数据
        ├── product_embeddings/      # 产品向量索引（RAG）
        └── conversation_logs/       # 对话日志（用于复盘和训练）
```

---

## 三、分阶段实施计划 / Phased Implementation Plan

### 🟢 Phase 0 — 先让"脑子"转起来（1-2 周）

**目标**：命令行版 AI 客服，能回答产品问题，有记忆

**做什么**：
1. 建立 `ai/character/persona.json` — 给数字人起名字、定风格
2. 建立 `ai/character/knowledge_base.json` — 把 `data/products.json` 转为 FAQ 格式
3. 写 `ai/core/dialogue/orchestrator.py` — 简单的 Python 脚本，连接 LLM API
4. 写 `ai/core/memory/short_term.py` — SQLite 存当前对话上下文
5. 命令行测试：能多轮问答、记住用户说过的话

**推荐技术选型**：
- Python 3.11+
- LLM：Minimax API（你已有） 或 OpenAI-compatible 接口
- 存储：SQLite（轻量、无需安装）
- 框架：无框架，纯 Python 先跑通

**persona.json 示例**：
```json
{
  "name": "小宏",
  "role": "天宏紧固件专业顾问",
  "personality": "专业、热情、简洁、有条理",
  "language_style": "中英双语，根据用户语言自动切换",
  "expertise": ["高强度螺栓", "不锈钢紧固件", "Dacromet涂层", "定制加工"],
  "greeting": "您好！我是天宏紧固件的专业顾问小宏，请问您需要了解哪类紧固件？",
  "mood": "专注",
  "energy": 100
}
```

---

### 🔵 Phase 1 — 嵌入网站（2-3 周）

**目标**：网站右下角出现 AI 聊天气泡，买家可直接对话

**做什么**：
1. 写 `ai/api/chat.py` — FastAPI 后端，暴露 `/chat` 接口
2. 写 `ai/ui/chat-widget.js` — 前端聊天组件，嵌入 `index.html` 和 `en.html`
3. 实现产品知识检索（RAG 简化版）：
   - 买家问"有没有 M12 的不锈钢螺栓？"
   - 系统查 `data/products.json` 匹配并回答
4. 对接询盘流程：对话结束时引导填写询盘表单

**架构示意**：
```
买家浏览器                    本地/云端服务器
    │                              │
    │  POST /chat {"message":"..."}│
    ├─────────────────────────────►│
    │                              │ 1. 检索 products.json
    │                              │ 2. 构建 Prompt（角色+记忆+产品知识）
    │                              │ 3. 调用 LLM API
    │                              │ 4. 保存记忆
    │  {"reply":"...", "products"} │
    │◄─────────────────────────────┤
```

**部署建议**：
- 本地开发：`uvicorn ai.api.chat:app --reload`
- 生产：Cloudflare Workers 或 Railway（免费层）
- 如需本地推理：Ollama + llama3 / Qwen2.5

---

### 🟡 Phase 2 — 加上语音，第一次"活起来"（2-3 周）

**目标**：用户可以说话，数字人会开口回答

**做什么**：
1. `ai/voice/asr.py` — 浏览器麦克风 → Web Speech API 或流式 ASR
2. `ai/voice/tts.py` — LLM 回复 → 语音合成（Minimax TTS / 边缘端 TTS）
3. VAD 检测（用户说完自动触发）
4. 实现基本打断：用户新说话时，停止当前语音播放
5. 情绪语音：根据状态变量（`mood`）控制 TTS 语调

**推荐 TTS 选型**：
| 方案 | 延迟 | 效果 | 成本 |
|------|------|------|------|
| Minimax TTS | ~300ms | ⭐⭐⭐⭐ | 按量付费 |
| EdgeTTS（微软） | ~500ms | ⭐⭐⭐ | 免费 |
| CosyVoice（阿里） | ~200ms | ⭐⭐⭐⭐ | 可本地部署 |
| 本地 kokoro-tts | ~100ms | ⭐⭐⭐ | 免费，3080Ti 可跑 |

---

### 🟠 Phase 3 — 加上形象（3-4 周）

**目标**：数字人有固定形象，说话时口型动，有 idle 动画

**做什么**：
1. 选择 2D Live2D 角色模型（或使用 VRM 3D 模型）
2. 接入口型同步：TTS 音频 → 口型关键帧驱动
3. 表情控制：根据 `mood` 状态切换表情
4. Idle 动画：没有说话时有自然的待机动作
5. 嵌入网站：替换聊天气泡为浮动数字人窗口

**推荐技术**：
- 2D Live2D：`pixi-live2d-display`（Web 端，轻量）
- 轻量 3D：`three-vrm`（Three.js + VRM 格式）
- 口型同步：`rhubarb-lip-sync` 或 Minimax 返回音素时间轴

---

### 🔴 Phase 4 — 养成系统（持续迭代）

**目标**：数字人有记忆、有状态、会成长

**做什么**：
1. **长期记忆**：记住每个买家，记住历史询盘，记住偏好
2. **状态系统**：`mood` / `energy` / `affinity` 随交互变化
3. **主动性**：离线后再次进入，数字人主动问候并提及上次话题
4. **关系成长**：亲密度影响回复风格（陌生人 → 熟悉客户）
5. **运营后台**：可回放对话、查看询盘漏斗、调整话术

**状态变量示例**：
```python
agent_state = {
    "mood": "专注",          # 开心/平静/专注/疲惫
    "energy": 88,            # 0-100
    "session_count": 142,    # 总对话次数
    "affinity": {            # 与特定用户的亲密度
        "user_123": 65,
    },
    "last_active": "2026-03-14T09:30:00",
    "ongoing_topics": ["M12不锈钢螺栓", "达克罗工艺"],
}
```

---

## 四、技术选型汇总 / Recommended Tech Stack

```
类别            推荐方案                        备注
─────────────────────────────────────────────────────────────────
LLM             Minimax API / Qwen2.5-72B       你已有 Minimax 账号
本地推理        Ollama + Qwen2.5-7B             3080Ti 完全可跑
后端框架        Python + FastAPI                AI 生态最友好
存储            SQLite + JSON                   单人项目够用，不引入 DB 服务
向量检索        FAISS（本地）                   Phase 1 不需要，Phase 2 可加
TTS             Minimax TTS / CosyVoice         按延迟要求选择
ASR             Web Speech API / FunASR         Web Speech API 免费无需部署
2D 头像         pixi-live2d-display             前端原生支持
3D 头像         three-vrm                       可选，资源更少
前端组件        Vanilla JS（融入现有网站风格）   保持一致性
部署            Cloudflare Workers + 本地服务   静态页走 CF，AI API 走本地/云
```

---

## 五、给你的直白建议 / Practical Advice for Solo Development

### ✅ 建议做

1. **先把产品 JSON 变成 FAQ** — 这是最快见效的投入，AI 一开口就是专家
2. **用 Minimax 或 OpenAI 兼容接口起步** — 本地模型可以后补，别一开始卡在推理速度
3. **每个 phase 都先在命令行跑通，再做 UI** — 省去大量调试时间
4. **把 `persona.json` 做成可以随时改的配置文件** — 你会想一直调整角色设定
5. **用 SQLite 记录所有对话** — 这是你最宝贵的"养成资产"，别丢掉

### ❌ 建议暂时不做

1. **超写实 3D 建模** — 在"脑子"没跑通之前，脸再好看也没用
2. **自训 LLM 底座** — 上层应用能力比底座更影响体验
3. **多平台同时上线** — 先一个平台做到真正好用
4. **过度复杂的架构** — 一个人维护 Kafka + Redis + Milvus + Mongo 会累死

### ⚡ 你的硬件怎么用

| 机器 | 用途 |
|------|------|
| 台式 i7-13700 + 3080Ti | 主力开发 + 本地 LLM 推理 (Ollama) + TTS 推理 |
| 笔记本 i7-13700 + 4070 | 前端开发 + 测试环境 + Unity/VRM 调试 |

3080Ti（12GB VRAM）可以流畅运行：
- Qwen2.5-7B / Qwen2.5-14B（Q4量化）
- CosyVoice-300M（实时 TTS）
- kokoro-82M（超低延迟 TTS）

---

## 六、下一步行动清单 / Immediate Next Steps

- [ ] **Day 1**：创建 `ai/character/persona.json`，给数字人起名字和设定人设
- [ ] **Day 1-2**：把 `data/products.json` 转成结构化 FAQ（`ai/character/knowledge_base.json`）
- [ ] **Day 3-5**：写 `ai/core/dialogue/orchestrator.py`，命令行版本跑起来
- [ ] **Day 5-7**：接入短期记忆，实现 10 轮以上稳定对话
- [ ] **Week 2**：FastAPI 后端，网站嵌入聊天 widget
- [ ] **Week 3**：接入 TTS，第一次听到数字人说话
- [ ] **Month 2**：加上 Live2D 形象，完成第一个"有脸有声音"的版本
- [ ] **持续**：每天加一点状态变量、记忆条目、人设细节，让它慢慢活起来

---

## 七、参考资源 / References

| 资源 | 用途 |
|------|------|
| [Minimax API Docs](https://platform.minimaxi.com/document/guides) | LLM + TTS API 调用 |
| [Ollama](https://ollama.com) | 本地 LLM 部署 |
| [FastAPI](https://fastapi.tiangolo.com) | Python 后端 API |
| [pixi-live2d-display](https://github.com/guansss/pixi-live2d-display) | Web Live2D 渲染 |
| [three-vrm](https://github.com/pixiv/three-vrm) | Web VRM 3D 头像 |
| [CosyVoice](https://github.com/FunAudioLLM/CosyVoice) | 阿里开源 TTS（可本地部署） |
| [FunASR](https://github.com/modelscope/FunASR) | 高精度中文 ASR |
| [kokoro-onnx](https://github.com/thewh1teagle/kokoro-onnx) | 超轻量 TTS（<100ms 延迟） |

---

*文档生成：GitHub Copilot 仓库评估 | 基于 `master` 分支状态*
