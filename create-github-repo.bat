@echo off
REM PowerShell script to create GitHub repository
REM Run this script to create the tianhong-fasteners repository
REM Usage: Set the GITHUB_TOKEN environment variable before running this script.
REM   set GITHUB_TOKEN=your_personal_access_token

if "%GITHUB_TOKEN%"=="" (
    echo ERROR: GITHUB_TOKEN environment variable is not set.
    echo Please set it before running this script:
    echo   set GITHUB_TOKEN=your_personal_access_token
    pause
    exit /b 1
)

echo Creating GitHub repository...
powershell -command "$token = $env:GITHUB_TOKEN; $headers = @{'Authorization' = 'token ' + $token; 'Accept' = 'application/vnd.github.v3+json'}; $body = @{name = 'tianhong-fasteners'; description = '浙江天宏紧固件有限公司 - 外贸独立站'; private = $false} | ConvertTo-Json; Invoke-RestMethod -Uri 'https://api.github.com/user/repos' -Method Post -Headers $headers -Body $body"

echo Repository creation attempted.
pause
