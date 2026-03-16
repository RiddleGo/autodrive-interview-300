# Push autodrive-interview-300 to GitHub (create repo first at https://github.com/new?name=autodrive-interview-300)
$ErrorActionPreference = "Stop"
$repo = "dreamc60/autodrive-interview-300"
$localPath = "d:\vibecoding\autodrive-interview-300"

if (-not $env:GH_TOKEN) {
    Write-Host "Please set token: `$env:GH_TOKEN = `"your_github_token`""
    exit 1
}

Push-Location $localPath
try {
    $url = "https://dreamc60:$($env:GH_TOKEN)@github.com/$repo.git"
    git remote remove origin 2>$null
    git remote add origin $url
    git push -u origin main
    if ($LASTEXITCODE -ne 0) { exit 1 }
}
finally {
    Pop-Location
}

Write-Host "Done: https://github.com/$repo"
