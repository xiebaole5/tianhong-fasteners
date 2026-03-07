# 将网站部署到 tnho-fasteners.com

域名 **tnho-fasteners.com** 已 ICP 备案（浙ICP备2026010279号），可按下面两种方式之一部署上线。

---

## 方式一：国内服务器 / 虚拟主机（推荐，已备案）

适合已有**国内云服务器**（阿里云、腾讯云、华为云等）或**虚拟主机**的情况。

### 1. 准备上传的文件

把整个「外贸独立站」文件夹里这些内容上传到服务器网站根目录（如 `wwwroot`、`public_html` 或 `htdocs`）：

- `index.html`
- `products.html`
- `config.php`（若用 PHP）
- `data/` 文件夹（整夹）
- `images/` 文件夹（整夹）
- `includes/` 文件夹（若用 PHP 多页）

**不要上传**：`.git`、`.github`（若服务器上不用 GitHub Actions）、`设计文档`、`*.py`、`*.bat`、`*.ps1`、`null`、`.gitignore`、`.git-credentials` 等与网站运行无关的文件。

### 2. 服务器要求

- **纯静态**：只放 HTML/CSS/JS 和图片时，用 Nginx 或 Apache 即可，无需 PHP。
- **若用 PHP**（例如以后用 `config.php`、`includes`）：需支持 PHP 7+，且保证 `config.php`、`includes/` 可被访问。

### 3. 绑定域名与 DNS

在域名服务商（购买 tnho-fasteners.com 的地方）做解析：

| 类型 | 主机记录 | 记录值 | 说明 |
|------|----------|--------|------|
| A | @ | 你的服务器公网 IP | 访问 tnho-fasteners.com |
| A 或 CNAME | www | 同上或服务器提供的 CNAME | 访问 www.tnho-fasteners.com |

在服务器/虚拟主机控制台里添加「网站」或「主机」，把 **tnho-fasteners.com** 和 **www.tnho-fasteners.com** 都绑定到该站点根目录。

### 4. 可选：HTTPS

- 云厂商一般提供免费 SSL 证书（如 Let’s Encrypt），在控制台里为 tnho-fasteners.com 申请并开启「强制 HTTPS」即可。

---

## 方式二：GitHub Pages + 自定义域名

把代码放在 GitHub，用 GitHub Pages 托管，再把 tnho-fasteners.com 指过去。**注意**：GitHub 服务器在海外，国内访问可能较慢；你已有 ICP，若主要面向国内客户，更建议用方式一。

### 1. 把项目推到 GitHub

在本地项目目录执行（已存在仓库则跳过 `git init` 和 `remote add`）：

```bash
cd C:\Users\12187\Desktop\外贸独立站
git init
git add .
git commit -m "Deploy: tnho-fasteners.com"
git branch -M main
git remote add origin https://github.com/你的用户名/仓库名.git
git push -u origin main
```

### 2. 开启 GitHub Pages

- 打开仓库 → **Settings** → **Pages**
- **Source**：Deploy from a branch
- **Branch**：main，目录选 **/ (root)**
- 保存后等 1～2 分钟，先访问 `https://你的用户名.github.io/仓库名/` 确认能打开

### 3. 绑定自定义域名 tnho-fasteners.com

- 在 **Settings** → **Pages** 的 **Custom domain** 里填：`tnho-fasteners.com`
- 勾选 **Enforce HTTPS**（可选，建议勾选）

### 4. 在域名服务商处改 DNS

到购买 tnho-fasteners.com 的平台，添加/修改解析：

| 类型 | 主机记录 | 记录值 |
|------|----------|--------|
| CNAME | www | 你的用户名.github.io |
| A | @ | 185.199.108.153（或 GitHub Pages 提供的 IP） |

（若只用 www，可只配 CNAME；若要用根域名 @，需按 GitHub 文档配 A 记录。）

保存后等待生效（几分钟到几小时），即可用 https://tnho-fasteners.com 或 https://www.tnho-fasteners.com 访问。

---

## 部署后建议检查

1. 打开 https://www.tnho-fasteners.com 和 https://tnho-fasteners.com，确认首页、产品页正常。
2. 确认页脚 **浙ICP备2026010279号** 显示且链接到 https://beian.miit.gov.cn/
3. 微信二维码：若已放 `images/wechat-qr.png`，确认联系区/页脚/悬浮能正常显示。
4. 若有表单，测试提交是否正常（若暂未接后端，可只检查前端的必填、跳转等）。

---

## 小结

- **已有国内服务器/虚拟主机**：用方式一，上传网站文件并绑定 tnho-fasteners.com，改好 DNS 即可。
- **想用 GitHub 托管、能接受海外访问**：用方式二，推代码 → 开 Pages → 填自定义域名 → 去域名商改 DNS。

两种方式都是「您自己在服务器或 GitHub 上操作」；我这边只能提供步骤和清单，无法替你登录服务器或 GitHub 执行部署。若你告诉我用的是哪家（例如阿里云、腾讯云、或 GitHub），可以再按该平台写一版更具体的点击步骤。
