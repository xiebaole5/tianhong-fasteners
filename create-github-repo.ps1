# PowerShell script to create GitHub repository
# Run this script to create the tianhong-fasteners repository

$token = "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"
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
