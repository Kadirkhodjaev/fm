<#
  Сборка проекта без IntelliJ: компилирует src, собирает приложение (как артефакт "fmm" в out/)
  и упаковывает его в один zip для развёртывания.

  Запуск:  powershell -ExecutionPolicy Bypass -File deploy\build.ps1
           powershell -ExecutionPolicy Bypass -File deploy\build.ps1 -JavaHome D:\install\dev\binaries\jdk1.8.0_102

  Результат: build\app\              - готовое приложение (распакованный WAR)
             build\fm_<дата>.zip     - архив для deploy.ps1
#>
param(
  [string]$JavaHome = $env:JAVA_HOME,
  [string]$OutDir = ""
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
if (-not $OutDir) { $OutDir = Join-Path $root 'build' }

function Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }

# ---------- javac ----------
$javac = $null
if ($JavaHome -and (Test-Path (Join-Path $JavaHome 'bin\javac.exe'))) { $javac = Join-Path $JavaHome 'bin\javac.exe' }
elseif (Get-Command javac -ErrorAction SilentlyContinue) { $javac = (Get-Command javac).Source }
if (-not $javac) { throw 'Не найден javac. Укажите -JavaHome или переменную JAVA_HOME (нужен JDK 8 или новее).' }
$ver = (& cmd /c "`"$javac`" -version 2>&1") -join ' '
$isJdk8 = $ver -match 'javac 1\.8'
Step "Компилятор: $javac ($ver)"

# ---------- Очистка ----------
$app = Join-Path $OutDir 'app'
$srcTmp = Join-Path $OutDir 'src'
$classes = Join-Path $app 'WEB-INF\classes'
$libOut = Join-Path $app 'WEB-INF\lib'
if (Test-Path $OutDir) { Remove-Item $OutDir -Recurse -Force }
New-Item -ItemType Directory -Force $app, $srcTmp, $classes, $libOut | Out-Null

# ---------- Веб-часть ----------
Step 'Копирование web\'
Copy-Item (Join-Path $root 'web\*') $app -Recurse -Force

# ---------- Исходники: в проекте файлы и в cp1251, и в UTF-8 ----------
# javac принимает одну кодировку на запуск, поэтому все .java приводятся к UTF-8 во временной папке.
Step 'Подготовка исходников (cp1251 / UTF-8 -> UTF-8)'
$strictUtf8 = New-Object System.Text.UTF8Encoding($false, $true)
$cp1251 = [System.Text.Encoding]::GetEncoding(1251)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$srcRoot = (Resolve-Path (Join-Path $root 'src')).Path
$javaFiles = Get-ChildItem $srcRoot -Recurse -Filter *.java
$list = New-Object System.Collections.Generic.List[string]
$n1251 = 0
foreach ($f in $javaFiles) {
  $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
  try { $text = $strictUtf8.GetString($bytes) } catch { $text = $cp1251.GetString($bytes); $n1251++ }
  $text = $text.TrimStart([char]0xFEFF)
  $rel = $f.FullName.Substring($srcRoot.Length + 1)
  $dst = Join-Path $srcTmp $rel
  New-Item -ItemType Directory -Force (Split-Path $dst) | Out-Null
  [System.IO.File]::WriteAllText($dst, $text, $utf8NoBom)
  $list.Add('"' + $dst.Replace('\', '/') + '"')
}
Write-Host "    файлов: $($javaFiles.Count) (из них cp1251: $n1251)"

# ---------- Компиляция ----------
Step 'Компиляция'
$jars = Get-ChildItem (Join-Path $root 'lib') -Recurse -Filter *.jar
$cp = ($jars | ForEach-Object { $_.FullName }) -join ';'
$argFile = Join-Path $OutDir 'javac.args'
$opts = @('-encoding', 'UTF-8', '-nowarn', '-proc:none', '-g', '-d', ('"' + $classes.Replace('\', '/') + '"'), '-cp', ('"' + $cp.Replace('\', '/') + '"'))
if ($isJdk8) { $opts += @('-source', '1.8', '-target', '1.8') } else { $opts += @('--release', '8') }
[System.IO.File]::WriteAllLines($argFile, [string[]]($opts + $list), $utf8NoBom)
# javac пишет предупреждения в stderr: в PowerShell 5.1 это нельзя считать ошибкой, смотрим только код выхода
$ErrorActionPreference = 'Continue'
& cmd /c "`"$javac`" `"@$argFile`" 2>&1" | Where-Object { $_ -notmatch '^Note:|^Примечание' } | ForEach-Object { Write-Host $_ }
$code = $LASTEXITCODE
$ErrorActionPreference = 'Stop'
if ($code -ne 0) { throw "Ошибка компиляции (код $code)" }

# ---------- Ресурсы (xml, properties) как в IntelliJ ----------
Step 'Копирование ресурсов'
Get-ChildItem $srcRoot -Recurse -File | Where-Object { $_.Extension -ne '.java' } | ForEach-Object {
  $dst = Join-Path $classes $_.FullName.Substring($srcRoot.Length + 1)
  New-Item -ItemType Directory -Force (Split-Path $dst) | Out-Null
  Copy-Item $_.FullName $dst -Force
}
New-Item -ItemType Directory -Force (Join-Path $classes 'META-INF') | Out-Null
Copy-Item (Join-Path $srcRoot 'persistence.xml') (Join-Path $classes 'META-INF\persistence.xml') -Force

# ---------- Библиотеки (servlet-api есть в Tomcat, в WEB-INF\lib он не нужен) ----------
Step 'Копирование библиотек'
$jars | Where-Object { $_.Name -ne 'servlet-api.jar' } | ForEach-Object { Copy-Item $_.FullName $libOut -Force }

# ---------- Версия ----------
$commit = ''
try { $commit = (& git -C $root rev-parse --short HEAD 2>$null) } catch {}
$dirty = ''
try { if (& git -C $root status --porcelain 2>$null) { $dirty = ' (+ незакоммиченные изменения)' } } catch {}
$stamp = Get-Date -Format 'yyyyMMdd_HHmm'
$verText = "build: $(Get-Date -Format 'yyyy-MM-dd HH:mm')`r`ncommit: $commit$dirty`r`nhost: $env:COMPUTERNAME"
[System.IO.File]::WriteAllText((Join-Path $app 'WEB-INF\version.txt'), $verText, $utf8NoBom)

# ---------- Архив ----------
Step 'Упаковка'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = Join-Path $OutDir "fm_$stamp.zip"
[System.IO.Compression.ZipFile]::CreateFromDirectory($app, $zip, [System.IO.Compression.CompressionLevel]::Optimal, $false)
Remove-Item $srcTmp -Recurse -Force
Remove-Item $argFile -Force

$size = [math]::Round((Get-Item $zip).Length / 1MB, 1)
Write-Host ''
Write-Host "Готово: $zip ($size МБ)" -ForegroundColor Green
$zip
