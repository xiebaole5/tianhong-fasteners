<#
.SYNOPSIS
    Smoke-check an OpenAI Codex installer file: verify it exists and print its
    SHA-256 hash.

.DESCRIPTION
    Accepts the path to a downloaded installer file, confirms the file is present,
    computes and displays its SHA-256 hash using Get-FileHash, and exits with a
    non-zero status code if any step fails.

    Use this script to quickly validate a downloaded installer before running it,
    or to compare the hash against the value published on the GitHub Releases page:
      https://github.com/openai/codex/releases

    Equivalent certutil command (built-in on all Windows versions):
      certutil -hashfile "<FilePath>" SHA256

.PARAMETER FilePath
    The full path to the installer file to check.

.EXAMPLE
    .\check_codex_installer.ps1 -FilePath "$env:USERPROFILE\Downloads\codex-windows-x64.msi"

.EXAMPLE
    # Pipe result to clip to copy the hash to the clipboard
    .\check_codex_installer.ps1 -FilePath C:\Installers\codex-windows-x64.msi | clip

.NOTES
    Exit codes:
      0  – File found, hash computed and printed successfully.
      1  – File not found or hash computation failed.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $FilePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Expand any environment variables or relative paths
$FilePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($FilePath)

if (-not (Test-Path -LiteralPath $FilePath -PathType Leaf)) {
    Write-Host "[ERROR] File not found: $FilePath" -ForegroundColor Red
    exit 1
}

Write-Host "[INFO]  File : $FilePath" -ForegroundColor Cyan

$fileInfo = Get-Item -LiteralPath $FilePath
Write-Host "[INFO]  Size : $($fileInfo.Length) bytes  ($([math]::Round($fileInfo.Length / 1MB, 2)) MB)" -ForegroundColor Cyan

try {
    $hashResult = Get-FileHash -LiteralPath $FilePath -Algorithm SHA256
}
catch {
    Write-Host "[ERROR] Failed to compute SHA-256: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "[OK]    SHA-256: $($hashResult.Hash)" -ForegroundColor Green
Write-Host ""
Write-Host "Compare the hash above with the value on the GitHub Releases page:" -ForegroundColor DarkCyan
Write-Host "  https://github.com/openai/codex/releases" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "Or using certutil (built-in):" -ForegroundColor DarkCyan
Write-Host "  certutil -hashfile `"$FilePath`" SHA256" -ForegroundColor DarkCyan

# Output the hash as the script's return value so it can be captured by callers
return $hashResult.Hash
