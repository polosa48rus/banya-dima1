$templatePath = "template_options.html"
if (-not (Test-Path $templatePath)) {
    Write-Host "template_options.html not found!" -ForegroundColor Red
    exit
}

$newCardBlock = [System.IO.File]::ReadAllText($templatePath, [System.Text.Encoding]::UTF8)
$count = 0

# 1. Обновляем корень (index.html), если он есть
if (Test-Path "index.html") {
    $rootContent = [System.IO.File]::ReadAllText("index.html", [System.Text.Encoding]::UTF8)
    $pattern = '(?s)<div id="b1716"[^>]*>.*?<\/section>\s*<\/div>'
    if ([System.Text.RegularExpressions.Regex]::IsMatch($rootContent, $pattern)) {
        $rootContent = [System.Text.RegularExpressions.Regex]::Replace($rootContent, $pattern, $newCardBlock)
        [System.IO.File]::WriteAllText("index.html", $rootContent, [System.Text.Encoding]::UTF8)
        Write-Host "Updated root index.html" -ForegroundColor Green
        $count++
    }
}

# 2. Обновляем все страницы в каталоге
$itemDirs = Get-ChildItem -Path "katalog\item" -Directory
foreach ($dir in $itemDirs) {
    $indexPath = Join-Path $dir.FullName "index.html"
    if (Test-Path $indexPath) {
        $content = [System.IO.File]::ReadAllText($indexPath, [System.Text.Encoding]::UTF8)
        $pattern = '(?s)<div id="b1716"[^>]*>.*?<\/section>\s*<\/div>'
        
        if ([System.Text.RegularExpressions.Regex]::IsMatch($content, $pattern)) {
            $content = [System.Text.RegularExpressions.Regex]::Replace($content, $pattern, $newCardBlock)
            [System.IO.File]::WriteAllText($indexPath, $content, [System.Text.Encoding]::UTF8)
            Write-Host "Updated: $($dir.Name)" -ForegroundColor Green
            $count++
        }
    }
}

Write-Host "Done! Successfully updated pages: $count" -ForegroundColor Cyan