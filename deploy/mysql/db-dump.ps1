<#
  Дамп базы fm на сервере для разбора у себя. Запускать на сервере:
      powershell -ExecutionPolicy Bypass -File db-dump.ps1
      powershell -ExecutionPolicy Bypass -File db-dump.ps1 -Zip
      powershell -ExecutionPolicy Bypass -File db-dump.ps1 -Tail "lv_dairies=5000,lv_docs=1000" -NoData "user_logs,tg_log" -Zip

  Что делает:
    1. Основной дамп без больших таблиц и без журналов — без блокировки таблиц,
       клиника продолжает работать (--single-transaction).
    2. Структура больших таблиц и журналов, чтобы у себя не падали страницы.
    3. Большие таблицы: только последние строки (-Tail, таблица = число строк):
       lv_dairies 1000, amb_results 1000, f999 1000, lv_docs 400.
    4. Журналы без данных (-NoData): протокол входа user_logs.
    Всё складывается в один файл на рабочем столе: fm.sql (с -Zip ещё и fm.sql.gz для копирования).

  Логин и пароль берутся из db.cnf рядом со скриптом (пример: db.example.cnf), в командной строке их нет.
#>
param(
  [string]$Database = 'fm',
  [string]$OutFile = (Join-Path ([Environment]::GetFolderPath('Desktop')) 'fm.sql'),
  # большая таблица = сколько последних строк взять (0 — только структура)
  [string]$Tail = 'lv_dairies=1000,amb_results=1000,f999=1000,lv_docs=400',
  # таблицы только структурой, без данных
  [string]$NoData = 'user_logs',
  [string]$Cnf = (Join-Path $PSScriptRoot 'db.cnf'),
  [string]$MysqlBin = '',
  [switch]$Zip
)

$ErrorActionPreference = 'Stop'
function Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }

# ---------- mysqldump ----------
$dump = $null
if ($MysqlBin) { $dump = Join-Path $MysqlBin 'mysqldump.exe' }
elseif (Get-Command mysqldump -ErrorAction SilentlyContinue) { $dump = (Get-Command mysqldump).Source }
else {
  foreach ($d in @('C:\Program Files (x86)\MySQL\MySQL Server 5.0\bin', 'C:\Program Files\MySQL\MySQL Server 5.0\bin')) {
    if (Test-Path (Join-Path $d 'mysqldump.exe')) { $dump = Join-Path $d 'mysqldump.exe'; break }
  }
}
if (-not $dump -or -not (Test-Path $dump)) { throw 'Не найден mysqldump.exe. Укажите папку: -MysqlBin "C:\...\MySQL Server 5.0\bin"' }
if (-not (Test-Path $Cnf)) { throw "Нет файла с паролем: $Cnf. Скопируйте db.example.cnf в db.cnf и впишите логин и пароль." }

# --defaults-extra-file должен быть первым параметром
$base = @("--defaults-extra-file=$Cnf", '--single-transaction', '--quick', '--skip-lock-tables', '--hex-blob', '--default-character-set=utf8')
$tmp = Join-Path $env:TEMP ('fmdump_' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp | Out-Null
$sw = [Diagnostics.Stopwatch]::StartNew()

function Run-Dump([string[]]$extra, [string]$file) {
  & $dump @base @extra "--result-file=$file"
  if ($LASTEXITCODE -ne 0) { throw "mysqldump завершился с ошибкой ($LASTEXITCODE)" }
}

# строки параметров: "таблица=строк,..." и "таблица,..." (так их можно передать и через -File)
# -Tail дополняет значения по умолчанию: указанные таблицы меняются, остальные большие таблицы всё равно не идут целиком
$TailMap = [ordered]@{ lv_dairies = 1000; amb_results = 1000; f999 = 1000; lv_docs = 400 }
foreach ($pair in ($Tail -split ',')) { $kv = $pair.Trim() -split '='; if ($kv[0]) { $TailMap[$kv[0].Trim()] = [int]($kv[1]) } }
$NoDataList = @($NoData -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
foreach ($t in @($TailMap.Keys) + $NoDataList) { if ($t -notmatch '^[A-Za-z0-9_]+$') { throw "Недопустимое имя таблицы: $t" } }
$BigTables = @(@($TailMap.Keys) + $NoDataList | Select-Object -Unique)
try {
  $parts = @()
  Step "Основной дамп $Database (без: $($BigTables -join ', '))"
  $ignore = $BigTables | ForEach-Object { "--ignore-table=$Database.$_" }
  $f = Join-Path $tmp '1_main.sql'
  Run-Dump (@('--routines') + $ignore + @($Database)) $f
  $parts += $f

  if ($BigTables.Count -gt 0) {
    Step "Структура: $($BigTables -join ', ')"
    $f = Join-Path $tmp '2_struct.sql'
    Run-Dump (@('--no-data', $Database) + $BigTables) $f
    $parts += $f

    $i = 0
    foreach ($t in @($TailMap.Keys)) {
      $rows = [int]$TailMap[$t]
      if ($rows -le 0 -or $NoDataList -contains $t) { continue }
      $i++
      Step "Последние $rows строк: $t"
      $f = Join-Path $tmp ("3_tail_{0}.sql" -f $i)
      Run-Dump @('--no-create-info', "--where=Id > (Select ifnull(Max(Id), 0) - $rows From $t)", $Database, $t) $f
      $parts += $f
    }
  }

  Step "Сборка в один файл: $OutFile"
  $out = [IO.File]::Create($OutFile)
  try {
    foreach ($p in $parts) {
      $in = [IO.File]::OpenRead($p)
      try { $in.CopyTo($out) } finally { $in.Dispose() }
    }
  } finally { $out.Dispose() }
  $size = (Get-Item $OutFile).Length / 1MB

  if ($Zip) {
    Step "Сжатие: $OutFile.gz"
    $in = [IO.File]::OpenRead($OutFile)
    $gz = New-Object IO.Compression.GZipStream ([IO.File]::Create("$OutFile.gz")), ([IO.Compression.CompressionMode]::Compress)
    try { $in.CopyTo($gz) } finally { $gz.Dispose(); $in.Dispose() }
    Write-Host ("    сжатый файл: {0:N0} МБ" -f ((Get-Item "$OutFile.gz").Length / 1MB))
  }
  Write-Host ("Готово за {0:N0} с: {1} ({2:N0} МБ)" -f $sw.Elapsed.TotalSeconds, $OutFile, $size) -ForegroundColor Green
} finally {
  Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}
