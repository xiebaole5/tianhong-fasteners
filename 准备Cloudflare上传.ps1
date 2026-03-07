# 准备用于 Cloudflare Pages 直接上传的文件夹
# 运行后会在当前目录生成 site-for-cloudflare 文件夹，可打包为 ZIP 或直接拖拽上传

$outDir = "site-for-cloudflare"
if (Test-Path $outDir) { Remove-Item $outDir -Recurse -Force }
New-Item -ItemType Directory -Path $outDir | Out-Null

Copy-Item "index.html" $outDir
Copy-Item "products.html" $outDir
Copy-Item "data" $outDir -Recurse
Copy-Item "images" $outDir -Recurse

Write-Host "已生成文件夹: $outDir"
Write-Host "请将该文件夹打包为 ZIP，或直接拖拽到 Cloudflare Pages 的 Direct Upload 页面上传。"
Write-Host "路径: $((Get-Location).Path)\$outDir"
