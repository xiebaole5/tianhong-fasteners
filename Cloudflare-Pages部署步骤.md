# 在 Cloudflare 上部署网站（tnho-fasteners.com）

你的域名已在阿里云注册并成功把 DNS 指向了 Cloudflare，下面用 **Cloudflare Pages** 把本站在 Cloudflare 上部署并绑定 tnho-fasteners.com。  
（我无法登录你的 Cloudflare 账号，需要你在浏览器里按步骤操作。）

---

## 一、准备要上传的网站文件夹

Cloudflare Pages 只托管**静态文件**（HTML/CSS/JS/图片等），不需要 PHP。请只上传以下内容：

**需要上传的：**

- `index.html`
- `products.html`
- `data/` 整个文件夹（含 `products.json`）
- `images/` 整个文件夹（含 `logo.png`、`products/` 下所有图片等）

**不要上传：**

- `.git`、`.github`、`.cursor`
- `设计文档`、`includes`（PHP 用）
- `config.php`、`*.py`、`*.bat`、`*.ps1`
- `DEPLOYMENT.md`、`README.md` 等文档（可选，不影响访问）
- `null`、`.git-credentials`、`.gitignore`

**做法：** 在「外贸独立站」文件夹里新建一个文件夹，例如叫 `site-upload`，把上面「需要上传的」文件和文件夹复制进去，然后对这个 `site-upload` 文件夹打包成 **ZIP**（或直接上传该文件夹，见下文）。

---

## 二、在 Cloudflare 创建 Pages 项目并上传

1. **登录 Cloudflare**  
   打开 https://dash.cloudflare.com 并登录。

2. **进入 Pages**  
   左侧菜单选 **Workers & Pages** → 点击 **Create application** → 选 **Pages** → **Create a project**。

3. **选择「直接上传」**  
   在 “Create a project” 页面选择 **Direct Upload**（直接上传），不要选 “Connect to Git”。

4. **填写项目名**  
   - Project name：例如填 `tnho-fasteners` 或 `tianhong-fasteners`  
   - 点击 **Create project**。

5. **上传网站文件**  
   - 在 “Deployments” 页会提示你上传：
     - 要么 **拖拽文件夹**（把准备好的 `site-upload` 或包含 index.html、products.html、data、images 的文件夹拖进去）
     - 要么 **上传 ZIP**（把上面准备好的 ZIP 上传）
   - 上传完成后，Cloudflare 会自动部署，等 1～2 分钟。

6. **得到临时地址**  
   部署成功后，会显示一个地址，类似：  
   `https://tnho-fasteners.pages.dev`  
   先点开确认首页、产品页、图片都能正常打开。

---

## 三、绑定自定义域名 tnho-fasteners.com

1. **进入项目设置**  
   在该 Pages 项目里，点 **Custom domains**（自定义域名）。

2. **添加域名**  
   - 点击 **Set up a custom domain**
   - 输入：`tnho-fasteners.com`，保存
   - 再添加：`www.tnho-fasteners.com`（可选，建议都绑）

3. **DNS 已指向 Cloudflare 时**  
   你的域名 DNS 已经在 Cloudflare，所以通常 Cloudflare 会自动为 Pages 添加/使用 CNAME 记录，**一般不用再去阿里云改 DNS**。  
   若有提示“验证域名”，按页面说明操作即可。

4. **开启 HTTPS**  
   Cloudflare 默认会为域名提供 SSL，保持 **SSL/TLS** 为 “Full” 或 “Full (strict)” 即可。

---

## 四、部署完成后建议检查

- 打开 https://tnho-fasteners.com 和 https://www.tnho-fasteners.com，确认是本站首页。
- 点「产品」进入产品页，看图片、样式是否正常。
- 页脚是否有 **浙ICP备2026010279号** 且可点击到工信部链接。
- 若已放 `images/wechat-qr.png`，检查微信二维码是否显示。

---

## 五、以后更新网站怎么操作

- **直接上传方式**：在同一个 Pages 项目里，进入 **Deployments** → **Create deployment** → 再次上传新的文件夹或 ZIP，新版本会覆盖旧版本。
- 若以后改用 **Git 连接**（GitHub/GitLab），可在该项目 **Settings** 里 “Connect to Git”，之后每次 push 自动部署。

---

## 小结

| 步骤 | 你要做的 |
|------|----------|
| 1 | 在本地准备好只含 index.html、products.html、data、images 的文件夹（或 ZIP） |
| 2 | Cloudflare → Workers & Pages → Create → Pages → Direct Upload |
| 3 | 上传该文件夹或 ZIP，等待部署完成 |
| 4 | 在 Pages 项目里添加 Custom domain：tnho-fasteners.com 和 www.tnho-fasteners.com |
| 5 | 用浏览器访问 tnho-fasteners.com 做检查 |

按以上步骤在 Cloudflare 上操作即可完成部署；我无法代你登录 Cloudflare 或点击部署，只能提供这份步骤说明。
