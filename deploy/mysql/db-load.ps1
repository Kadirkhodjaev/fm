<#
  Загрузка дампа (fm.sql или fm.sql.gz от db-dump.ps1) в локальную базу. Запускать у себя:
      powershell -ExecutionPolicy Bypass -File db-load.ps1
      powershell -ExecutionPolicy Bypass -File db-load.ps1 -File D:\dumps\fm.sql.gz -Database fm_prod

  База пересоздаётся (DROP + CREATE), поэтому по умолчанию грузится в fm. Перед удалением спрашивает подтверждение
  (-Force — без вопроса). На время загрузки отключаются проверки внешних ключей и уникальности,
  всё идёт одной транзакцией — в несколько раз быстрее обычного mysql < fm.sql.

  После загрузки выполняется after-load.sql (пароли "1", IS_DEBUG = Y, логин admin у пользователя 1).
  Пропустить: -NoAfter.

  Логин и пароль берутся из db.cnf рядом со скриптом (пример: db.example.cnf).
#>
param(
  [string]$File = (Join-Path ([Environment]::GetFolderPath('Desktop')) 'fm.sql'),
  [string]$Database = 'fm',
  [string]$Cnf = (Join-Path $PSScriptRoot 'db.cnf'),
  [string]$MysqlBin = '',
  [string]$After = (Join-Path $PSScriptRoot 'after-load.sql'),
  [switch]$NoAfter,
  [switch]$Force
)

$ErrorActionPreference = 'Stop'
function Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }

$mysql = $null
if ($MysqlBin) { $mysql = Join-Path $MysqlBin 'mysql.exe' }
elseif (Get-Command mysql -ErrorAction SilentlyContinue) { $mysql = (Get-Command mysql).Source }
else {
  foreach ($d in @('C:\Program Files (x86)\MySQL\MySQL Server 5.0\bin', 'C:\Program Files\MySQL\MySQL Server 5.0\bin')) {
    if (Test-Path (Join-Path $d 'mysql.exe')) { $mysql = Join-Path $d 'mysql.exe'; break }
  }
}
if (-not $mysql -or -not (Test-Path $mysql)) { throw 'Не найден mysql.exe. Укажите папку: -MysqlBin "C:\...\MySQL Server 5.0\bin"' }
if (-not (Test-Path $Cnf)) { throw "Нет файла с паролем: $Cnf. Скопируйте db.example.cnf в db.cnf и впишите логин и пароль." }
if (-not (Test-Path $File) -and (Test-Path "$File.gz")) { $File = "$File.gz" }
if (-not (Test-Path $File)) { throw "Нет файла дампа: $File" }
if ($Database -notmatch '^[A-Za-z0-9_]+$') { throw "Недопустимое имя базы: $Database" }

if (-not $Force) {
  $ans = Read-Host "База '$Database' будет удалена и создана заново из $File. Продолжить? (y/n)"
  if ($ans -ne 'y') { Write-Host 'Отменено.'; exit 1 }
}

$sw = [Diagnostics.Stopwatch]::StartNew()
$tmp = $null
try {
  $sql = $File
  if ($File.EndsWith('.gz')) {
    Step 'Распаковка'
    $tmp = Join-Path $env:TEMP ('fmload_' + [guid]::NewGuid().ToString('N') + '.sql')
    $gz = New-Object IO.Compression.GZipStream ([IO.File]::OpenRead($File)), ([IO.Compression.CompressionMode]::Decompress)
    $out = [IO.File]::Create($tmp)
    try { $gz.CopyTo($out) } finally { $out.Dispose(); $gz.Dispose() }
    $sql = $tmp
  }

  Step "Пересоздание базы $Database"
  & $mysql "--defaults-extra-file=$Cnf" -e "DROP DATABASE IF EXISTS ``$Database``; CREATE DATABASE ``$Database`` DEFAULT CHARACTER SET utf8;"
  if ($LASTEXITCODE -ne 0) { throw 'Не удалось пересоздать базу' }

  Step ("Загрузка {0:N0} МБ (проверки ключей отключены на время загрузки)" -f ((Get-Item $sql).Length / 1MB))
  # source с путём через прямые слэши: mysql.exe на Windows понимает их без экранирования
  $src = $sql.Replace('\', '/')
  $cmd = "SET foreign_key_checks=0; SET unique_checks=0; SET autocommit=0; source $src; COMMIT; SET unique_checks=1; SET foreign_key_checks=1;"
  & $mysql "--defaults-extra-file=$Cnf" --default-character-set=utf8 --database=$Database -e $cmd
  if ($LASTEXITCODE -ne 0) { throw "mysql завершился с ошибкой ($LASTEXITCODE)" }

  # запросы после загрузки: локальные пароли, отладочный режим и т.п.
  if (-not $NoAfter -and (Test-Path $After)) {
    # колонки, которые приложение добавляет само (Hibernate), а в дампе со старой версии их ещё нет
    foreach ($col in @('showMenu', 'showSearch')) {
      $has = & $mysql "--defaults-extra-file=$Cnf" -N -e "Select Count(*) From information_schema.columns Where table_schema = '$Database' And table_name = 'roles' And column_name = '$col'"
      if ("$has".Trim() -eq '0') {
        Step "Добавление колонки roles.$col"
        & $mysql "--defaults-extra-file=$Cnf" --database=$Database -e "Alter Table roles Add Column $col Varchar(1) Null"
      }
    }
    Step "Запросы после загрузки: $After"
    $afterSrc = (Resolve-Path $After).Path.Replace('\', '/')
    & $mysql "--defaults-extra-file=$Cnf" --default-character-set=utf8 --database=$Database -e "source $afterSrc"
    if ($LASTEXITCODE -ne 0) { throw "Ошибка в запросах после загрузки ($LASTEXITCODE)" }
  }

  $tables = & $mysql "--defaults-extra-file=$Cnf" -N -e "Select Count(*) From information_schema.tables Where table_schema = '$Database'"
  Write-Host ("Готово за {0:N0} с: база {1}, таблиц {2}" -f $sw.Elapsed.TotalSeconds, $Database, $tables) -ForegroundColor Green
} finally {
  if ($tmp) { Remove-Item -Force $tmp -ErrorAction SilentlyContinue }
}
