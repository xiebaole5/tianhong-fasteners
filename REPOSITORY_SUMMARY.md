# 仓库文件总结 / Repository File Summary

**仓库名称 / Repository**: `xiebaole5/tianhong-fasteners`  
**分支 / Branch**: `master`  
**文档版本 / Version**: 1.0  
**更新日期 / Updated**: 2026-02-28  

---

## 项目概述 / Project Overview

本仓库是**浙江天宏紧固件有限公司**（Zhejiang Tianhong Fasteners Co., Ltd.）的外贸独立站项目。该公司成立于1987年，专业生产高难度、高强度、异形紧固件，产品涵盖六角螺栓、螺母、U型螺栓、Dacromet涂层螺栓等，广泛应用于汽车、太阳能、机械设备等行业。

网站采用**静态 HTML 为主体**，辅以少量 PHP 组件，部署于 GitHub Pages 或 Cloudflare Pages，无需后端服务器即可运行。

---

## 目录结构总览 / Directory Tree

```
tianhong-fasteners/
├── index.html                  # 网站首页（核心页面）
├── products.html               # 产品展示页
├── config.php                  # 全局配置文件
├── _redirects                  # Cloudflare Pages 路由重定向规则
├── wrangler.toml               # Cloudflare Workers/Pages 部署配置
├── .gitignore                  # Git 版本控制忽略规则
│
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions 自动部署工作流
│
├── images/
│   ├── logo.png                # 公司 Logo（纯图标版）
│   ├── logo_with_text.png      # 公司 Logo（带文字版）
│   └── products/               # 产品图片目录（11张）
│       ├── hex-bolt-1.png
│       ├── stainless-nuts.jpg
│       ├── custom-fasteners.jpg
│       ├── dacromet-bolt.webp
│       ├── fastener-assembly.jpg
│       ├── hex-flange-bolt.jpg
│       ├── special-fasteners.jpg
│       ├── special-shaped-screws.webp
│       ├── stainless-hex-bolt.jpg
│       ├── hex-socket-screw.webp
│       └── zinc-plated-bolt.jpg
│
├── imgs/                       # 高质量紧固件素材图库（18张）
│   ├── tnho-tianhong-fastener-corporate-logo-banner.jpg
│   ├── industrial-fastener-*.jpg  (多张产品展示图)
│   ├── dacromet-coated-*.jpg      (Dacromet 涂层系列)
│   ├── custom-*.jpg               (定制件系列)
│   └── professional-*.jpg         (专业展示系列)
│
├── includes/
│   ├── header.php              # 公共页头 PHP 组件
│   └── footer.php              # 公共页脚 PHP 组件
│
├── 设计文档/
│   └── 首页设计改进方案.md      # 中文版首页设计改进详细方案
│
├── README.md                   # 项目说明文档
├── DEPLOYMENT.md               # GitHub Pages + Cloudflare 部署指南
├── MANUAL_DEPLOYMENT.md        # 手动部署分步操作指南
├── REPOSITORY_SUMMARY.md       # 本文件：仓库文件内容总结
│
├── check_status.py             # 检查 GitHub Actions / Pages 部署状态
├── deploy_to_github.py         # 自动创建仓库并推送代码
├── create_github_repo.py       # 创建 GitHub 仓库脚本
├── enable_pages.py             # 通过 API 启用 GitHub Pages
├── create-github-repo.bat      # Windows 批处理：创建 GitHub 仓库
├── create-github-repo.ps1      # PowerShell：创建 GitHub 仓库
│
└── [根目录图片] *.jpg           # 工厂/产品现场实拍图（12张）
    ├── banner.jpg
    ├── ccd_machine.jpg
    ├── certificates.jpg
    ├── customers.jpg
    ├── dental_line.jpg
    ├── laboratory.jpg
    ├── meeting.jpg
    ├── production_line.jpg
    ├── reception.jpg
    ├── timeline.jpg
    ├── warehouse.jpg
    └── workshop.jpg
```

---

## 各文件详细说明 / File Details

### 一、核心网页文件

#### 1. `index.html` — 网站首页
| 属性 | 说明 |
|------|------|
| **类型** | HTML5 静态网页 |
| **格式** | UTF-8 编码，单文件自包含（内嵌全部 CSS 和 JavaScript） |
| **大小** | ~83.9 KB（单体最大文件）|
| **用途** | 网站主入口页面，包含完整的公司展示内容 |

**典型内容与结构**：
- `<head>` —— SEO Meta 标签（description、keywords、Open Graph）、Google Fonts（Inter/Poppins）、Font Awesome 6.4 图标库引入
- **预加载动画**（Preloader）—— CSS 旋转动画
- **顶部导航栏** —— 公司名称、主菜单（Home / Products / About / Contact）、"Get Quote"按钮
- **Hero Banner 轮播区** —— 3个轮播页，展示工厂全景/30年经验/质量认证
- **核心优势统计区** —— 30+年历史、200+设备、10000+㎡厂房、200+员工
- **关于我们** —— 公司简介、发展历程
- **产品分类展示** —— 8大类紧固件（长紧固件、高强度、特殊头型等）
- **精选产品展示** —— 图片卡片网格布局
- **行业应用** —— 汽车、太阳能、机械、电力仪表
- **证书展示区** —— ISO9001、ISO14001、IATF16949等
- **合作客户** —— 客户 Logo 展示
- **询盘表单区** —— WhatsApp 快捷联系 + 在线询盘表单
- **页脚** —— 公司信息、快速链接、联系方式、版权信息
- **内嵌 JavaScript** —— 导航滚动固定、轮播切换、表单验证、返回顶部、WhatsApp 浮动按钮

**CSS 变量设计**：
```css
--primary-color: #0d1b2a   /* 深海蓝（主色调）*/
--accent-color:  #e63946   /* 活力红（强调色）*/
--text-color:    #e0e1dd   /* 浅灰白（正文）*/
```

---

#### 2. `products.html` — 产品展示页
| 属性 | 说明 |
|------|------|
| **类型** | PHP/HTML 混合页面（含 PHP 变量声明头部） |
| **格式** | UTF-8，PHP 头 + HTML5 主体，内嵌 CSS |
| **用途** | 独立产品展示页，按分类展示全部产品 |

**典型内容与结构**：
- PHP 头部声明 `$page_title` 和 `$page_description` 变量
- 产品卡片网格（8个精选产品，使用 `images/products/` 目录中的真实图片）
- 产品分类图标区（9大类）
- 行动召唤区（询盘 / WhatsApp 联系）
- 响应式设计，适配桌面、平板、手机

**CSS 变量设计**：
```css
--primary-color: #1a5f7a   /* 工业蓝 */
--accent-color:  #c38e70   /* 暖金色 */
```

---

### 二、PHP 组件与配置文件

#### 3. `config.php` — 全局配置文件
| 属性 | 说明 |
|------|------|
| **类型** | PHP 配置文件 |
| **格式** | PHP `define()` 常量 + 数组定义 |
| **用途** | 集中管理网站所有可配置项，供各页面引用 |

**数据结构**：
```php
// 字符串常量
define('SITE_NAME', '天宏紧固件 | 专业紧固件制造商');
define('COMPANY_NAME', '浙江天宏紧固件有限公司');
define('COMPANY_PHONE', '+86 18958770140');
define('COMPANY_EMAIL', 'xiebaole5@gmail.com');

// 关联数组 - 产品分类
define('PRODUCT_CATEGORIES', [
    ['id' => 'long-fasteners', 'name' => 'Long Fasteners',
     'name_cn' => '长紧固件', 'description' => '...'],
    // ... 共8个分类
]);

// 关联数组 - 服务行业
define('INDUSTRIES', [
    'Automotive Fasteners' => '...',
    // ... 共4个行业
]);

// 邮件 SMTP 配置（需填入真实值）
define('SMTP_HOST', 'smtp.yourdomain.com');
define('SMTP_PORT', 587);
```

**在项目中的作用**：作为整个 PHP 网站的数据中心，避免在各页面中重复写入相同的公司信息，方便统一维护。

---

#### 4. `includes/header.php` — 公共页头组件
| 属性 | 说明 |
|------|------|
| **类型** | PHP HTML 模板片段 |
| **格式** | PHP + HTML5，依赖 `config.php` 中定义的常量 |
| **用途** | 所有 PHP 页面共享的头部（`<head>` + 顶部栏 + 主导航） |

**包含内容**：
- `<head>` 完整 Meta 标签（含 Open Graph / Twitter Card）
- Bootstrap 4.6、AOS 动画库、Font Awesome 6.4 引入
- 顶部联系栏（地址、电话、邮箱、Facebook、LinkedIn 链接）
- 主导航栏（含下拉菜单、"Get Quote" CTA 按钮）
- 预加载动画区块
- 可选的 Page Banner（由页面变量 `$show_banner` 控制）
- Schema.org `Organization` 结构化数据（JSON-LD）

---

#### 5. `includes/footer.php` — 公共页脚组件
| 属性 | 说明 |
|------|------|
| **类型** | PHP HTML 模板片段 |
| **格式** | PHP + HTML5 |
| **用途** | 所有 PHP 页面共享的底部（页脚 + JS 引入 + 浮动按钮） |

**包含内容**：
- 四栏页脚布局：公司简介 / 快速链接 / 产品分类 / 联系方式
- 社交媒体链接（Facebook、LinkedIn、YouTube、WhatsApp）
- 版权信息、隐私政策、服务条款链接
- "返回顶部"按钮
- WhatsApp 浮动联系按钮
- 在线询盘弹窗（Modal）及表单（含文件上传）
- JavaScript 引入：jQuery 3.6.3、Bootstrap 4.6、AOS 2.3.1

---

### 三、部署配置文件

#### 6. `.github/workflows/deploy.yml` — GitHub Actions 自动部署工作流
| 属性 | 说明 |
|------|------|
| **类型** | YAML 工作流配置文件 |
| **格式** | GitHub Actions 标准格式 |
| **用途** | 每次推送到 `main` 分支时自动将网站部署到 GitHub Pages |

**关键配置**：
```yaml
on:
  push:
    branches: [ main ]      # 推送 main 分支时触发
  workflow_dispatch:         # 支持手动触发

permissions:
  pages: write               # 需要 Pages 写权限
  id-token: write            # 需要 OIDC 令牌

jobs:
  deploy:
    steps:
      - uses: actions/checkout@v4
      - uses: actions/configure-pages@v4
      - uses: actions/upload-pages-artifact@v3
          with: { path: '.' }   # 上传整个仓库根目录
      - uses: actions/deploy-pages@v4
```

---

#### 7. `wrangler.toml` — Cloudflare Pages/Workers 配置
| 属性 | 说明 |
|------|------|
| **类型** | TOML 格式配置文件 |
| **格式** | Cloudflare Wrangler CLI 标准配置 |
| **用途** | 配置 Cloudflare Pages 静态网站托管，指定资产目录 |

```toml
name = "tianhong-fasteners"
compatibility_date = "2026-02-07"

[assets]
directory = "."       # 部署整个根目录
binding = "ASSETS"
```

---

#### 8. `_redirects` — Cloudflare Pages 路由规则
| 属性 | 说明 |
|------|------|
| **类型** | 纯文本，Cloudflare Pages 专有格式 |
| **格式** | `源路径 目标路径 [HTTP状态码]` 每行一条规则 |
| **用途** | 配置 URL 重定向和静态资源缓存控制 |

当前所有规则均被注释，文件处于"待启用"状态，预设了：
- 清洁 URL 重定向（`/products.html` → `/products`）
- SPA fallback 规则
- 图片缓存时间配置（31536000秒 = 1年）

---

#### 9. `.gitignore` — Git 忽略规则
| 属性 | 说明 |
|------|------|
| **类型** | Git 配置文件 |
| **格式** | 每行一条 glob 匹配规则 |
| **用途** | 防止将依赖目录、构建产物、敏感文件提交到仓库 |

**关键规则**：
- 忽略：`node_modules/`、`dist/`、`build/`、`.env`、`*.sql`
- 忽略：大多数 `*.html` 文件（**例外**：保留 `index.html` 和 `products.html`）
- 保留：`.github/workflows/`（显式取消忽略）
- 保留：`设计文档/` 目录

---

### 四、Python 自动化脚本

> **安全说明**：所有脚本均已更新，通过 `GITHUB_TOKEN` 环境变量读取认证令牌，不再硬编码凭据。运行前请先设置环境变量：`export GITHUB_TOKEN=你的令牌`

#### 10. `create_github_repo.py` — 创建 GitHub 仓库
| 属性 | 说明 |
|------|------|
| **类型** | Python 3 脚本 |
| **依赖** | `requests`、`subprocess`、`os` |
| **用途** | 通过 GitHub REST API 创建 `tianhong-fasteners` 仓库，并将本地代码推送 |

**主要流程**：
1. 调用 `POST /user/repos` 创建仓库
2. 调用 `git remote add origin` + `git push` 推送代码

---

#### 11. `deploy_to_github.py` — 创建仓库并推送（功能增强版）
| 属性 | 说明 |
|------|------|
| **类型** | Python 3 脚本 |
| **依赖** | `requests`、`subprocess`、`json`、`os`、`sys` |
| **用途** | 与 `create_github_repo.py` 功能类似，新增了更详细的输出和错误处理 |

---

#### 12. `check_status.py` — 检查部署状态
| 属性 | 说明 |
|------|------|
| **类型** | Python 3 脚本 |
| **依赖** | `requests`、`os`、`time` |
| **用途** | 查询 GitHub Actions 最新工作流运行状态和 GitHub Pages 发布状态 |

**主要函数**：
- `check_actions_status()` —— 调用 `GET /repos/{owner}/{repo}/actions/runs`
- `check_pages_status()` —— 调用 `GET /repos/{owner}/{repo}/pages`
- `print_summary()` —— 输出仓库和 Pages URL 汇总

---

#### 13. `enable_pages.py` — 通过 API 启用 GitHub Pages
| 属性 | 说明 |
|------|------|
| **类型** | Python 3 脚本 |
| **依赖** | `requests`、`os` |
| **用途** | 通过 GitHub REST API 自动开启仓库的 GitHub Pages 功能（无需手动进入 Settings） |

---

### 五、Windows 部署脚本

#### 14. `create-github-repo.bat` — Windows 批处理脚本
| 属性 | 说明 |
|------|------|
| **类型** | Windows 批处理文件（BAT） |
| **用途** | 在 Windows 命令行下通过 PowerShell 调用 GitHub API 创建仓库 |
| **运行要求** | 需预先设置 `GITHUB_TOKEN` 环境变量 |

---

#### 15. `create-github-repo.ps1` — PowerShell 脚本
| 属性 | 说明 |
|------|------|
| **类型** | PowerShell 脚本 |
| **用途** | PowerShell 原生方式创建 GitHub 仓库，与 BAT 功能等价 |
| **运行要求** | 需预先设置 `$env:GITHUB_TOKEN` 环境变量 |

---

### 六、文档文件

#### 16. `README.md` — 项目说明文档
| 属性 | 说明 |
|------|------|
| **类型** | Markdown 文档 |
| **用途** | 项目整体说明，包含已完成工作清单、文件结构、本地预览和部署方法 |

**主要内容**：
- 已完成工作汇总（GitHub Pages 配置、产品图片库、products.html 页面）
- 完整文件结构树
- 本地预览方法（Python HTTP 服务器 / PHP 内置服务器）
- 快速部署到 GitHub Pages 的命令
- 图片优化和懒加载建议
- 下一步规划（多语言、询盘后端、在线报价系统）

---

#### 17. `DEPLOYMENT.md` — 自动部署指南
| 属性 | 说明 |
|------|------|
| **类型** | Markdown 文档 |
| **用途** | GitHub Pages + Cloudflare CDN 完整部署方案说明 |

**覆盖内容**：GitHub Pages 开启方法、Cloudflare 配置、自定义域名绑定、故障排除、维护建议

---

#### 18. `MANUAL_DEPLOYMENT.md` — 手动部署指南
| 属性 | 说明 |
|------|------|
| **类型** | Markdown 文档 |
| **用途** | 针对非技术用户，提供分步操作的详细说明（含截图描述） |

**覆盖内容**：创建 GitHub 仓库→推送代码→启用 Pages→配置 Cloudflare Pages→验证结果

---

#### 19. `设计文档/首页设计改进方案.md` — UI 设计规范文档
| 属性 | 说明 |
|------|------|
| **类型** | Markdown 文档（中文） |
| **用途** | 首页全面改版的详细设计方案，可作为第三方开发团队的执行依据 |

**文档结构**（共十章）：
1. 项目背景概述
2. 现有设计分析（优势与问题）
3. 设计改进方案（理念、页面结构、配色、字体）
4. 技术实现要求（Bootstrap 4.6、AOS、Font Awesome）
5. 具体开发任务清单
6. 内容素材要求（图片规格、推荐文案）
7. 公司联系信息
8. 后续开发计划
9. 验收标准（设计/功能/性能）
10. 文档总结

---

### 七、图片资源文件

#### 20. `images/` — Logo 与产品图片目录

| 子路径 | 格式 | 用途 |
|--------|------|------|
| `images/logo.png` | PNG（透明背景） | 公司 Logo 纯图标版 |
| `images/logo_with_text.png` | PNG（透明背景） | 公司 Logo 含文字完整版 |
| `images/products/hex-bolt-1.png` | PNG，~235 KB | 六角螺栓产品图 |
| `images/products/stainless-nuts.jpg` | JPEG，~423 KB | 不锈钢螺母 |
| `images/products/dacromet-bolt.webp` | WebP，~120 KB | Dacromet 涂层螺栓 |
| `images/products/hex-socket-screw.webp` | WebP，~67 KB | 内六角螺丝 |
| `images/products/special-shaped-screws.webp` | WebP，~12 KB | 特殊形状螺丝 |
| `images/products/*.jpg` | JPEG，各 8–106 KB | 其余六种产品图 |

---

#### 21. `imgs/` — 高质量素材图库

包含 18 张专业紧固件和企业品牌素材图，均为 JPEG 格式，文件名采用 SEO 友好的英文描述命名（如 `industrial-fastener-collection-screws-nuts-bolts.jpg`）。

**图片分类**：

| 类别 | 文件示例 | 用途 |
|------|----------|------|
| 企业品牌 | `tnho-tianhong-fastener-corporate-logo-banner.jpg` | 网站 Banner |
| 产品全景 | `industrial-fastener-collection-screws-nuts-bolts.jpg` | 产品展示 |
| Dacromet 涂层系列 | `dacromet-coated-hex-bolts-fasteners-collage.jpg` | 表面处理产品 |
| 定制特种件 | `custom-fasteners-special-shape-machined-parts.jpg` | 特种加工展示 |
| 不锈钢系列 | `professional-stainless-steel-fasteners-macro.jpg` | 材质展示 |
| 内六角螺丝 | `socket-head-cap-screw-hex-fastener.jpg` | 单品特写 |

---

#### 22. 根目录实拍图片（12张）

| 文件名 | 用途 |
|--------|------|
| `banner.jpg` | 首页 Hero Banner 背景 |
| `production_line.jpg` | 生产线实拍 |
| `workshop.jpg` | 车间全景 |
| `ccd_machine.jpg` | CCD 质检机器设备 |
| `laboratory.jpg` | 实验室/检测室 |
| `warehouse.jpg` | 成品仓库 |
| `certificates.jpg` | 质量认证证书展示 |
| `customers.jpg` | 客户合影/客户案例 |
| `meeting.jpg` | 商务会议/展会 |
| `reception.jpg` | 前台/接待区 |
| `dental_line.jpg` | 专用生产线（牙科/精密加工） |
| `timeline.jpg` | 公司发展历史时间轴 |

---

## 文件类型汇总表 / File Type Summary

| 类型 | 文件数 | 典型代表 | 主要作用 |
|------|--------|----------|----------|
| HTML 静态页面 | 1 | `index.html` | 网站前端展示（自包含） |
| PHP 混合页面 | 1 | `products.html` | 产品展示（含 PHP 变量） |
| PHP 配置/组件 | 3 | `config.php`、`includes/*.php` | 数据集中管理、页面复用 |
| Markdown 文档 | 5 | `README.md`、设计文档 | 项目文档、设计规范 |
| YAML 工作流 | 1 | `deploy.yml` | CI/CD 自动部署 |
| TOML 配置 | 1 | `wrangler.toml` | Cloudflare 部署配置 |
| 纯文本规则 | 2 | `_redirects`、`.gitignore` | 路由规则、版本控制忽略 |
| Python 脚本 | 4 | `deploy_to_github.py` | GitHub API 自动化 |
| Windows 脚本 | 2 | `create-github-repo.bat/.ps1` | Windows 用户部署工具 |
| PNG 图片 | 3 | `logo.png`、`hex-bolt-1.png` | Logo、产品图 |
| JPEG 图片 | 25+ | 实拍图、素材图 | 内容展示 |
| WebP 图片 | 3 | `dacromet-bolt.webp` | 压缩优化产品图 |

---

## 项目技术架构 / Technical Architecture

```
前端 (Frontend)
├── HTML5 + 内嵌 CSS（index.html）
├── PHP 模板（products.html + includes/）
├── Bootstrap 4.6（CDN 引入）
├── Font Awesome 6.4（CDN 引入）
├── AOS 动画库 2.3.1（CDN 引入）
└── Google Fonts（Inter + Poppins）

部署 (Deployment)
├── 主选：GitHub Pages（免费静态托管）
│   └── 触发：push 到 main 分支 → GitHub Actions 自动部署
└── 备选：Cloudflare Pages（全球 CDN 加速）
    └── 配置：wrangler.toml + _redirects

自动化工具 (Automation)
├── Python 脚本（create/deploy/check/enable）
└── Windows 脚本（BAT / PowerShell）
```

---

## 安全说明 / Security Notes

所有 Python 脚本和 Windows 脚本已更新，不再包含硬编码的 GitHub API 令牌。

**运行部署脚本前，请先设置环境变量**：

```bash
# Linux / macOS
export GITHUB_TOKEN=你的个人访问令牌

# Windows CMD
set GITHUB_TOKEN=你的个人访问令牌

# Windows PowerShell
$env:GITHUB_TOKEN = "你的个人访问令牌"
```

个人访问令牌可在 GitHub → Settings → Developer settings → Personal access tokens 中生成，所需权限为 `repo`。

---

*文档由 GitHub Copilot 自动生成，如有需要请手动更新。*
