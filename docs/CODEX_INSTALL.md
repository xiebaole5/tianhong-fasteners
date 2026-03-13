# Codex Windows Installer Guide / Codex Windows 安装指南

> **Official download source / 官方下载来源:**
> https://github.com/openai/codex/releases

---

## Table of Contents / 目录

1. [Overview / 概述](#overview--概述)
2. [Requirements / 系统要求](#requirements--系统要求)
3. [Quick Start (PowerShell) / 快速开始（PowerShell）](#quick-start-powershell--快速开始powershell)
4. [Quick Start (WSL / curl) / 快速开始（WSL / curl）](#quick-start-wsl--curl--快速开始wsl--curl)
5. [Manual Checksum Verification / 手动校验 SHA-256](#manual-checksum-verification--手动校验-sha-256)
6. [Using a Proxy (Clash etc.) / 通过代理（Clash 等）下载](#using-a-proxy-clash-etc--通过代理clash-等下载)
7. [Silent Installation / 静默安装](#silent-installation--静默安装)
8. [Post-Installation: API Key / 安装后配置 API Key](#post-installation-api-key--安装后配置-api-key)
9. [Script Reference / 脚本参考](#script-reference--脚本参考)
10. [Troubleshooting / 常见问题](#troubleshooting--常见问题)

---

## Overview / 概述

**EN:** This guide explains how to download the official OpenAI Codex Windows
installer directly from the project's GitHub Releases page, verify its
integrity with a SHA-256 checksum, and optionally perform a silent (unattended)
installation using the included PowerShell scripts.

**ZH:** 本文档介绍如何通过项目官方 GitHub Releases 页面下载 OpenAI Codex Windows
安装包，使用 SHA-256 校验和验证文件完整性，并可选择使用随附的 PowerShell
脚本进行静默（无人值守）安装。

---

## Requirements / 系统要求

| Requirement | Details |
|---|---|
| OS | Windows 10 (1809+) or Windows 11 |
| PowerShell | 5.1 (built-in) or PowerShell 7+ recommended |
| Network | Internet access to `github.com` / `objects.githubusercontent.com` |
| Account | OpenAI account (ChatGPT Plus / Pro / Team for full features) |

---

## Quick Start (PowerShell) / 快速开始（PowerShell）

**EN:** Open **PowerShell** (or **Windows Terminal**) and run:

**ZH:** 打开 **PowerShell**（或 **Windows Terminal**）后运行：

```powershell
# 1. Navigate to the scripts directory / 切换到 scripts 目录
cd path\to\this-repo\scripts

# 2. Allow the script to run (one-time, current user) / 允许脚本执行（仅当前用户，执行一次）
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

# 3. Download the latest Codex installer / 下载最新 Codex 安装包
.\install_codex_windows.ps1

# 4. Download a specific version / 下载指定版本
.\install_codex_windows.ps1 -Version v0.2.0

# 5. Download AND silently install in one step / 下载并静默安装（一步完成）
.\install_codex_windows.ps1 -InstallSilently

# 6. Verbose output / 显示详细日志
.\install_codex_windows.ps1 -InstallSilently -Verbose
```

The installer is saved to your **Downloads** folder by default.
默认保存到你的 **Downloads** 文件夹。

---

## Quick Start (WSL / curl) / 快速开始（WSL / curl）

**EN:** If you prefer WSL (Windows Subsystem for Linux) or a shell with `curl`:

**ZH:** 如果你偏好使用 WSL 或带有 `curl` 的 Shell：

```bash
# Replace vX.Y.Z with the desired release tag / 将 vX.Y.Z 替换为目标版本号
VERSION="latest"
ASSET="codex-windows-x64.msi"

# Resolve the download URL for the latest release / 解析最新版本下载地址
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/openai/codex/releases/latest \
  | grep "browser_download_url" \
  | grep "$ASSET" \
  | cut -d '"' -f 4)

# Download the installer / 下载安装包
curl -L -o "$ASSET" "$DOWNLOAD_URL"

# Download the checksum file (if available) / 下载校验文件（如有）
CHECKSUM_URL=$(curl -s https://api.github.com/repos/openai/codex/releases/latest \
  | grep "browser_download_url" \
  | grep -E "checksums\.txt|SHA256SUMS" \
  | cut -d '"' -f 4)

if [ -n "$CHECKSUM_URL" ]; then
  curl -L -o checksums.txt "$CHECKSUM_URL"
  sha256sum --check --ignore-missing checksums.txt
fi
```

---

## Manual Checksum Verification / 手动校验 SHA-256

### Using the provided script / 使用随附脚本

```powershell
.\check_codex_installer.ps1 -FilePath "$env:USERPROFILE\Downloads\codex-windows-x64.msi"
```

### Using certutil (built-in on Windows) / 使用 certutil（Windows 内置）

```cmd
certutil -hashfile "%USERPROFILE%\Downloads\codex-windows-x64.msi" SHA256
```

**EN:** Compare the output hash with the value in the `checksums.txt` (or
`SHA256SUMS`) file published alongside the release on
https://github.com/openai/codex/releases.

**ZH:** 将输出的哈希值与 https://github.com/openai/codex/releases 页面中
随发行版发布的 `checksums.txt`（或 `SHA256SUMS`）文件中的值进行比对。

---

## Using a Proxy (Clash etc.) / 通过代理（Clash 等）下载

**EN:** If you are behind a corporate firewall or use a local proxy such as
Clash, set the `HTTPS_PROXY` / `HTTP_PROXY` environment variables before
running the scripts.

**ZH:** 如果你在企业防火墙后面，或使用 Clash 等本地代理，请在运行脚本前设置
`HTTPS_PROXY` / `HTTP_PROXY` 环境变量。

```powershell
# Set proxy for the current PowerShell session / 在当前 PowerShell 会话中设置代理
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
$env:HTTP_PROXY  = "http://127.0.0.1:7890"

# Then run the install script as normal / 然后正常运行安装脚本
.\install_codex_windows.ps1 -InstallSilently
```

For WSL / curl / WSL 或 curl 方式：

```bash
export HTTPS_PROXY="http://127.0.0.1:7890"
export HTTP_PROXY="http://127.0.0.1:7890"
curl -L -o codex-windows-x64.msi "$DOWNLOAD_URL"
```

> **Note / 注意:** Replace `7890` with your actual proxy port (e.g. Clash
> default is `7890`, v2rayN default is `10809`).
> 将 `7890` 替换为你实际使用的代理端口（Clash 默认 `7890`，v2rayN 默认 `10809`）。

---

## Silent Installation / 静默安装

**EN:** Use `-InstallSilently` to run the installation without any GUI prompts.
This requires the script to be executed with sufficient privileges (run
PowerShell as Administrator if a machine-wide install is needed).

**ZH:** 使用 `-InstallSilently` 可在无图形界面提示的情况下完成安装。如需全机器
级别安装，请以**管理员身份**运行 PowerShell。

```powershell
# Run PowerShell as Administrator, then: / 以管理员身份运行 PowerShell，然后执行：
.\install_codex_windows.ps1 -InstallSilently -Force -Verbose
```

The script handles both `.msi` (via `msiexec /qn`) and `.exe` (tries `/S`,
`/silent`, `/verysilent`, `/quiet`, `/qn` in order) installers automatically.

脚本自动处理 `.msi`（通过 `msiexec /qn`）和 `.exe`（依次尝试 `/S`、`/silent`、
`/verysilent`、`/quiet`、`/qn`）两种安装包格式。

---

## Post-Installation: API Key / 安装后配置 API Key

**EN:** After installation, configure your OpenAI API key so Codex can
authenticate with the OpenAI backend.

**ZH:** 安装完成后，配置你的 OpenAI API Key，以便 Codex 可以与 OpenAI 后端进行
身份验证。

### Option A — GUI login / 方式 A — 图形界面登录

Launch Codex from the Start Menu; the app will open a browser window to
complete OAuth authentication with your OpenAI account.

从开始菜单启动 Codex，应用将打开浏览器窗口，使用你的 OpenAI 账号完成 OAuth 认证。

### Option B — Environment variable (CLI / scripting) / 方式 B — 环境变量（命令行 / 脚本）

```powershell
# Set permanently for the current user / 为当前用户永久设置
setx OPENAI_API_KEY "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Or set for the current session only / 或仅在当前会话中临时设置
$env:OPENAI_API_KEY = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

> **Security reminder / 安全提示:** Never commit your API key to source
> control. Add `*.env`, `.env.*`, and any secrets files to `.gitignore`.
> 请勿将 API Key 提交到版本控制系统中。将 `*.env`、`.env.*` 及任何包含密钥的
> 文件加入 `.gitignore`。

---

## Script Reference / 脚本参考

### `install_codex_windows.ps1`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Version` | `string` | `latest` | Release tag (e.g. `v0.2.0`) or `latest` |
| `-AssetName` | `string` | `codex-windows-x64.msi` | Filename of the installer asset |
| `-DownloadPath` | `string` | `~\Downloads` | Directory where the file is saved |
| `-InstallSilently` | switch | off | Run silent/unattended installation |
| `-Force` | switch | off | Skip interactive confirmation when no checksum file is found |
| `-GitHubOwner` | `string` | `openai` | GitHub repo owner (change only when targeting a fork) |
| `-GitHubRepo` | `string` | `codex` | GitHub repo name (change only when targeting a fork) |
| `-Verbose` | switch | off | Print detailed progress messages |

**Exit codes:**

| Code | Meaning |
|---|---|
| `0` | Success |
| `1` | General / unexpected error |
| `2` | Requested asset not found in the release |
| `3` | SHA-256 checksum verification failed |
| `4` | Silent installation failed |

---

### `check_codex_installer.ps1`

| Parameter | Type | Required | Description |
|---|---|---|---|
| `-FilePath` | `string` | yes | Path to the installer file to verify |

**Exit codes:**

| Code | Meaning |
|---|---|
| `0` | File exists; SHA-256 printed successfully |
| `1` | File not found or hashing error |

---

## Troubleshooting / 常见问题

| Problem / 问题 | Solution / 解决方案 |
|---|---|
| `Invoke-WebRequest` times out | Check proxy settings; use `-Verbose` to see which URL is being contacted. 检查代理设置；使用 `-Verbose` 查看正在访问的 URL。 |
| `UnauthorizedAccess` when running script | Run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once. 执行一次 `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`。 |
| SHA-256 mismatch | Re-download the file. If mismatch persists, do NOT install. 重新下载文件。如仍不匹配，请勿安装。 |
| Asset not found in release | Check https://github.com/openai/codex/releases for the correct asset name and pass it via `-AssetName`. 在发布页面确认正确的资产名称并通过 `-AssetName` 传入。 |
| Installation requires reboot | Exit code `3010` from msiexec indicates success with a pending reboot. Restart Windows to complete setup. msiexec 返回 `3010` 表示安装成功但需要重启，请重启 Windows 以完成安装。 |
| API key not working | Verify the key is set: `$env:OPENAI_API_KEY`. Ensure there are no leading/trailing spaces. 确认 Key 已设置 `$env:OPENAI_API_KEY`，注意不要有前后空格。 |

---

*For the latest information, always refer to the official repository:
https://github.com/openai/codex*

*如需最新信息，请始终参考官方仓库：https://github.com/openai/codex*
