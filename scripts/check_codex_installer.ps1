<#
.SYNOPSIS
    Smoke-check: validates that the Codex Windows installer was downloaded
    correctly and prints its SHA-256 hash.
    冒烟测试：验证 Codex Windows 安装包是否已正确下载并打印其 SHA-256 哈希值。

.DESCRIPTION
    This script is a lightweight sanity check that:
      1. Confirms the installer file exists at the expected path.
      2. Verifies the file is non-empty (size > 0 bytes).
      3. Computes and prints the SHA-256 hash of the file.

    It does NOT connect to the internet or perform any installation.
    Run it after install_codex_windows.ps1 to confirm the download succeeded.

.PARAMETER InstallerPath
    Full path to the installer file to validate.
    If not supplied, defaults to the user's Downloads folder and the
    default asset name 'codex-windows-x64.msi'.
    待验证安装包的完整路径。
    未指定时默认检查下载文件夹中的 'codex-windows-x64.msi'。

.EXAMPLE
    # Check the default download location
    .\check_codex_installer.ps1

.EXAMPLE
    # Check a specific file
    .\check_codex_installer.ps1 -InstallerPath 'D:\Installers\codex-setup.exe'

.NOTES
    Exit codes:
      0  — file exists, is non-empty, and SHA-256 was printed successfully.
      1  — file not found.
      2  — file exists but is empty (0 bytes), suggesting a failed download.
#>

[CmdletBinding()]
param(
    [string] $InstallerPath = (Join-Path $env:USERPROFILE 'Downloads\codex-windows-x64.msi')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Codex Installer Smoke Check" -ForegroundColor Cyan
Write-Host " Codex 安装包冒烟检测" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Checking file: $InstallerPath"
Write-Host ""

# ── Check 1: File exists ───────────────────────────────────────────────────────
if (-not (Test-Path -LiteralPath $InstallerPath -PathType Leaf)) {
    Write-Host "[FAIL] File not found: $InstallerPath" -ForegroundColor Red
    Write-Host "       Run install_codex_windows.ps1 first to download the installer."
    exit 1
}
Write-Host "[OK]   File exists." -ForegroundColor Green

# ── Check 2: File is non-empty ────────────────────────────────────────────────
$fileInfo = Get-Item -LiteralPath $InstallerPath
$sizeBytes = $fileInfo.Length
$SizeMB    = [math]::Round($sizeBytes / 1MB, 2)

if ($sizeBytes -eq 0) {
    Write-Host "[FAIL] File is empty (0 bytes). The download may have failed." -ForegroundColor Red
    exit 2
}
Write-Host "[OK]   File size: $sizeBytes bytes ($SizeMB MB)." -ForegroundColor Green

# ── Check 3: Compute and print SHA-256 ────────────────────────────────────────
Write-Host ""
Write-Host "Computing SHA-256 hash (this may take a moment for large files)..."
$hash = (Get-FileHash -LiteralPath $InstallerPath -Algorithm SHA256).Hash
Write-Host ""
Write-Host "SHA-256: $hash" -ForegroundColor Yellow
Write-Host ""
Write-Host "Compare the above value against the SHA256SUMS (or .sha256) file" -ForegroundColor Cyan
Write-Host "published on the release page:"
Write-Host "  https://github.com/openai/codex/releases"
Write-Host ""
Write-Host "[PASS] Smoke check completed successfully." -ForegroundColor Green
Write-Host ""
Write-Host "Tip: Set your API key before launching Codex:"
Write-Host '  $env:OPENAI_API_KEY = "sk-..."'
Write-Host '  [System.Environment]::SetEnvironmentVariable("OPENAI_API_KEY","sk-...","User")'

exit 0
