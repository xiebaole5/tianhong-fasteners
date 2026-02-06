@echo off
REM PowerShell script to create GitHub repository
REM Run this script to create the tianhong-fasteners repository

set token=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

echo Creating GitHub repository...
powershell -command "$token = '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'; $headers = @{'Authorization' = 'token ' + $token; 'Accept' = 'application/vnd.github.v3+json'}; $body = @{name = 'tianhong-fasteners'; description = '浙江天宏紧固件有限公司 - 外贸独立站'; private = $false} | ConvertTo-Json; Invoke-RestMethod -Uri 'https://api.github.com/user/repos' -Method Post -Headers $headers -Body $body"

echo Repository creation attempted.
pause
