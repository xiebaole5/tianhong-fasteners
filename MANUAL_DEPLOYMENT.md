# 浙江天宏紧固件有限公司 - 外贸独立站手动部署指南

## 概述

本文档提供手动部署外贸独立站的详细步骤。由于自动部署脚本遇到 GitHub 认证问题，请按照以下步骤手动完成部署。

## 第一步：创建 GitHub 仓库

### 1.1 登录 GitHub

打开浏览器访问 GitHub 官方网站 https://github.com ，使用您的 GitHub 账号登录。如果您还没有账号，请先注册。

### 1.2 创建新仓库

登录后，点击页面右上角的「+」号，选择「New repository」选项。在创建仓库页面中，进行以下配置：

仓库名称设置为 `tianhong-fasteners`，这是本项目的标准命名。描述可以填写「浙江天宏紧固件有限公司 - 外贸独立站」，以清晰标识项目内容。保持仓库为「Public」（公开）状态，因为我们希望网站能够被访问。勾选「Add a README file」选项，为仓库添加初始说明文档。其他选项保持默认设置即可。

### 1.3 获取仓库地址

仓库创建成功后，页面将显示仓库地址，格式为 `https://github.com/您的用户名/tianhong-fasteners`。请记下这个地址，后续推送代码时需要使用。

## 第二步：推送本地代码到 GitHub

### 2.1 添加远程仓库

打开命令提示符或 PowerShell，导航到项目目录：

```bash
cd C:\Users\12187\Desktop\外贸独立站
```

执行以下命令添加远程仓库地址（将 `您的用户名` 替换为您的实际 GitHub 用户名）：

```bash
git remote add origin https://github.com/您的用户名/tianhong-fasteners.git
```

### 2.2 推送代码

执行以下命令将本地代码推送到 GitHub：

```bash
git push -u origin master
```

系统会提示您输入 GitHub 用户名和密码。如果您启用了双因素认证，需要使用个人访问令牌（Personal Access Token）代替密码。您可以在 GitHub 的「Settings → Developer settings → Personal access tokens」页面生成令牌。

推送成功后，您的代码将出现在 GitHub 仓库中。

## 第三步：配置 GitHub Pages

### 3.1 启用 Pages 功能

在 GitHub 仓库页面，点击顶部的「Settings」选项卡。在左侧菜单中找到「Pages」选项。进入 Pages 设置页面后，在「Source」部分，将「Branch」设置为「master」或「main」，文件夹保持为「/(root)」。点击「Save」按钮保存设置。

### 3.2 获取访问地址

保存设置后，GitHub Pages 将自动部署您的网站。部署完成后，页面将显示您的网站访问地址，格式为 `https://您的用户名.github.io/tianhong-fasteners/`。首次部署可能需要几分钟时间，请耐心等待。

## 第四步：配置 Cloudflare Pages 加速

### 4.1 登录 Cloudflare

打开浏览器访问 Cloudflare 官方网站 https://www.cloudflare.com ，登录您的 Cloudflare 账号。如果您还没有账号，请先注册并添加您的域名。

### 4.2 连接 GitHub 仓库

在 Cloudflare 控制面板中，找到「Workers & Pages」选项（可能在「Website」菜单或单独的「Pages」选项中）。点击「Create a project」按钮，选择「Connect to Git」选项。

系统将提示您授权 Cloudflare 访问您的 GitHub 账号。选择您刚才创建的 `tianhong-fasteners` 仓库进行连接。

### 4.3 配置构建设置

在项目配置页面，进行以下设置：

项目名称可以保持默认或自定义。构建设置保持为空或选择「None」，因为我们的网站是纯静态页面，不需要构建过程。输出目录保持默认设置。

### 4.4 设置自定义域名（可选）

如果您有自己的域名，可以在「Custom domains」部分添加。在「Domains」输入框中输入您的域名，点击「Continue」。按照提示完成 DNS 配置，将域名指向 Cloudflare Pages。

### 4.5 完成部署

点击「Deploy site」按钮开始部署。部署完成后，您将获得一个 Cloudflare Pages 访问地址，格式为 `https://tianhong-fasteners.pages.dev`。

## 第五步：验证部署结果

### 5.1 检查 GitHub Pages

打开浏览器访问您的 GitHub Pages 地址 `https://您的用户名.github.io/tianhong-fasteners/`。确认首页能够正常显示，检查导航链接、产品页面和其他功能是否正常工作。

### 5.2 检查 Cloudflare Pages（如果已配置）

打开浏览器访问您的 Cloudflare Pages 地址 `https://tianhong-fasteners.pages.dev`。确认页面加载速度和内容显示是否正常。

### 5.3 验证 GitHub Actions

在 GitHub 仓库页面，点击「Actions」选项卡。确认「Deploy to GitHub Pages」工作流已经运行，并且显示绿色的勾选标记表示部署成功。

## 常见问题解决

### 问题一：GitHub 认证失败

如果在推送代码时遇到认证失败，请检查以下几点：确认您输入的用户名和密码（或令牌）正确；在 GitHub 账号设置中检查个人访问令牌是否具有 repo 权限；如果忘记了密码，可以使用个人访问令牌代替。

### 问题二：Pages 部署失败

如果 GitHub Pages 部署失败，可能的原因包括：仓库中缺少必要的 HTML 文件；`.gitignore` 文件排除了重要的网站文件；GitHub Pages 设置中的分支选择错误。请检查仓库文件并重新配置 Pages 设置。

### 问题三：图片无法显示

如果网站上的图片无法显示，请检查图片路径是否正确；确认图片文件已经提交到 GitHub 仓库；检查浏览器的开发者工具（F12）中的错误信息。

### 问题四：页面加载缓慢

如果页面加载速度较慢，建议采取以下优化措施：使用 TinyPNG 或 ImageOptim 压缩图片文件；将大图片转换为 WebP 格式以减小文件大小；使用 Cloudflare CDN 加速全球访问。

## 项目文件说明

### 核心文件

`index.html` 是网站首页，包含公司介绍、产品分类、证书展示和联系方式等主要内容。`products.html` 是产品展示页面，提供详细的产品信息和图片展示。`config.php` 是配置文件，用于网站的基本设置。`.gitignore` 文件定义了 Git 版本控制需要忽略的文件和文件夹。

### 配置文件

`.github/workflows/deploy.yml` 是 GitHub Actions 自动部署配置文件，实现代码推送后自动部署到 GitHub Pages。`DEPLOYMENT.md` 是自动部署指南文档，提供 Cloudflare 集成的详细说明。

### 文档文件

`README.md` 是项目说明文档，包含项目概述、使用指南和下一步建议。`MANUAL_DEPLOYMENT.md` 是本文档，提供手动部署的详细步骤。

## 联系信息

如果在部署过程中遇到问题，请参考以下资源：

GitHub Pages 官方文档：https://docs.github.com/en/pages  
Cloudflare Pages 官方文档：https://developers.cloudflare.com/pages/  
GitHub 官方帮助：https://help.github.com  

公司信息  
公司名称：浙江天宏紧固件有限公司  
成立年份：1987年  
电话/WhatsApp：+86 189 5877 0140  
邮箱：xiebaole5@gmail.com  

## 下一步优化建议

完成基础部署后，您可以考虑以下优化措施：

### 搜索引擎优化

为网站添加 Open Graph 和 Twitter Cards 元标签，提高社交媒体分享效果。优化页面标题和描述，包含关键词以提高搜索排名。为图片添加 alt 属性，提高可访问性和 SEO 效果。

### 性能优化

启用浏览器缓存，减少重复访问的加载时间。压缩和优化所有图片文件。考虑使用图片懒加载技术，按需加载页面图片。

### 内容完善

添加真实的公司和产品照片，提升网站专业度。创建独立的产品详情页面，提供更详细的产品信息。添加客户案例和成功故事，增强信任度。

### 功能增强

添加多语言支持，支持中英文切换。集成在线询盘表单系统，方便客户直接发送询盘。添加网站分析工具，跟踪访客行为和流量来源。

## 部署检查清单

完成所有部署步骤后，请确认以下项目都已完成：GitHub 仓库已创建并推送代码；GitHub Pages 已启用并显示网站内容；Cloudflare Pages 已配置（如使用）；网站所有链接和功能正常工作；图片正常显示且加载速度可接受；GitHub Actions 工作流运行成功。

完成以上所有步骤后，您的外贸独立站就可以正式上线运营了！

---

**文档版本**：1.0  
**最后更新**：2026年2月7日  
**维护者**：Matrix Agent  
