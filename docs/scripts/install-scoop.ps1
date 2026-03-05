# Scoop 自动安装脚本
# 适用于天宏紧固件 ERP 环境
# 替代微软官方 winget，使用社区维护的开源包管理器 Scoop
#
# GitHub: https://github.com/ScoopInstaller/Scoop
# 许可证: MIT License
#
# 使用方法:
#   PowerShell 执行: .\install-scoop.ps1
#   或指定安装目录: .\install-scoop.ps1 -ScoopDir "D:\Scoop"

param(
    [string]$ScoopDir = "$env:USERPROFILE\scoop",
    [switch]$NoExtras,
    [switch]$UseGitee
)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Scoop 包管理器 - 非微软版 winget 替代方案" -ForegroundColor Cyan
Write-Host "  GitHub: https://github.com/ScoopInstaller/Scoop" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 PowerShell 版本
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Error "需要 PowerShell 5.1 或更高版本。当前版本: $($PSVersionTable.PSVersion)"
    exit 1
}

# 检查是否已安装 Scoop
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "[INFO] Scoop 已安装，正在更新..." -ForegroundColor Green
    scoop update
    Write-Host "[DONE] Scoop 更新完成。" -ForegroundColor Green
    exit 0
}

# 设置安装目录
if ($ScoopDir -ne "$env:USERPROFILE\scoop") {
    Write-Host "[INFO] 将 Scoop 安装到自定义目录: $ScoopDir" -ForegroundColor Yellow
    $env:SCOOP = $ScoopDir
    [Environment]::SetEnvironmentVariable('SCOOP', $ScoopDir, 'User')
}

# 设置执行策略（当前用户）
Write-Host "[INFO] 设置 PowerShell 执行策略..." -ForegroundColor Yellow
try {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "[OK]   执行策略设置成功。" -ForegroundColor Green
} catch {
    Write-Warning "无法设置执行策略，可能需要管理员权限: $_"
}

# 安装 Scoop
Write-Host ""
Write-Host "[INFO] 开始安装 Scoop..." -ForegroundColor Yellow

if ($UseGitee) {
    # 使用 Gitee 镜像（国内网络推荐）
    Write-Host "[INFO] 使用 Gitee 镜像加速..." -ForegroundColor Yellow
    $installUrl = "https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1"
} else {
    # 使用官方源
    $installUrl = "https://get.scoop.sh"
}

try {
    Invoke-RestMethod -Uri $installUrl | Invoke-Expression
    Write-Host ""
    Write-Host "[OK]   Scoop 安装成功！" -ForegroundColor Green
} catch {
    Write-Error "安装失败: $_"
    Write-Host ""
    Write-Host "提示: 如果网络访问 GitHub 较慢，请使用 Gitee 镜像重试:" -ForegroundColor Yellow
    Write-Host "  .\install-scoop.ps1 -UseGitee" -ForegroundColor Yellow
    exit 1
}

# 添加 extras bucket（可选，包含更多软件）
if (-not $NoExtras) {
    Write-Host ""
    Write-Host "[INFO] 添加 extras 软件仓库（包含 VSCode、DBeaver 等工具）..." -ForegroundColor Yellow
    try {
        scoop bucket add extras
        Write-Host "[OK]   extras bucket 添加成功。" -ForegroundColor Green
    } catch {
        Write-Warning "添加 extras bucket 失败（可稍后手动执行 'scoop bucket add extras'）: $_"
    }
}

# 显示安装摘要
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  安装完成！" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "常用命令:" -ForegroundColor White
Write-Host "  scoop search <软件名>     # 搜索软件" -ForegroundColor Gray
Write-Host "  scoop install <软件名>    # 安装软件" -ForegroundColor Gray
Write-Host "  scoop update *            # 更新所有软件" -ForegroundColor Gray
Write-Host "  scoop list                # 查看已安装软件" -ForegroundColor Gray
Write-Host "  scoop uninstall <软件名>  # 卸载软件" -ForegroundColor Gray
Write-Host ""
Write-Host "ERP 环境推荐安装:" -ForegroundColor White
Write-Host "  scoop install git nodejs python 7zip curl" -ForegroundColor Gray
Write-Host ""
Write-Host "更多文档请参考: docs/package-manager-guide.md" -ForegroundColor Yellow
Write-Host ""
