<#
.SYNOPSIS
    Downloads, verifies, and optionally silently installs the OpenAI Codex
    Windows installer from the official GitHub Releases.

.DESCRIPTION
    Fetches release information from https://github.com/openai/codex/releases,
    resolves the requested asset, downloads it, verifies its SHA-256 checksum
    when a checksum file is available, and can optionally run a silent
    installation.

    Exit codes:
        0   Success
        1   General / unexpected error
        2   Asset not found in the specified release
        3   Checksum verification failed
        4   Silent installation failed

.PARAMETER Version
    The release version to download (e.g. 'v0.1.0').  Defaults to 'latest'.

.PARAMETER AssetName
    The filename of the installer asset to download.
    Defaults to 'codex-windows-x64.msi'.

.PARAMETER DownloadPath
    The directory where the installer will be saved.
    Defaults to the current user's Downloads folder.

.PARAMETER InstallSilently
    If specified, attempts a silent/unattended installation after download
    and verification.

.PARAMETER Force
    If specified, skips the interactive confirmation prompt that is shown
    when no checksum file is found on the release.

.PARAMETER GitHubOwner
    The GitHub repository owner / organisation.  Defaults to 'openai'.
    Override this only if you are targeting a fork.

.PARAMETER GitHubRepo
    The GitHub repository name.  Defaults to 'codex'.
    Override this only if you are targeting a fork.

.EXAMPLE
    # Download the latest release to the default Downloads folder
    .\install_codex_windows.ps1

.EXAMPLE
    # Download a specific version and install it silently
    .\install_codex_windows.ps1 -Version v0.2.0 -InstallSilently

.EXAMPLE
    # Download to a custom path, force-skip checksum warning, install silently
    .\install_codex_windows.ps1 -DownloadPath C:\Temp -Force -InstallSilently -Verbose
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]  $Version        = 'latest',
    [string]  $AssetName      = 'codex-windows-x64.msi',
    [string]  $DownloadPath   = (Join-Path ([Environment]::GetFolderPath('UserProfile')) 'Downloads'),
    [switch]  $InstallSilently,
    [switch]  $Force,
    [string]  $GitHubOwner    = 'openai',
    [string]  $GitHubRepo     = 'codex'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Helper: download a URL to a local file using Invoke-WebRequest with a
# curl.exe fallback for environments where IWR is not available.
# ---------------------------------------------------------------------------
function Save-RemoteFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Uri,
        [Parameter(Mandatory)] [string] $OutFile
    )

    Write-Verbose "Downloading '$Uri' → '$OutFile'"

    try {
        Invoke-WebRequest -Uri $Uri -OutFile $OutFile -UseBasicParsing
    }
    catch {
        Write-Verbose "Invoke-WebRequest failed ($($_.Exception.Message)). Trying curl.exe …"
        $curlExe = Get-Command 'curl.exe' -ErrorAction SilentlyContinue
        if (-not $curlExe) {
            throw "Neither Invoke-WebRequest nor curl.exe is available."
        }
        & curl.exe --fail --location --silent --show-error --output $OutFile $Uri
        if ($LASTEXITCODE -ne 0) {
            throw "curl.exe exited with code $LASTEXITCODE while downloading '$Uri'."
        }
    }
}

# ---------------------------------------------------------------------------
# Helper: convert a raw checksum file (various common formats) to a hashtable
# of  filename → sha256hash.
# ---------------------------------------------------------------------------
function ConvertFrom-ChecksumFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $FilePath
    )

    $result = @{}
    $lines  = Get-Content -LiteralPath $FilePath -Encoding UTF8

    foreach ($line in $lines) {
        $line = $line.Trim()
        if ([string]::IsNullOrEmpty($line) -or $line.StartsWith('#')) { continue }

        # Common format: "<hash>  <filename>" or "<hash> *<filename>"
        if ($line -match '^([0-9a-fA-F]{64})\s+\*?(.+)$') {
            $hash = $Matches[1].ToLower()
            $name = [System.IO.Path]::GetFileName($Matches[2].Trim())
            $result[$name] = $hash
        }
        # Format used by some single-file .sha256 files: just the hash on its own
        elseif ($line -match '^([0-9a-fA-F]{64})$') {
            $result['__single__'] = $Matches[1].ToLower()
        }
    }

    return $result
}

# ===========================================================================
# 1. Resolve release info from the GitHub API
# ===========================================================================
if ($Version -eq 'latest') {
    $apiUrl = "https://api.github.com/repos/$GitHubOwner/$GitHubRepo/releases/latest"
}
else {
    # GitHub tags can be specified with or without a leading 'v'.
    $tag    = $Version
    $apiUrl = "https://api.github.com/repos/$GitHubOwner/$GitHubRepo/releases/tags/$tag"
}

Write-Verbose "Querying GitHub Releases API: $apiUrl"

try {
    $headers  = @{ 'User-Agent' = 'install_codex_windows.ps1' }
    $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -UseBasicParsing
}
catch {
    Write-Error "Failed to retrieve release information from GitHub.`n$($_.Exception.Message)"
    exit 1
}

$releaseTag  = $response.tag_name
$releaseName = $response.name
Write-Host "Release : $releaseName ($releaseTag)"

$assets = $response.assets
if (-not $assets -or $assets.Count -eq 0) {
    Write-Error "No assets found for release '$releaseTag'."
    exit 2
}

# ===========================================================================
# 2. Locate the requested installer asset
# ===========================================================================
$installerAsset = $assets | Where-Object { $_.name -eq $AssetName } | Select-Object -First 1

if (-not $installerAsset) {
    Write-Error "Asset '$AssetName' was not found in release '$releaseTag'.`nAvailable assets:`n$($assets | ForEach-Object { '  ' + $_.name } | Out-String)"
    exit 2
}

Write-Verbose "Found installer asset : $($installerAsset.name)  ($($installerAsset.browser_download_url))"

# ===========================================================================
# 3. Locate a checksum asset (*.sha256, checksums.txt, SHA256SUMS)
# ===========================================================================
$checksumPatterns = @('*.sha256', 'checksums.txt', 'SHA256SUMS')
$checksumAsset    = $null

foreach ($pattern in $checksumPatterns) {
    $checksumAsset = $assets | Where-Object { $_.name -like $pattern } | Select-Object -First 1
    if ($checksumAsset) { break }
}

# ===========================================================================
# 4. Download the installer
# ===========================================================================
if (-not (Test-Path -LiteralPath $DownloadPath -PathType Container)) {
    Write-Verbose "Creating download directory: $DownloadPath"
    New-Item -ItemType Directory -Path $DownloadPath -Force | Out-Null
}

$installerLocalPath = Join-Path $DownloadPath $installerAsset.name
Write-Host "Downloading installer to: $installerLocalPath"
Save-RemoteFile -Uri $installerAsset.browser_download_url -OutFile $installerLocalPath

# ===========================================================================
# 5. Verify checksum
# ===========================================================================
if ($checksumAsset) {
    $checksumLocalPath = Join-Path $DownloadPath $checksumAsset.name
    Write-Host "Downloading checksum file: $($checksumAsset.name)"
    Save-RemoteFile -Uri $checksumAsset.browser_download_url -OutFile $checksumLocalPath

    Write-Verbose "Parsing checksum file …"
    $checksumTable = ConvertFrom-ChecksumFile -FilePath $checksumLocalPath

    # Try to find the hash by exact asset name, or fall back to the
    # single-hash shorthand used by dedicated per-file .sha256 files.
    $expectedHash = $null
    if ($checksumTable.ContainsKey($installerAsset.name)) {
        $expectedHash = $checksumTable[$installerAsset.name]
    }
    elseif ($checksumTable.ContainsKey('__single__')) {
        $expectedHash = $checksumTable['__single__']
    }

    if (-not $expectedHash) {
        Write-Warning "Checksum file '$($checksumAsset.name)' was downloaded but no entry for '$($installerAsset.name)' was found.  Skipping verification."
    }
    else {
        Write-Host "Verifying SHA-256 checksum …"
        $actualHash = (Get-FileHash -LiteralPath $installerLocalPath -Algorithm SHA256).Hash.ToLower()

        if ($actualHash -ne $expectedHash) {
            Write-Error "SHA-256 mismatch!`n  Expected : $expectedHash`n  Actual   : $actualHash`n`nThe file may be corrupted or tampered with.  Aborting."
            exit 3
        }

        Write-Host "Checksum verified OK: $actualHash"
    }
}
else {
    Write-Warning "No checksum file was found for this release.  The installer has NOT been independently verified."

    if (-not $Force) {
        $confirm = Read-Host "Continue without checksum verification? [y/N]"
        if ($confirm -notmatch '^[yY]$') {
            Write-Host "Aborted by user."
            exit 1
        }
    }
    else {
        Write-Verbose "-Force specified; skipping checksum verification prompt."
    }
}

# ===========================================================================
# 6. Optional silent installation
# ===========================================================================
if ($InstallSilently) {
    $extension = [System.IO.Path]::GetExtension($installerLocalPath).ToLower()

    Write-Host "Starting silent installation: $installerLocalPath"

    if ($extension -eq '.msi') {
        # msiexec /i — quiet, no UI, log to a temp file for diagnostics
        $logFile = Join-Path $env:TEMP "codex_install_$(Get-Date -Format 'yyyyMMddHHmmss').log"
        Write-Verbose "MSI installation log: $logFile"

        if ($PSCmdlet.ShouldProcess($installerLocalPath, 'msiexec /i /qn')) {
            $proc = Start-Process -FilePath 'msiexec.exe' `
                -ArgumentList "/i `"$installerLocalPath`" /qn /norestart /log `"$logFile`"" `
                -Wait -PassThru -NoNewWindow
        }
        else {
            # -WhatIf path: simulate success
            $proc = [PSCustomObject]@{ ExitCode = 0 }
        }

        if ($proc.ExitCode -ne 0) {
            Write-Error "msiexec exited with code $($proc.ExitCode).  See log: $logFile"
            exit 4
        }
    }
    elseif ($extension -eq '.exe') {
        # Try common silent flags in order until one succeeds.
        $silentFlags = @('/S', '/silent', '/verysilent', '/quiet', '/qn')
        $installed   = $false

        foreach ($flag in $silentFlags) {
            Write-Verbose "Trying installer flag: $flag"

            if ($PSCmdlet.ShouldProcess($installerLocalPath, "Silent install with flag '$flag'")) {
                $proc = Start-Process -FilePath $installerLocalPath `
                    -ArgumentList $flag `
                    -Wait -PassThru -NoNewWindow
            }
            else {
                $proc = [PSCustomObject]@{ ExitCode = 0 }
            }

            # Exit code 0 (success) or 3010 (success, reboot required) are acceptable.
            if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 3010) {
                $installed = $true
                if ($proc.ExitCode -eq 3010) {
                    Write-Warning "Installation succeeded but a system restart is required."
                }
                break
            }

            Write-Verbose "Flag '$flag' returned exit code $($proc.ExitCode); trying next flag …"
        }

        if (-not $installed) {
            Write-Error "All silent installation flags failed.  You may need to run the installer manually."
            exit 4
        }
    }
    else {
        Write-Error "Unsupported installer extension '$extension'.  Only .msi and .exe installers are supported for silent installation."
        exit 4
    }

    Write-Host "Installation completed successfully."
}
else {
    Write-Host "`nInstaller saved to: $installerLocalPath"
    Write-Host "Run the installer manually, or re-run this script with -InstallSilently to install automatically."
}
