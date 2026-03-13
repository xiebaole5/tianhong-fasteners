<#
.SYNOPSIS
    Downloads, verifies, and optionally installs the latest OpenAI Codex
    Windows installer from the official GitHub Releases page.
    从 OpenAI Codex 官方 GitHub Releases 下载、验证并安装 Windows 安装包。

.DESCRIPTION
    This script fetches the specified (or latest) release from
    https://github.com/openai/codex/releases, downloads the named installer
    asset into the chosen directory, optionally verifies its SHA-256 checksum
    against the release's checksums file, and—when -InstallSilently is
    specified—performs an unattended installation.

.PARAMETER Version
    The release tag to download (e.g. 'v1.0.0').
    Defaults to 'latest', which resolves the most recent published release.
    要下载的版本标签（如 'v1.0.0'），默认为 'latest'（最新版）。

.PARAMETER AssetName
    The filename of the installer asset to download from the release.
    Defaults to 'codex-windows-x64.msi'.
    需要下载的安装包文件名，默认为 'codex-windows-x64.msi'。

.PARAMETER DownloadPath
    The local directory where the installer will be saved.
    Defaults to the current user's Downloads folder.
    安装包保存的本地目录，默认为当前用户的下载文件夹。

.PARAMETER InstallSilently
    When specified, runs the installer silently after a successful download
    and checksum verification (or after the user confirms when verification
    is skipped).
    指定此开关后，将在校验通过（或用户确认跳过校验）后静默安装。

.EXAMPLE
    # Download the latest release (interactive, no install)
    .\install_codex_windows.ps1

.EXAMPLE
    # Download a specific version and install silently
    .\install_codex_windows.ps1 -Version v0.1.2 -InstallSilently

.EXAMPLE
    # Download an .exe asset to a custom folder
    .\install_codex_windows.ps1 -AssetName 'codex-setup-x64.exe' `
        -DownloadPath 'D:\Installers'

.NOTES
    - Only downloads from official GitHub Releases:
        https://github.com/openai/codex/releases
    - No API keys or credentials are embedded in this script.
    - Requires PowerShell 5.1+ or PowerShell 7+ on Windows.
    - 仅从官方 GitHub Releases 下载，不嵌入任何密钥或凭据。
    - 需要 PowerShell 5.1 或 PowerShell 7+ (Windows)。
#>

[CmdletBinding()]
param(
    [string]  $Version        = 'latest',
    [string]  $AssetName      = 'codex-windows-x64.msi',
    [string]  $DownloadPath   = (Join-Path $env:USERPROFILE 'Downloads'),
    [switch]  $InstallSilently
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ── Constants ──────────────────────────────────────────────────────────────────
$GITHUB_API_BASE  = 'https://api.github.com/repos/openai/codex/releases'
$GITHUB_REPO_BASE = 'https://github.com/openai/codex/releases'

# ── Helper: safe web request with curl fallback ────────────────────────────────
function Invoke-SafeWebRequest {
    param(
        [string] $Uri,
        [string] $OutFile = $null
    )

    Write-Verbose "Requesting: $Uri"
    try {
        if ($OutFile) {
            Invoke-WebRequest -Uri $Uri -OutFile $OutFile -UseBasicParsing
        }
        else {
            return (Invoke-WebRequest -Uri $Uri -UseBasicParsing).Content
        }
    }
    catch {
        Write-Warning "Invoke-WebRequest failed ($($_.Exception.Message)). Trying curl fallback..."
        if ($OutFile) {
            & curl --fail --location --silent --show-error --output $OutFile $Uri
            if ($LASTEXITCODE -ne 0) {
                throw "curl download failed (exit $LASTEXITCODE) for: $Uri"
            }
        }
        else {
            $content = & curl --fail --location --silent --show-error $Uri
            if ($LASTEXITCODE -ne 0) {
                throw "curl request failed (exit $LASTEXITCODE) for: $Uri"
            }
            return $content
        }
    }
}

# ── Step 1: Resolve the release API URL ───────────────────────────────────────
if ($Version -eq 'latest') {
    $releaseApiUrl = "$GITHUB_API_BASE/latest"
    Write-Host "[1/5] Resolving latest release from $releaseApiUrl ..." -ForegroundColor Cyan
}
else {
    # Ensure the version tag starts with 'v'
    if (-not $Version.StartsWith('v')) { $Version = "v$Version" }
    $releaseApiUrl = "$GITHUB_API_BASE/tags/$Version"
    Write-Host "[1/5] Resolving release '$Version' from $releaseApiUrl ..." -ForegroundColor Cyan
}

# ── Step 2: Fetch release metadata (JSON) ─────────────────────────────────────
Write-Host "[2/5] Fetching release metadata..." -ForegroundColor Cyan
$releaseJson = Invoke-SafeWebRequest -Uri $releaseApiUrl
$release     = $releaseJson | ConvertFrom-Json

$ResolvedTag  = $release.tag_name
$PublishedAt  = $release.published_at
Write-Host "      Tag  : $ResolvedTag"
Write-Host "      Date : $PublishedAt"

$assets = $release.assets
if (-not $assets -or $assets.Count -eq 0) {
    Write-Error "No assets found for release '$ResolvedTag'. Check $GITHUB_REPO_BASE"
    exit 1
}

Write-Verbose "Available assets:"
$assets | ForEach-Object { Write-Verbose "  $($_.name)" }

# ── Step 3: Locate the installer asset ────────────────────────────────────────
Write-Host "[3/5] Locating installer asset '$AssetName' in release $ResolvedTag ..." -ForegroundColor Cyan

$installerAsset = $assets | Where-Object { $_.name -eq $AssetName } | Select-Object -First 1
if (-not $installerAsset) {
    $availableNames = ($assets | Select-Object -ExpandProperty name) -join ', '
    Write-Error "Asset '$AssetName' not found in release '$ResolvedTag'.`nAvailable assets: $availableNames`nPlease re-run with -AssetName set to one of the above."
    exit 1
}

$installerUrl      = $installerAsset.browser_download_url
$installerFilePath = Join-Path $DownloadPath $AssetName

# Ensure the download directory exists
if (-not (Test-Path $DownloadPath)) {
    Write-Host "      Creating download directory: $DownloadPath"
    New-Item -ItemType Directory -Path $DownloadPath | Out-Null
}

# ── Step 4: Download the installer ────────────────────────────────────────────
Write-Host "[4/5] Downloading installer..." -ForegroundColor Cyan
Write-Host "      URL  : $installerUrl"
Write-Host "      Dest : $installerFilePath"
Invoke-SafeWebRequest -Uri $installerUrl -OutFile $installerFilePath
Write-Host "      Download complete." -ForegroundColor Green

# ── Step 5: Checksum verification ─────────────────────────────────────────────
Write-Host "[5/5] Checking for checksum file in release assets..." -ForegroundColor Cyan

# Look for a checksums file: SHA256SUMS, checksums.txt, or <assetname>.sha256
$checksumAsset = $assets | Where-Object {
    $_.name -match '(?i)(sha256|checksums?)(\.txt)?$' -or
    $_.name -eq "$AssetName.sha256"
} | Select-Object -First 1

$verificationPassed = $false

if ($checksumAsset) {
    $checksumUrl      = $checksumAsset.browser_download_url
    $checksumFileName = $checksumAsset.name
    $checksumFilePath = Join-Path $DownloadPath $checksumFileName

    Write-Host "      Found checksum file: $checksumFileName"
    Write-Host "      Downloading checksum file from: $checksumUrl"
    Invoke-SafeWebRequest -Uri $checksumUrl -OutFile $checksumFilePath

    # Parse the checksum for our specific installer asset
    $checksumContent = Get-Content $checksumFilePath -Raw
    $expectedHash    = $null

    foreach ($line in ($checksumContent -split "`n")) {
        $line = $line.Trim()
        if ($line -match "^([0-9a-fA-F]{64})\s+\*?$([regex]::Escape($AssetName))$") {
            $expectedHash = $Matches[1].ToUpper()
            break
        }
    }

    if ($expectedHash) {
        Write-Host "      Expected SHA256 : $expectedHash"
        $actualHash = (Get-FileHash -Path $installerFilePath -Algorithm SHA256).Hash.ToUpper()
        Write-Host "      Actual SHA256   : $actualHash"

        if ($actualHash -eq $expectedHash) {
            Write-Host "      ✔ SHA256 checksum verified successfully." -ForegroundColor Green
            $verificationPassed = $true
        }
        else {
            Write-Error "SHA256 mismatch!`n  Expected : $expectedHash`n  Got      : $actualHash`nThe downloaded file may be corrupted or tampered with. Aborting."
            exit 2
        }
    }
    else {
        Write-Warning "Could not find a SHA256 entry for '$AssetName' in '$checksumFileName'."
        Write-Warning "Skipping checksum verification."
        $verificationPassed = $false
    }
}
else {
    Write-Warning "No checksum file found among the release assets."
    Write-Warning "Skipping SHA256 verification — the installer has NOT been cryptographically verified."
    $verificationPassed = $false
}

# ── Confirmation prompt when verification was skipped ─────────────────────────
if (-not $verificationPassed -and $InstallSilently) {
    $answer = Read-Host "Checksum verification was skipped. Proceed with installation anyway? [y/N]"
    if ($answer -notmatch '^[yY]$') {
        Write-Host "Installation cancelled by user." -ForegroundColor Yellow
        exit 0
    }
}

# ── Optional: Silent installation ─────────────────────────────────────────────
if ($InstallSilently) {
    $ext = [System.IO.Path]::GetExtension($AssetName).ToLower()
    Write-Host ""
    Write-Host "Starting silent installation of: $installerFilePath" -ForegroundColor Cyan

    if ($ext -eq '.msi') {
        Write-Host "Running: msiexec /i `"$installerFilePath`" /qn /norestart"
        $proc = Start-Process -FilePath 'msiexec.exe' `
            -ArgumentList "/i `"$installerFilePath`" /qn /norestart" `
            -Wait -PassThru
        $exitCode = $proc.ExitCode
    }
    elseif ($ext -eq '.exe') {
        Write-Host "Running: `"$installerFilePath`" /S"
        $proc = Start-Process -FilePath $installerFilePath `
            -ArgumentList '/S' `
            -Wait -PassThru
        $exitCode = $proc.ExitCode
    }
    else {
        Write-Warning "Unknown installer extension '$ext'. Please install '$installerFilePath' manually."
        exit 0
    }

    if ($exitCode -eq 0 -or $exitCode -eq 3010) {
        Write-Host "Installation completed successfully (exit code $exitCode)." -ForegroundColor Green
        if ($exitCode -eq 3010) {
            Write-Host "A system restart may be required to complete the installation." -ForegroundColor Yellow
        }
    }
    else {
        Write-Error "Installer exited with code $exitCode. Installation may have failed."
        exit $exitCode
    }
}
else {
    Write-Host ""
    Write-Host "Installer saved to: $installerFilePath" -ForegroundColor Green
    Write-Host "Run it manually, or re-run this script with -InstallSilently to install automatically."
}

Write-Host ""
Write-Host "Done. To configure your OpenAI API key after installation, run:" -ForegroundColor Cyan
Write-Host '  $env:OPENAI_API_KEY = "sk-..."   # current session only'
Write-Host '  [System.Environment]::SetEnvironmentVariable("OPENAI_API_KEY","sk-...","User")  # permanent'
Write-Host ""
Write-Host "For more information see: docs/CODEX_INSTALL.md"
