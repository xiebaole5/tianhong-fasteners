# 非微软版 Windows 包管理器指南

> 本文档适用于 **天宏紧固件 ERP 环境**，介绍如何使用社区维护的开源 Windows 包管理器作为微软官方 `winget` 的替代方案。

---

## 为什么选择非微软版包管理器？

微软官方的 `winget`（Windows Package Manager）存在以下限制：

- 需要 Microsoft Store 或特定 Windows 版本支持
- 软件源由微软审核控制，更新周期较慢
- 在企业/工厂网络环境下可能受到限制
- 不支持便携式（Portable）安装，会向系统写入注册表

**推荐替代方案：[Scoop](https://github.com/ScoopInstaller/Scoop)**

---

## Scoop 简介

| 属性 | 详情 |
|------|------|
| 项目地址 | https://github.com/ScoopInstaller/Scoop |
| 开源协议 | MIT License |
| 维护者 | 社区维护（非微软官方） |
| 发布日期 | 2013 年至今持续更新 |
| 安装方式 | PowerShell 一键安装，无需管理员权限 |
| 安装位置 | `%USERPROFILE%\scoop`（用户目录，不污染系统） |

### 核心优势

- ✅ **无需管理员权限**：安装到用户目录，适合受限企业环境
- ✅ **无注册表污染**：所有软件安装在独立目录，卸载干净彻底
- ✅ **命令行驱动**：适合脚本自动化和批量部署
- ✅ **软件源丰富**：支持多个 Bucket（软件仓库），收录数千款软件
- ✅ **版本管理**：支持同时安装多个版本并随时切换
- ✅ **离线安装包缓存**：支持统一管理安装包，适合内网环境

---

## 快速安装

### 前提条件

- Windows 7 SP1 或更高版本（推荐 Windows 10/11）
- PowerShell 5.1 或更高版本（Windows 自带）
- 网络可访问 GitHub（可使用镜像，详见下文）

### 方式一：一键安装（推荐）

打开 **PowerShell**（无需管理员权限），执行：

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

> 也可以直接运行本仓库提供的自动化脚本，详见 [`docs/scripts/install-scoop.ps1`](./scripts/install-scoop.ps1)。

### 方式二：指定安装目录

```powershell
$env:SCOOP = 'D:\Scoop'
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

### 方式三：离线 / 内网环境

1. 在有网络的机器上，从 GitHub Releases 下载安装包：
   - https://github.com/ScoopInstaller/Install/archive/refs/heads/master.zip
2. 将压缩包复制到目标机器
3. 解压后，以管理员权限运行：
   ```powershell
   .\install.ps1 -ScoopDir 'D:\Scoop'
   ```

---

## 常用命令速查

```powershell
# 搜索软件
scoop search <软件名>

# 安装软件
scoop install <软件名>

# 更新所有软件
scoop update *

# 卸载软件
scoop uninstall <软件名>

# 查看已安装软件列表
scoop list

# 添加扩展软件仓库（Bucket）
scoop bucket add extras
scoop bucket add versions
scoop bucket add nerd-fonts

# 查看所有可用 Bucket
scoop bucket known
```

---

## ERP 环境推荐软件包

以下软件包适用于天宏紧固件 ERP 系统的日常运维与开发：

```powershell
# 开发工具
scoop install git
scoop install nodejs
scoop install python

# 数据库工具
scoop install mysql
scoop install dbeaver   # 需要先添加 extras bucket

# 网络与运维
scoop install curl
scoop install wget
scoop install 7zip

# 文本编辑器
scoop install vscode    # 需要先添加 extras bucket

# 添加 extras bucket 获取更多软件
scoop bucket add extras
scoop install vscode dbeaver
```

---

## 批量安装（适合 ERP 环境部署）

创建软件包列表文件 `packages.txt`，每行一个包名，然后运行：

```powershell
# 从文件批量安装
Get-Content packages.txt | ForEach-Object { scoop install $_ }
```

或者直接一行命令安装多个软件：

```powershell
scoop install git nodejs python 7zip curl
```

---

## 与 winget 对比

| 功能 | Scoop | winget（微软官方） |
|------|-------|-------------------|
| 开源 | ✅ MIT | ✅ MIT |
| 维护方 | 社区 | 微软 |
| 需要管理员权限 | ❌（通常不需要） | ✅ |
| 安装位置 | 用户目录 | 系统目录 |
| 注册表修改 | ❌ | ✅ |
| 软件数量 | 约 6,000+ | 约 3,000+ |
| 企业环境支持 | ✅ 更灵活 | ⚠️ 有限制 |
| 离线安装 | ✅ | ⚠️ 有限 |
| 版本切换 | ✅ | ❌ |

---

## 网络问题解决（国内环境）

如果 GitHub 访问较慢，可以使用以下方法：

### 使用镜像加速安装

```powershell
# 通过国内镜像安装 Scoop
irm https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1 | iex
```

### 配置代理

```powershell
# 设置代理后安装
$env:HTTP_PROXY = 'http://your-proxy:port'
$env:HTTPS_PROXY = 'http://your-proxy:port'
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

---

## 更多资源

- **Scoop 官网**: https://scoop.sh
- **GitHub 仓库**: https://github.com/ScoopInstaller/Scoop
- **软件包搜索**: https://scoop.sh/#/apps
- **社区文档 Wiki**: https://github.com/ScoopInstaller/Scoop/wiki
- **Bucket 列表**: https://github.com/ScoopInstaller/Scoop#known-application-buckets

---

## 其他替代方案参考

| 工具 | 说明 | 链接 |
|------|------|------|
| **Scoop** | 推荐，轻量、无需管理员权限 | https://github.com/ScoopInstaller/Scoop |
| **Chocolatey** | 功能强大，企业版需付费 | https://github.com/chocolatey/choco |
| **nix** (Windows) | 跨平台包管理，适合高级用户 | https://nixos.org/download/ |

---

*文档维护：天宏紧固件技术团队 | 最后更新：2026 年 3 月*
