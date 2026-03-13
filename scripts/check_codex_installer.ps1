<#
.SYNOPSIS
    Smoke-check a downloaded Codex installer by verifying the file exists
    and printing its SHA-256 hash.

.DESCRIPTION
    Accepts a path to a locally downloaded installer file, confirms the file
    is present and readable, and outputs its SHA-256 hash so the caller can
    manually compare it against the value published on the official GitHub
    Releases page.

    Exit codes:
        0   File exists and hash was printed successfully
        1   File not found or an error occurred while hashing

.PARAMETER FilePath
    Full path to the installer file to check (e.g. the .msi or .exe
    downloaded by install_codex_windows.ps1).

.EXAMPLE
    .\check_codex_installer.ps1 -FilePath "$env:USERPROFILE\Downloads\codex-windows-x64.msi"

.EXAMPLE
    # Pipe the result into a comparison
    $hash = .\check_codex_installer.ps1 -FilePath C:\Temp\codex.msi
    if ($hash -eq "<expected-hash>") { Write-Host "OK" } else { Write-Error "Mismatch!" }
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory, HelpMessage = 'Path to the downloaded installer file.')]
    [string] $FilePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# 1. Verify the file exists
# ---------------------------------------------------------------------------
if (-not (Test-Path -LiteralPath $FilePath -PathType Leaf)) {
    Write-Error "File not found: $FilePath"
    exit 1
}

# ---------------------------------------------------------------------------
# 2. Compute and display the SHA-256 hash
# ---------------------------------------------------------------------------
try {
    $fileInfo  = Get-Item -LiteralPath $FilePath
    $hashInfo  = Get-FileHash -LiteralPath $FilePath -Algorithm SHA256

    Write-Host "File     : $($fileInfo.FullName)"
    Write-Host "Size     : $($fileInfo.Length) bytes"
    Write-Host "SHA-256  : $($hashInfo.Hash)"
    Write-Host ""
    Write-Host "Compare the SHA-256 value above with the checksum published on"
    Write-Host "https://github.com/openai/codex/releases to confirm authenticity."

    # Return the hash so callers can capture it with $(...).
    return $hashInfo.Hash
}
catch {
    Write-Error "Failed to compute hash for '$FilePath': $($_.Exception.Message)"
    exit 1
}
