# GitHub Pages + Cloudflare 部署指南

## 方案概述

本项目支持通过 **GitHub Pages** 免费托管静态网站，并可使用 **Cloudflare** CDN 加速全球访问。

---

## 快速部署步骤

### 1. GitHub Pages 部署

#### 方法一：通过 GitHub 网页界面（推荐）

1. **创建 GitHub 仓库**
   - 访问 https://github.com/new
   - Repository name: `tianhong-fasteners`（或你的仓库名）
   - 选择 **Public**
   - 不要初始化 README（我们已有文件）

2. **上传网站文件**
   ```bash
   cd C:\Users\12187\Desktop\外贸独立站
   git init
   git add .
   git commit -m "Initial commit: Tianhong Fasteners Website"
   git branch -M main
   git remote add origin https://github.com/你的用户名/tianhong-fasteners.git
   git push -u origin main
   ```

3. **启用 GitHub Pages**
   - 进入仓库的 **Settings** → **Pages**
   - Source 选择 **Deploy from a branch**
   - Branch 选择 **main**，文件夹选择 **/(root)**
   - 点击 **Save**
   - 等待 1-2 分钟，网站将在 `https://你的用户名.github.io/tianhong-fasteners/` 发布

#### 方法二：通过 GitHub Desktop

1. 下载并安装 GitHub Desktop
2. 点击 **File** → **Add Local Repository**
3. 选择外贸独立站文件夹
4. 点击 **Publish repository**
5. 填写仓库名和描述，点击 **Publish**
6. 进入仓库网页版，按上述步骤启用 Pages

---

### 2. Cloudflare 加速配置（可选但推荐）

#### 注册 Cloudflare

1. 访问 https://www.cloudflare.com
2. 点击 **Sign Up** 注册账号
3. 输入你的域名（如 `tianhong-fasteners.com`）
4. Cloudflare 会自动扫描 DNS 记录

#### 添加 GitHub Pages

1. 在 Cloudflare 仪表板，点击 **DNS** → **Records**
2. 添加以下记录：
   - Type: `CNAME`
   - Name: `www` 或 `@`
   - Target: `你的用户名.github.io`
   - Proxy status: ⚪ 灰色（仅代理）

3. 配置 Pages（可选）
   - 进入 **Workers & Pages** → **Create** → **Pages**
   - 连接你的 GitHub 仓库
   - 配置构建命令（静态网站无需构建）
   - 完成后获得自定义域名

---

### 3. 自定义域名配置（可选）

如果你有自定义域名：

#### GitHub Pages 设置

1. 进入仓库 **Settings** → **Pages**
2. 在 **Custom domain** 输入你的域名
3. 勾选 **Enforce HTTPS**（需要几分钟生效）

#### Cloudflare 设置

1. 确保 DNS 记录正确指向 GitHub
2. 启用 **Always Use HTTPS**
3. 配置 **Page Rules** 优化性能

---

## 推荐的域名组合

| 场景 | 推荐方案 |
|------|----------|
| 免费展示 | `用户名.github.io/tianhong-fasteners` |
| 品牌域名 | `www.tianhong-fasteners.com` |
| 专业外贸站 | `www.tianhongfasteners.com` |

---

## 部署后的操作

### 更新网站内容

```bash
# 修改文件后
git add .
git commit -m "Update: 修改说明"
git push origin main
# GitHub Pages 会自动更新（1-2分钟生效）
```

### 检查部署状态

1. 访问 `https://github.com/你的用户名/仓库名/actions`
2. 查看最新 workflow 运行状态
3. 确认 **Deploy** 步骤完成

---

## 注意事项

### GitHub Pages 限制
- ✅ 单个仓库免费托管
- ✅ 每月 100GB 带宽（足够小型网站）
- ✅ 软性限制 1GB 存储空间
- ⚠️ 禁止商业用途（条款可能变化）

### 建议配置

```html
<!-- 在 index.html 头部添加 -->
<link rel="canonical" href="https://你的域名.com">
<meta name="description" content="Zhejiang Tianhong Fasteners - Custom fasteners manufacturer since 1987">
```

---

## 故障排除

### 网站无法访问
1. 检查 GitHub Actions 是否成功运行
2. 确认 `index.html` 在仓库根目录
3. 验证文件路径大小写

### HTTPS 证书问题
1. GitHub Pages 自动提供 SSL
2. Cloudflare 可能需要 24 小时生效
3. 尝试手动触发更新

### 缓存问题
- Cloudflare: 点击 **Caching** → **Purge Cache**
- 浏览器: Ctrl+F5 强制刷新

---

## 维护建议

1. **定期更新**
   - 每月检查证书有效期
   - 保持依赖库更新

2. **监控访问**
   - GitHub Insights → Traffic
   - Cloudflare Analytics

3. **备份数据**
   - 本地保留源码
   - 定期导出访问统计

---

## 相关链接

- GitHub Pages 文档: https://docs.github.com/en/pages
- Cloudflare 文档: https://developers.cloudflare.com/pages
- DNS 检测: https://dnschecker.org
- HTTPS 检测: https://www.ssllabs.com/ssltest/
