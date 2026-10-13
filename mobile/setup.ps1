<#
  Сборка приложения пациента (Android). Нужны Flutter SDK и Android SDK (см. README.md).

  Запуск из папки fm\mobile:
    powershell -ExecutionPolicy Bypass -File setup.ps1                          # адрес API по умолчанию (LAN IP этого ПК, порт 9999)
    powershell -ExecutionPolicy Bypass -File setup.ps1 -Api http://192.168.1.20:9999

  Результат: build\app\outputs\flutter-apk\app-debug.apk
#>
param(
  [string]$Api = ""
)
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) { throw 'Не найден flutter. Установите Flutter SDK и добавьте flutter\bin в PATH (README.md).' }

if (-not $Api) {
  $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254*' -and $_.PrefixOrigin -ne 'WellKnown' } | Select-Object -First 1).IPAddress
  $Api = "http://${ip}:9999"
}
Write-Host "==> Адрес API: $Api" -ForegroundColor Cyan

# android/ и ios/ создаёт сам Flutter (lib/ и pubspec.yaml не трогает)
if (-not (Test-Path 'android\app\src\main\AndroidManifest.xml')) {
  Write-Host '==> flutter create (android, ios)' -ForegroundColor Cyan
  flutter create . --project-name fms_patient --org uz.fms --platforms android,ios
  if ($LASTEXITCODE -ne 0) { throw 'flutter create завершился с ошибкой' }
  if (Test-Path 'test\widget_test.dart') { Remove-Item 'test\widget_test.dart' }
}

# Манифест: название, интернет, http по Wi-Fi для проверки (на сервере будет HTTPS), просмотр PDF/HTML в других программах
$mf = 'android\app\src\main\AndroidManifest.xml'
$x = [System.IO.File]::ReadAllText($mf)
if ($x -notmatch 'android.permission.INTERNET') {
  $x = $x -replace '(<manifest[^>]*>)', "`$1`r`n    <uses-permission android:name=`"android.permission.INTERNET`"/>"
}
$x = $x -replace 'android:label="[^"]*"', 'android:label="Farhod Madad Shifo"'
if ($x -notmatch 'usesCleartextTraffic') {
  $x = $x -replace '<application', '<application android:usesCleartextTraffic="true"'
}
if ($x -notmatch 'application/pdf') {
  $q = '<queries><intent><action android:name="android.intent.action.VIEW"/><data android:mimeType="application/pdf"/></intent>' +
       '<intent><action android:name="android.intent.action.VIEW"/><data android:mimeType="text/html"/></intent>'
  if ($x -match '<queries>') { $x = $x -replace '<queries>', $q } else { $x = $x -replace '</manifest>', "$q</queries>`r`n</manifest>" }
}
[System.IO.File]::WriteAllText($mf, $x, (New-Object System.Text.UTF8Encoding($false)))

Write-Host '==> flutter pub get' -ForegroundColor Cyan
flutter pub get
if ($LASTEXITCODE -ne 0) { throw 'flutter pub get завершился с ошибкой' }

Write-Host '==> flutter build apk --debug' -ForegroundColor Cyan
flutter build apk --debug --dart-define=API_BASE=$Api
if ($LASTEXITCODE -ne 0) { throw 'Сборка APK завершилась с ошибкой' }

$apk = Join-Path $PSScriptRoot 'build\app\outputs\flutter-apk\app-debug.apk'
Write-Host ''
Write-Host "Готово: $apk" -ForegroundColor Green
Write-Host 'Скопируйте файл на телефон и установите (разрешите установку из этого источника).'
