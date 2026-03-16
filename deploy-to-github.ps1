# Push autodrive-interview-300 to GitHub（仓库已创建：RiddleGo/autodrive-interview-300）
# 在项目目录执行：$env:GH_TOKEN = "你的 token"; .\deploy-to-github.ps1
$ErrorActionPreference = "Stop"
$repo = "RiddleGo/autodrive-interview-300"
$localPath = "d:\vibecoding\autodrive-interview-300"

if (-not $env:GH_TOKEN) {
    Write-Host "请先设置 token: `$env:GH_TOKEN = `"你的token`""
    exit 1
}

Push-Location $localPath
try {
    $url = "https://RiddleGo:$($env:GH_TOKEN)@github.com/$repo.git"
    git remote remove origin 2>$null
    git remote add origin $url
    git push -u origin main
    if ($LASTEXITCODE -ne 0) { exit 1 }
}
finally {
    Pop-Location
}

Write-Host "Done: https://github.com/$repo"
