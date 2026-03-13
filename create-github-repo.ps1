# PowerShell script to create GitHub repository
# Run this script to create the tianhong-fasteners repository
# Usage: Set the GITHUB_TOKEN environment variable before running:
#   $env:GITHUB_TOKEN = "your_personal_access_token"

$token = $env:GITHUB_TOKEN
if (-not $token) {
    Write-Error "GITHUB_TOKEN environment variable is not set. Please set it before running this script."
    exit 1
}
$headers = @{
    "Authorization" = "token $token"
    "Accept" = "application/vnd.github.v3+json"
}

$body = @{
    "name" = "tianhong-fasteners"
    "description" = "浙江天宏紧固件有限公司 - 外贸独立站 | Tianhong Fasteners Co., Ltd. - International Trade Website"
    "homepage" = "https://tianhong-fasteners.pages.dev"
    "private" = $false
    "has_issues" = $true
    "has_projects" = $true
    "has_wiki" = $false
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body
