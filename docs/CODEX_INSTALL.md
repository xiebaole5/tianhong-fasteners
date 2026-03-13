# OpenAI Codex Windows Installer Guide
# OpenAI Codex Windows 安装指南

> **Official download channel / 官方下载渠道**:
> [`https://github.com/openai/codex/releases`](https://github.com/openai/codex/releases)

---

## Table of Contents / 目录

1. [Overview / 概述](#overview)
2. [Prerequisites / 前置要求](#prerequisites)
3. [Quick Start (PowerShell) / 快速开始](#quick-start-powershell)
4. [Advanced Usage / 高级用法](#advanced-usage)
5. [Checksum Verification / 校验和验证](#checksum-verification)
6. [Using Clash / 通过 Clash 下载](#using-clash)
7. [WSL / curl Usage / 在 WSL 或 curl 中使用](#wsl--curl-usage)
8. [Configure OPENAI_API_KEY / 配置 API Key](#configure-openai_api_key)
9. [Troubleshooting / 常见问题](#troubleshooting)

---

## Overview

The scripts in the `scripts/` directory provide an **official-channel** automated workflow for Windows users to:

- Download the latest (or a specific) OpenAI Codex installer directly from [GitHub Releases](https://github.com/openai/codex/releases).
- Optionally verify the SHA-256 checksum of the downloaded file.
- Optionally perform a silent (unattended) installation.
- Validate the downloaded file with a lightweight smoke-check script.

**No API keys are embedded in any script.** All downloads come exclusively from `https://github.com/openai/codex/releases`.

---

`scripts/` 目录中的脚本为 Windows 用户提供**官方渠道**的自动化工作流：

- 直接从 [GitHub Releases](https://github.com/openai/codex/releases) 下载最新（或指定版本）的 OpenAI Codex 安装包。
- 可选验证下载文件的 SHA-256 校验和。
- 可选执行静默（无人值守）安装。
- 通过轻量级冒烟检测脚本验证已下载的文件。

**脚本中不嵌入任何 API 密钥。** 所有下载均来自 `https://github.com/openai/codex/releases`。

---

## Prerequisites

| Requirement | Detail |
|---|---|
| Windows 10 / 11 | PowerShell 5.1 built-in, or [PowerShell 7+](https://github.com/PowerShell/PowerShell/releases) |
| Internet access | Direct or via a proxy (see [Using Clash](#using-clash)) |
| Optional: `curl` | Required only if `Invoke-WebRequest` is blocked by policy |

---

## Quick Start (PowerShell)

Open **PowerShell** (not Windows Terminal's CMD profile) and run:

```powershell
# 1. Allow script execution for this session (if not already enabled)
#    如未启用，先允许当前会话执行脚本
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 2. Navigate to the repository root
#    切换到仓库根目录
cd path\to\tianhong-fasteners

# 3. Download the latest installer to your Downloads folder
#    下载最新版安装包到下载文件夹
.\scripts\install_codex_windows.ps1

# 4. Run the smoke check to confirm the download
#    运行冒烟检测确认下载成功
.\scripts\check_codex_installer.ps1
```

The installer will be saved to `%USERPROFILE%\Downloads\codex-windows-x64.msi` by default.

---

## Advanced Usage

### Download a specific version / 下载指定版本

```powershell
.\scripts\install_codex_windows.ps1 -Version v0.1.2
```

### Download a `.exe` installer / 下载 .exe 安装包

```powershell
.\scripts\install_codex_windows.ps1 -AssetName 'codex-setup-x64.exe'
```

### Save to a custom folder / 保存到自定义目录

```powershell
.\scripts\install_codex_windows.ps1 -DownloadPath 'D:\Installers'
```

### Download **and** install silently / 下载并静默安装

```powershell
.\scripts\install_codex_windows.ps1 -InstallSilently
```

- For `.msi` files the script runs: `msiexec /i <file> /qn /norestart`
- For `.exe` files the script runs: `<file> /S`

### Smoke-check a specific file / 检测指定文件

```powershell
.\scripts\check_codex_installer.ps1 -InstallerPath 'D:\Installers\codex-setup-x64.exe'
```

---

## Checksum Verification

`install_codex_windows.ps1` automatically looks for a checksum file (e.g., `SHA256SUMS`, `checksums.txt`, or `<asset>.sha256`) among the release assets. If found, it downloads the file and compares the expected hash against the locally computed SHA-256.

To manually verify at any time, use the smoke-check script:

```powershell
.\scripts\check_codex_installer.ps1
```

Or use PowerShell's built-in `Get-FileHash`:

```powershell
Get-FileHash "$env:USERPROFILE\Downloads\codex-windows-x64.msi" -Algorithm SHA256
```

Or use `certutil`:

```cmd
certutil -hashfile "%USERPROFILE%\Downloads\codex-windows-x64.msi" SHA256
```

Compare the output against the value listed on the [GitHub Releases page](https://github.com/openai/codex/releases).

---

`install_codex_windows.ps1` 会自动在 Release Assets 中查找校验和文件（如 `SHA256SUMS`、`checksums.txt` 或 `<资产名>.sha256`）。若找到，则下载并将预期哈希值与本地计算结果进行比对。

如需随时手动验证，可使用冒烟检测脚本或 PowerShell 内置的 `Get-FileHash`。

---

## Using Clash

If you are in mainland China or behind a corporate proxy, you can route the download through [Clash](https://github.com/Dreamacro/clash) (or any HTTP/HTTPS proxy).

### Method 1 — System-wide proxy (recommended)

Configure Clash in **TUN Mode** or set a system proxy; PowerShell's `Invoke-WebRequest` will then use it automatically.

### Method 2 — Per-session environment variables / 会话级代理环境变量

```powershell
# Set proxy for the current PowerShell session
$env:HTTP_PROXY  = "http://127.0.0.1:7890"
$env:HTTPS_PROXY = "http://127.0.0.1:7890"

# Then run the installer script as normal
.\scripts\install_codex_windows.ps1
```

Replace `7890` with your actual Clash HTTP proxy port.

---

## WSL / curl Usage

If you prefer to download from WSL or a system where `curl` is available:

```bash
# Download the latest release (replace vX.Y.Z with the actual tag)
RELEASE_TAG=$(curl -s https://api.github.com/repos/openai/codex/releases/latest \
    | grep '"tag_name"' | cut -d'"' -f4)

curl -L -o ~/Downloads/codex-windows-x64.msi \
    "https://github.com/openai/codex/releases/download/${RELEASE_TAG}/codex-windows-x64.msi"

# Verify the download (replace EXPECTED_HASH with the value from the release page)
sha256sum ~/Downloads/codex-windows-x64.msi
```

Then copy the `.msi` to a Windows path and run it normally.

---

## Configure OPENAI_API_KEY

After installation, set your OpenAI API key so Codex can authenticate.

### Current session only / 仅当前会话

```powershell
$env:OPENAI_API_KEY = "sk-..."
```

### Permanent (current user) / 永久设置（当前用户）

```powershell
[System.Environment]::SetEnvironmentVariable(
    "OPENAI_API_KEY",
    "sk-...",
    "User"
)
```

Or via the Windows GUI:
1. Open **Settings → System → About → Advanced system settings → Environment Variables**.
2. Under *User variables*, click **New**.
3. Name: `OPENAI_API_KEY`, Value: `sk-...`.

> ⚠️ **Security note / 安全提示**: Never commit your API key to source control. Use environment variables or a secrets manager.

---

## Troubleshooting

| Issue | Solution |
|---|---|
| `Invoke-WebRequest` fails with TLS error | Run `[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12` |
| Script won't run (execution policy) | Run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` |
| Asset not found in release | Check the actual asset names at https://github.com/openai/codex/releases and pass the correct name via `-AssetName` |
| Download is slow / times out | Use the Clash proxy method above or a VPN |
| SHA-256 mismatch | Delete the file and re-download; report the issue at https://github.com/openai/codex/issues |
| `msiexec` fails (non-zero exit code) | Run the installer manually as Administrator |
