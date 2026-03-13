# Codex Windows Installer — Download & Install Guide
# OpenAI Codex Windows 安装指南

> **Official source / 官方来源:**  
> <https://github.com/openai/codex/releases>

---

## English

### Overview

The scripts in the `scripts/` directory provide a safe, official-channel method
to download, verify (SHA-256), and optionally silently install the OpenAI Codex
Windows installer directly from the project's **official GitHub Releases**.

No API keys are required; no third-party download mirrors are used.

---

### Requirements

| Requirement | Details |
|---|---|
| OS | Windows 10 / 11 (x64) |
| PowerShell | Version 5.1 or later (built into Windows 10+) |
| Internet | Required to reach `api.github.com` and `github.com` |
| Proxy | See [Clash / Proxy](#clash--proxy-users) section below |

---

### Quick Start (PowerShell)

Open **PowerShell** (not cmd.exe) and run:

```powershell
# 1. Clone the repository (or just download the scripts folder)
git clone https://github.com/xiebaole5/tianhong-fasteners.git
cd tianhong-fasteners

# 2. Allow script execution for this session (or set globally)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 3. Download the latest Codex Windows installer
.\scripts\install_codex_windows.ps1

# 4. Download a specific version and install silently
.\scripts\install_codex_windows.ps1 -Version v1.2.3 -InstallSilently

# 5. Specify a custom download folder and skip confirmation prompts
.\scripts\install_codex_windows.ps1 -DownloadPath C:\Installers -Force
```

#### Parameter reference

| Parameter | Default | Description |
|---|---|---|
| `-Version` | `latest` | Release tag, e.g. `v1.2.3`, or `latest` |
| `-AssetName` | `codex-windows-x64.msi` | Installer file name on the release |
| `-DownloadPath` | `%USERPROFILE%\Downloads` | Folder where the installer is saved |
| `-InstallSilently` | *(switch)* | Silently run the installer after download |
| `-Force` | *(switch)* | Skip confirmation prompts |
| `-Verbose` | *(switch)* | Show detailed debug output |

---

### Verify Only (check_codex_installer.ps1)

After downloading, you can independently verify the file hash:

```powershell
.\scripts\check_codex_installer.ps1 -FilePath "$env:USERPROFILE\Downloads\codex-windows-x64.msi"
```

The script prints the **SHA-256** hash, file size, and reminds you of the
GitHub Releases page URL to compare against.

Equivalent built-in Windows command:

```cmd
certutil -hashfile "%USERPROFILE%\Downloads\codex-windows-x64.msi" SHA256
```

---

### WSL / curl Usage

If you prefer to download from **WSL** (Windows Subsystem for Linux) or Git Bash:

```bash
# Resolve the latest release download URL
RELEASE_URL=$(curl -s https://api.github.com/repos/openai/codex/releases/latest \
  | grep browser_download_url \
  | grep 'windows-x64.msi' \
  | cut -d '"' -f 4)

# Download
curl -L -o ~/Downloads/codex-windows-x64.msi "$RELEASE_URL"

# Verify SHA-256
sha256sum ~/Downloads/codex-windows-x64.msi
```

---

### Clash / Proxy Users

If you are behind a proxy (e.g. **Clash** on `127.0.0.1:7890`), configure
PowerShell to use it before running the script:

```powershell
# Set proxy for the current PowerShell session
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
$env:HTTP_PROXY  = "http://127.0.0.1:7890"

# Then run the installer script normally
.\scripts\install_codex_windows.ps1
```

For the fallback `curl.exe`:

```powershell
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
curl.exe -L -o "$env:USERPROFILE\Downloads\codex-windows-x64.msi" `
    "https://github.com/openai/codex/releases/latest/download/codex-windows-x64.msi"
```

For WSL / bash:

```bash
export https_proxy=http://127.0.0.1:7890
export http_proxy=http://127.0.0.1:7890
curl -L -o ~/Downloads/codex-windows-x64.msi \
    "https://github.com/openai/codex/releases/latest/download/codex-windows-x64.msi"
```

---

### Configure OPENAI_API_KEY

After installation, set your OpenAI API key so Codex can authenticate:

```powershell
# Permanently (per-user environment variable)
setx OPENAI_API_KEY "sk-xxxxxxxxxxxxxxxxxxxxxxxx"

# Temporary (current session only)
$env:OPENAI_API_KEY = "sk-xxxxxxxxxxxxxxxxxxxxxxxx"
```

Get your API key at <https://platform.openai.com/api-keys>.

---

---

## 中文说明

### 概述

`scripts/` 目录中的脚本提供了一种安全、官方渠道的方式，可从 OpenAI Codex
项目的**官方 GitHub Releases** 下载、验证（SHA-256 校验）并可选地静默安装
Windows 安装包。

无需 API 密钥；不使用任何第三方下载镜像。

---

### 环境要求

| 要求 | 说明 |
|---|---|
| 操作系统 | Windows 10 / 11（x64） |
| PowerShell | 5.1 及以上版本（Windows 10 内置） |
| 网络 | 需要访问 `api.github.com` 和 `github.com` |
| 代理 | 请参阅下方 [Clash / 代理](#clash--代理用户) 章节 |

---

### 快速开始（PowerShell）

打开 **PowerShell**（非 cmd.exe），执行以下命令：

```powershell
# 1. 克隆仓库（或仅下载 scripts 目录）
git clone https://github.com/xiebaole5/tianhong-fasteners.git
cd tianhong-fasteners

# 2. 允许当前会话执行脚本
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 3. 下载最新版 Codex Windows 安装包
.\scripts\install_codex_windows.ps1

# 4. 下载指定版本并静默安装
.\scripts\install_codex_windows.ps1 -Version v1.2.3 -InstallSilently

# 5. 指定下载目录并跳过确认提示
.\scripts\install_codex_windows.ps1 -DownloadPath C:\Installers -Force
```

#### 参数说明

| 参数 | 默认值 | 说明 |
|---|---|---|
| `-Version` | `latest` | 版本标签，如 `v1.2.3`，或 `latest`（最新） |
| `-AssetName` | `codex-windows-x64.msi` | Release 中的安装包文件名 |
| `-DownloadPath` | `%USERPROFILE%\Downloads` | 安装包保存路径 |
| `-InstallSilently` | *开关* | 下载后自动静默安装 |
| `-Force` | *开关* | 跳过确认提示 |
| `-Verbose` | *开关* | 显示详细调试输出 |

---

### 仅验证文件（check_codex_installer.ps1）

下载完成后，可单独验证文件哈希值：

```powershell
.\scripts\check_codex_installer.ps1 -FilePath "$env:USERPROFILE\Downloads\codex-windows-x64.msi"
```

脚本会打印 **SHA-256** 哈希值及文件大小，并提示 GitHub Releases 页面供对比。

等效的 Windows 内置命令：

```cmd
certutil -hashfile "%USERPROFILE%\Downloads\codex-windows-x64.msi" SHA256
```

---

### WSL / curl 使用方式

如果你倾向于使用 **WSL**（Windows Subsystem for Linux）或 Git Bash：

```bash
# 获取最新版下载地址
RELEASE_URL=$(curl -s https://api.github.com/repos/openai/codex/releases/latest \
  | grep browser_download_url \
  | grep 'windows-x64.msi' \
  | cut -d '"' -f 4)

# 下载
curl -L -o ~/Downloads/codex-windows-x64.msi "$RELEASE_URL"

# 验证 SHA-256
sha256sum ~/Downloads/codex-windows-x64.msi
```

---

### Clash / 代理用户

若网络环境需要通过代理（如 **Clash** 默认端口 `127.0.0.1:7890`），
在运行脚本前配置代理：

```powershell
# 为当前 PowerShell 会话设置代理
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
$env:HTTP_PROXY  = "http://127.0.0.1:7890"

# 然后正常运行安装脚本
.\scripts\install_codex_windows.ps1
```

使用内置 `curl.exe` 时：

```powershell
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
curl.exe -L -o "$env:USERPROFILE\Downloads\codex-windows-x64.msi" `
    "https://github.com/openai/codex/releases/latest/download/codex-windows-x64.msi"
```

在 WSL / bash 中：

```bash
export https_proxy=http://127.0.0.1:7890
export http_proxy=http://127.0.0.1:7890
curl -L -o ~/Downloads/codex-windows-x64.msi \
    "https://github.com/openai/codex/releases/latest/download/codex-windows-x64.msi"
```

---

### 配置 OPENAI_API_KEY

安装完成后，设置 OpenAI API 密钥以使 Codex 完成认证：

```powershell
# 永久设置（当前用户环境变量）
setx OPENAI_API_KEY "sk-xxxxxxxxxxxxxxxxxxxxxxxx"

# 临时设置（仅当前会话有效）
$env:OPENAI_API_KEY = "sk-xxxxxxxxxxxxxxxxxxxxxxxx"
```

前往 <https://platform.openai.com/api-keys> 获取你的 API 密钥。

---

*本文档与脚本均使用官方 GitHub Releases 作为唯一下载来源，不含任何硬编码密钥或第三方链接。*  
*This document and scripts use only the official GitHub Releases as the download source; no secrets or third-party links are embedded.*
