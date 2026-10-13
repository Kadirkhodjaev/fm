<#
  Развёртывание собранного архива на Windows-сервер клиента с Tomcat.

  Что делает:
    1. (по желанию -Build) собирает проект через build.ps1
    2. копирует архив на сервер (PowerShell Remoting / WinRM) или работает локально (-Local)
    3. распаковывает новую версию рядом, останавливает службу Tomcat
    4. переносит текущую версию в резервную копию, ставит новую
    5. возвращает файлы настроек сервера (db.properties и т.п.) из старой версии
    6. очищает кэш JSP Tomcat, запускает службу и проверяет, что сайт отвечает
    7. если сайт не поднялся - автоматически возвращает предыдущую версию

  Примеры:
    # клиент из deploy\clients.psd1, со сборкой
    powershell -ExecutionPolicy Bypass -File deploy\deploy.ps1 -Client fm -Build

    # прямо на сервере (архив скопирован вручную, без WinRM)
    powershell -ExecutionPolicy Bypass -File deploy.ps1 -Local -Zip C:\deploy\fm_20261009_1916.zip `
      -AppDir "C:\Tomcat 9\webapps\ROOT" -Service Tomcat9 -Url http://localhost:8080/login.s

    # откат на предыдущую версию
    powershell -ExecutionPolicy Bypass -File deploy\deploy.ps1 -Client fm -Rollback
#>
param(
  [string]$Client = "",
  [string]$Server = "",
  [string]$AppDir = "",
  [string]$Service = "",
  [string]$Url = "",
  [string]$BackupDir = "",
  [string]$Zip = "",
  [string[]]$Preserve = @(),
  [int]$KeepBackups = 5,
  [int]$StartTimeoutSec = 180,
  [switch]$Build,
  [switch]$Local,
  [switch]$Rollback,
  [System.Management.Automation.PSCredential]$Credential = $null
)

$ErrorActionPreference = 'Stop'
function Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }

# ---------- Параметры клиента ----------
if ($Client) {
  $cfgFile = Join-Path $PSScriptRoot 'clients.psd1'
  if (-not (Test-Path $cfgFile)) { throw "Нет файла $cfgFile (скопируйте clients.example.psd1 в clients.psd1 и заполните)" }
  $all = Import-PowerShellDataFile $cfgFile
  if (-not $all.ContainsKey($Client)) { throw "Клиент '$Client' не найден в clients.psd1. Есть: $($all.Keys -join ', ')" }
  $c = $all[$Client]
  if (-not $Server -and $c.Server) { $Server = $c.Server }
  if (-not $AppDir) { $AppDir = $c.AppDir }
  if (-not $Service) { $Service = $c.Service }
  if (-not $Url) { $Url = $c.Url }
  if (-not $BackupDir -and $c.BackupDir) { $BackupDir = $c.BackupDir }
  if (-not $Preserve.Count -and $c.Preserve) { $Preserve = $c.Preserve }
  if ($c.Local) { $Local = $true }
}
if (-not $Preserve.Count) { $Preserve = @('WEB-INF\classes\db.properties', 'WEB-INF\classes\telegram.properties') }
if (-not $AppDir -or -not $Service) { throw 'Укажите -Client или -AppDir и -Service' }
if (-not $Local -and -not $Server) { throw 'Укажите -Server (или -Local, если скрипт запущен на самом сервере)' }

# ---------- Часть, которая выполняется на сервере ----------
$serverPart = {
  param($zip, $appDir, $service, $url, $backupDir, $preserve, $keep, $timeout, $rollback)
  $ErrorActionPreference = 'Stop'
  function Say($m) { Write-Host "    [$env:COMPUTERNAME] $m" }

  $appDir = $appDir.TrimEnd('\')
  $appName = Split-Path $appDir -Leaf
  $webapps = Split-Path $appDir
  $tomcat = Split-Path $webapps
  # резервные копии - вне webapps, иначе Tomcat развернёт их как отдельные сайты
  if (-not $backupDir) { $backupDir = Join-Path $tomcat 'deploy_backups' }
  New-Item -ItemType Directory -Force $backupDir | Out-Null
  $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
  $log = Join-Path $backupDir 'deploy.log'
  function Log($m) { Add-Content -Path $log -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $m" -Encoding UTF8 }

  function StopTomcat {
    $s = Get-Service $service
    if ($s.Status -ne 'Stopped') {
      Say "Остановка службы $service"
      Stop-Service $service -Force
      $s.WaitForStatus('Stopped', [TimeSpan]::FromSeconds(90))
    }
    Start-Sleep -Seconds 2   # Tomcat отпускает файлы не сразу
  }
  function StartTomcat {
    $work = Join-Path $tomcat "work\Catalina\localhost\$appName"
    if (Test-Path $work) { Remove-Item $work -Recurse -Force }   # кэш скомпилированных JSP
    Say "Запуск службы $service"
    Start-Service $service
  }
  function WaitSite {
    if (-not $url) { Start-Sleep -Seconds 15; return $true }
    Say "Проверка $url (до $timeout сек.)"
    $until = (Get-Date).AddSeconds($timeout)
    while ((Get-Date) -lt $until) {
      Start-Sleep -Seconds 5
      try {
        $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 20
        if ($r.StatusCode -lt 400) { return $true }
      } catch { }
    }
    return $false
  }
  function MoveDir($from, $to) {
    for ($i = 0; $i -lt 10; $i++) {
      try { Move-Item $from $to -Force; return } catch { Start-Sleep -Seconds 3 }
    }
    Move-Item $from $to -Force
  }

  # ---------- Откат вручную ----------
  if ($rollback) {
    $last = Get-ChildItem $backupDir -Directory -Filter 'app_*' | Sort-Object Name -Descending | Select-Object -First 1
    if (-not $last) { throw "В $backupDir нет резервных копий" }
    Say "Откат на $($last.Name)"
    StopTomcat
    if (Test-Path $appDir) { MoveDir $appDir (Join-Path $backupDir "replaced_$stamp") }
    MoveDir $last.FullName $appDir
    StartTomcat
    $ok = WaitSite
    Log "ROLLBACK to $($last.Name): $(if ($ok) {'OK'} else {'SITE NOT RESPONDING'})"
    if (-not $ok) { throw 'После отката сайт не отвечает, проверьте логи Tomcat' }
    Say 'Откат выполнен'
    return
  }

  # ---------- Распаковка новой версии рядом с резервными копиями (тот же диск) ----------
  $new = Join-Path $backupDir "new_$stamp"
  Say "Распаковка $(Split-Path $zip -Leaf)"
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $new)

  # ---------- Замена ----------
  StopTomcat
  $bak = Join-Path $backupDir "app_$stamp"
  $hadOld = Test-Path $appDir
  if ($hadOld) {
    Say "Резервная копия текущей версии: $bak"
    MoveDir $appDir $bak
  }
  MoveDir $new $appDir

  # файлы настроек этого сервера остаются прежними
  if ($hadOld) {
    foreach ($p in $preserve) {
      $src = Join-Path $bak $p
      if (Test-Path $src) {
        Copy-Item $src (Join-Path $appDir $p) -Force
        Say "Сохранена настройка сервера: $p"
      }
    }
  }

  StartTomcat
  $ok = WaitSite
  $ver = ''
  $vf = Join-Path $appDir 'WEB-INF\version.txt'
  if (Test-Path $vf) { $ver = (Get-Content $vf -Encoding UTF8) -join '; ' }

  if (-not $ok) {
    Say 'Сайт не отвечает - возвращаю предыдущую версию'
    StopTomcat
    MoveDir $appDir (Join-Path $backupDir "failed_$stamp")
    if ($hadOld) { MoveDir $bak $appDir }
    StartTomcat
    $back = WaitSite
    Log "DEPLOY FAILED ($ver), rollback: $(if ($back) {'OK'} else {'SITE NOT RESPONDING'})"
    throw "Новая версия не запустилась, восстановлена предыдущая. Неудачная версия: $backupDir\failed_$stamp. Смотрите логи в $tomcat\logs"
  }

  # ---------- Чистка старых копий ----------
  Get-ChildItem $backupDir -Directory -Filter 'app_*' | Sort-Object Name -Descending | Select-Object -Skip $keep |
    ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
  Get-ChildItem $backupDir -File -Filter 'fm_*.zip' | Sort-Object Name -Descending | Select-Object -Skip $keep |
    ForEach-Object { Remove-Item $_.FullName -Force }

  Log "DEPLOY OK ($ver)"
  Say "Готово: $ver"
}

# ---------- Сборка / выбор архива ----------
if (-not $Rollback) {
  if ($Build) {
    Step 'Сборка'
    $Zip = (& (Join-Path $PSScriptRoot 'build.ps1') | Select-Object -Last 1)
  }
  if (-not $Zip) {
    $latest = Get-ChildItem (Join-Path (Split-Path -Parent $PSScriptRoot) 'build') -Filter 'fm_*.zip' -ErrorAction SilentlyContinue |
      Sort-Object Name -Descending | Select-Object -First 1
    if (-not $latest) { throw 'Нет архива: запустите с -Build или укажите -Zip' }
    $Zip = $latest.FullName
  }
  $Zip = (Resolve-Path $Zip).Path
  Step "Архив: $Zip"
}

$target = if ($Local) { $env:COMPUTERNAME } else { $Server }
Step "Сервер: $target, приложение: $AppDir, служба: $Service"

if ($Local) {
  & $serverPart $Zip $AppDir $Service $Url $BackupDir $Preserve $KeepBackups $StartTimeoutSec $Rollback.IsPresent
} else {
  $so = New-PSSessionOption -OpenTimeout 30000
  $sess = if ($Credential) { New-PSSession -ComputerName $Server -Credential $Credential -SessionOption $so }
          else { New-PSSession -ComputerName $Server -SessionOption $so }
  try {
    $remoteZip = ''
    if (-not $Rollback) {
      # архив кладём рядом с резервными копиями на сервере
      $remoteDir = Invoke-Command -Session $sess -ArgumentList $AppDir, $BackupDir -ScriptBlock {
        param($a, $b)
        if (-not $b) { $b = Join-Path (Split-Path (Split-Path $a.TrimEnd('\'))) 'deploy_backups' }
        New-Item -ItemType Directory -Force $b | Out-Null
        $b
      }
      $remoteZip = Join-Path $remoteDir (Split-Path $Zip -Leaf)
      Step "Копирование архива на сервер ($([math]::Round((Get-Item $Zip).Length / 1MB, 1)) МБ)"
      Copy-Item $Zip -Destination $remoteZip -ToSession $sess -Force
    }
    Invoke-Command -Session $sess -ScriptBlock $serverPart -ArgumentList $remoteZip, $AppDir, $Service, $Url, $BackupDir, $Preserve, $KeepBackups, $StartTimeoutSec, $Rollback.IsPresent
  } finally {
    Remove-PSSession $sess
  }
}
Write-Host ''
Write-Host 'Развёртывание завершено' -ForegroundColor Green
