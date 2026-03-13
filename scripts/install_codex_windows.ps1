<#
.SYNOPSIS
    Downloads, verifies, and optionally silently installs the OpenAI Codex
    Windows installer from the project's official GitHub Releases.

.DESCRIPTION
    This script fetches release information from the official GitHub Releases API
    (https://api.github.com/repos/openai/codex/releases), downloads the specified
    installer asset, attempts to verify its SHA-256 checksum, and can run a silent
    installation.

    No API keys or secrets are required.  Only the official GitHub Releases URL is
    used as the download source.

.PARAMETER Version
    The release version to download.  Use 'latest' (the default) to automatically
    resolve the most-recent release, or supply a specific tag name (e.g. 'v1.2.3').

.PARAMETER AssetName
    The file name of the installer asset to download.
    Defaults to 'codex-windows-x64.msi'.

.PARAMETER DownloadPath
    The directory where the installer (and any checksum file) will be saved.
    Defaults to the current user's Downloads folder.

.PARAMETER InstallSilently
    When specified, the script will attempt a silent / unattended installation
    after a successful download and verification.

.PARAMETER Force
    Skip the interactive confirmation prompt that is shown when no checksum asset
    is available on the release.  Also suppresses re-download prompts when the
    target file already exists.

.EXAMPLE
    # Download latest installer to Downloads folder
    .\install_codex_windows.ps1

.EXAMPLE
    # Download a specific version and install silently
    .\install_codex_windows.ps1 -Version v1.2.3 -InstallSilently

.EXAMPLE
    # Force download without checksum confirmation, custom destination
    .\install_codex_windows.ps1 -DownloadPath C:\Installers -Force

.NOTES
    Source:  https://github.com/openai/codex/releases
    License: See the openai/codex repository for licensing details.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [string] $Version      = 'latest',
    [string] $AssetName    = 'codex-windows-x64.msi',
    [string] $DownloadPath = (Join-Path $env:USERPROFILE 'Downloads'),
    [switch] $InstallSilently,
    [switch] $Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

function Write-Info  { param([string]$Msg) Write-Host "[INFO]  $Msg" -ForegroundColor Cyan    }
function Write-Ok    { param([string]$Msg) Write-Host "[OK]    $Msg" -ForegroundColor Green   }
function Write-Warn  { param([string]$Msg) Write-Host "[WARN]  $Msg" -ForegroundColor Yellow  }
function Write-Err   { param([string]$Msg) Write-Host "[ERROR] $Msg" -ForegroundColor Red     }

function Invoke-Download {
    <#
    .SYNOPSIS Downloads a URL to a local file using Invoke-WebRequest with a
               curl.exe fallback.
    #>
    param(
        [string] $Uri,
        [string] $OutFile
    )

    Write-Verbose "Downloading: $Uri -> $OutFile"

    # Try Invoke-WebRequest first (always available in PowerShell 3+)
    try {
        $iwrParams = @{
            Uri     = $Uri
            OutFile = $OutFile
            UseBasicParsing = $true
        }
        # Provide a browser-like User-Agent to avoid 403 from some CDN origins
        $iwrParams['UserAgent'] = 'Mozilla/5.0 (compatible; PowerShell)'

        Invoke-WebRequest @iwrParams
        return
    }
    catch {
        Write-Warn "Invoke-WebRequest failed: $($_.Exception.Message)"
        Write-Warn "Falling back to curl.exe …"
    }

    # Fallback: curl.exe (available in Windows 10 1803+ and WSL environments)
    $curlExe = Get-Command 'curl.exe' -ErrorAction SilentlyContinue
    if (-not $curlExe) {
        Write-Err "curl.exe is not available and Invoke-WebRequest also failed."
        exit 1
    }

    $curlArgs = @('-L', '--fail', '--progress-bar', '-o', $OutFile, $Uri)
    Write-Verbose "curl.exe $($curlArgs -join ' ')"
    & curl.exe @curlArgs
    if ($LASTEXITCODE -ne 0) {
        Write-Err "curl.exe exited with code $LASTEXITCODE"
        exit $LASTEXITCODE
    }
}

# ---------------------------------------------------------------------------
# Step 1 – Resolve the release via the GitHub API
# ---------------------------------------------------------------------------

$ApiBase    = 'https://api.github.com/repos/openai/codex/releases'

if ($Version -eq 'latest') {
    $ApiUrl = "$ApiBase/latest"
    Write-Info "Resolving latest release from $ApiUrl …"
} else {
    $ApiUrl = "$ApiBase/tags/$Version"
    Write-Info "Resolving release '$Version' from $ApiUrl …"
}

Write-Verbose "GET $ApiUrl"
try {
    $releaseJson = Invoke-RestMethod -Uri $ApiUrl -UseBasicParsing
}
catch {
    Write-Err "Failed to fetch release information: $($_.Exception.Message)"
    Write-Err "Check your internet connection or try again later."
    exit 1
}

$tagName = $releaseJson.tag_name
Write-Ok "Found release: $tagName  ($($releaseJson.name))"
Write-Verbose "Published: $($releaseJson.published_at)"

# ---------------------------------------------------------------------------
# Step 2 – Find the installer asset
# ---------------------------------------------------------------------------

$assets = $releaseJson.assets
if (-not $assets -or $assets.Count -eq 0) {
    Write-Err "No assets found in release '$tagName'."
    exit 1
}

Write-Verbose "Available assets:"
$assets | ForEach-Object { Write-Verbose "  $($_.name)  ($($_.size) bytes)" }

$installerAsset = $assets | Where-Object { $_.name -eq $AssetName } | Select-Object -First 1
if (-not $installerAsset) {
    Write-Err "Could not find asset '$AssetName' in release '$tagName'."
    Write-Err "Available assets:"
    $assets | ForEach-Object { Write-Err "  $($_.name)" }
    exit 1
}

Write-Ok "Located installer asset: $($installerAsset.name)  ($($installerAsset.size) bytes)"

# ---------------------------------------------------------------------------
# Step 3 – Prepare download path
# ---------------------------------------------------------------------------

if (-not (Test-Path $DownloadPath -PathType Container)) {
    Write-Info "Creating directory: $DownloadPath"
    New-Item -ItemType Directory -Path $DownloadPath -Force | Out-Null
}

$installerLocalPath = Join-Path $DownloadPath $installerAsset.name

if ((Test-Path $installerLocalPath) -and -not $Force) {
    Write-Warn "File already exists: $installerLocalPath"
    $answer = Read-Host 'Overwrite? [y/N]'
    if ($answer -notmatch '^[Yy]') {
        Write-Info "Skipping download.  Using existing file."
    } else {
        Remove-Item $installerLocalPath -Force
        Invoke-Download -Uri $installerAsset.browser_download_url -OutFile $installerLocalPath
    }
} else {
    if (Test-Path $installerLocalPath) { Remove-Item $installerLocalPath -Force }
    Invoke-Download -Uri $installerAsset.browser_download_url -OutFile $installerLocalPath
}

if (-not (Test-Path $installerLocalPath)) {
    Write-Err "Installer file not found after download: $installerLocalPath"
    exit 1
}
Write-Ok "Installer saved to: $installerLocalPath"

# ---------------------------------------------------------------------------
# Step 4 – Look for a checksum asset and verify
# ---------------------------------------------------------------------------

# Common checksum file name patterns (ordered by preference)
$checksumPatterns = @('*.sha256', 'checksums.txt', 'SHA256SUMS', 'sha256sums.txt', '*.sha256sum')
$checksumAsset    = $null

foreach ($pattern in $checksumPatterns) {
    $checksumAsset = $assets | Where-Object { $_.name -like $pattern } | Select-Object -First 1
    if ($checksumAsset) { break }
}

if ($checksumAsset) {
    Write-Info "Found checksum asset: $($checksumAsset.name)"
    $checksumLocalPath = Join-Path $DownloadPath $checksumAsset.name

    Invoke-Download -Uri $checksumAsset.browser_download_url -OutFile $checksumLocalPath
    Write-Ok "Checksum file saved to: $checksumLocalPath"

    # Parse the expected hash for our specific installer file
    $expectedHash = $null
    $checksumContent = Get-Content $checksumLocalPath -Raw

    # Support formats:
    #   <hash>  <filename>   (sha256sum / GNU coreutils style)
    #   <hash> *<filename>   (binary mode marker)
    #   <filename>: <hash>   (some custom formats)
    foreach ($line in ($checksumContent -split "`n")) {
        $line = $line.Trim()
        if ($line -match '^([A-Fa-f0-9]{64})\s+\*?' + [regex]::Escape($installerAsset.name)) {
            $expectedHash = $Matches[1].ToUpper()
            break
        }
        if ($line -match ([regex]::Escape($installerAsset.name) + '\s*:\s*([A-Fa-f0-9]{64})')) {
            $expectedHash = $Matches[1].ToUpper()
            break
        }
    }

    if (-not $expectedHash) {
        Write-Warn "Could not parse expected hash for '$($installerAsset.name)' from '$($checksumAsset.name)'."
        Write-Warn "Checksum file content:"
        $checksumContent -split "`n" | ForEach-Object { Write-Warn "  $_" }
    } else {
        Write-Info "Expected SHA-256 : $expectedHash"

        $actualHash = (Get-FileHash -Path $installerLocalPath -Algorithm SHA256).Hash.ToUpper()
        Write-Info "Computed SHA-256 : $actualHash"

        if ($actualHash -eq $expectedHash) {
            Write-Ok "SHA-256 verification PASSED."
        } else {
            Write-Err "SHA-256 verification FAILED!"
            Write-Err "  Expected : $expectedHash"
            Write-Err "  Got      : $actualHash"
            Write-Err "The downloaded file may be corrupted or tampered with."
            Write-Err "Deleting potentially unsafe file: $installerLocalPath"
            Remove-Item $installerLocalPath -Force -ErrorAction SilentlyContinue
            exit 2
        }
    }
} else {
    Write-Warn "No checksum asset found in release '$tagName'."
    Write-Warn "It is recommended to verify the installer manually:"
    Write-Warn "  certutil -hashfile `"$installerLocalPath`" SHA256"
    Write-Warn "and compare with the value published on the GitHub Releases page:"
    Write-Warn "  https://github.com/openai/codex/releases/tag/$tagName"

    if (-not $Force) {
        $answer = Read-Host 'Continue without checksum verification? [y/N]'
        if ($answer -notmatch '^[Yy]') {
            Write-Info "Aborted by user."
            exit 3
        }
    } else {
        Write-Warn "-Force specified; skipping confirmation prompt."
    }
}

# ---------------------------------------------------------------------------
# Step 5 – Optional silent installation
# ---------------------------------------------------------------------------

if (-not $InstallSilently) {
    Write-Info "Installer ready: $installerLocalPath"
    Write-Info "Run with -InstallSilently to install automatically, or double-click the file to install manually."
    exit 0
}

$ext = [System.IO.Path]::GetExtension($installerLocalPath).ToLower()

if ($ext -eq '.msi') {
    # ---- MSI silent install ----
    Write-Info "Starting silent MSI installation …"
    Write-Verbose "msiexec /i `"$installerLocalPath`" /qn /norestart"

    if ($PSCmdlet.ShouldProcess($installerLocalPath, 'msiexec /i /qn')) {
        $proc = Start-Process -FilePath 'msiexec.exe' `
                              -ArgumentList "/i `"$installerLocalPath`" /qn /norestart" `
                              -Wait -PassThru
        $exitCode = $proc.ExitCode
        Write-Verbose "msiexec exit code: $exitCode"

        switch ($exitCode) {
            0       { Write-Ok  "MSI installation completed successfully (exit code 0)." }
            3010    { Write-Ok  "MSI installation succeeded; a reboot is required (exit code 3010)." }
            1602    { Write-Warn "Installation cancelled by the user (exit code 1602)." ; exit $exitCode }
            1618    { Write-Warn "Another installation is already running (exit code 1618)." ; exit $exitCode }
            1619    { Write-Err  "Installation package could not be opened (exit code 1619)." ; exit $exitCode }
            1638    { Write-Warn "Another version is already installed (exit code 1638)." ; exit $exitCode }
            default { Write-Err  "MSI installation failed with exit code $exitCode." ; exit $exitCode }
        }
    }

} elseif ($ext -eq '.exe') {
    # ---- EXE silent install – try common silent flags ----
    # Different installers use different flags; we try them in order.
    $silentFlags = @('/S', '/silent', '/verysilent', '/quiet', '/qn')
    $installed   = $false

    foreach ($flag in $silentFlags) {
        Write-Info "Trying EXE installer with flag: $flag"
        Write-Verbose "& `"$installerLocalPath`" $flag"

        if ($PSCmdlet.ShouldProcess($installerLocalPath, "Run with flag $flag")) {
            $proc = Start-Process -FilePath $installerLocalPath `
                                  -ArgumentList $flag `
                                  -Wait -PassThru
            $exitCode = $proc.ExitCode
            Write-Verbose "Exit code: $exitCode"

            if ($exitCode -eq 0) {
                Write-Ok "EXE installation completed successfully with flag '$flag' (exit code 0)."
                $installed = $true
                break
            } elseif ($exitCode -eq 3010) {
                Write-Ok "EXE installation succeeded with flag '$flag'; a reboot is required (exit code 3010)."
                $installed = $true
                break
            } else {
                Write-Warn "Flag '$flag' exited with code $exitCode; trying next flag …"
            }
        }
    }

    if (-not $installed) {
        Write-Err "Could not complete silent EXE installation with any of the tried flags: $($silentFlags -join ', ')"
        Write-Err "Try running the installer manually: $installerLocalPath"
        exit 1
    }

} else {
    Write-Warn "Unknown installer extension '$ext'; cannot install silently."
    Write-Info "Installer saved to: $installerLocalPath"
    Write-Info "Please run it manually to complete the installation."
    exit 0
}

Write-Ok "Done.  OpenAI Codex Windows installer process completed."
Write-Info "After installation, set your API key:"
Write-Info "  setx OPENAI_API_KEY `"sk-xxxxxxxxxxxxxxxx`""
Write-Info "Or in the current session only:"
Write-Info "  `$env:OPENAI_API_KEY = `"sk-xxxxxxxxxxxxxxxx`""
