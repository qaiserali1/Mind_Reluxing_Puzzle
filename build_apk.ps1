# PowerShell script to compile Android APK for Rake
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Building Rake: Zen Sand Garden - Android Release APK" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$flutterCmd = Get-Command flutter -ErrorAction SilentlyContinue

if (-not $flutterCmd) {
    Write-Host "[ERROR] Flutter SDK not detected in PATH." -ForegroundColor Red
    Write-Host "1. Install Flutter from https://docs.flutter.dev/get-started/install" -ForegroundColor Yellow
    Write-Host "2. Or push to GitHub to trigger automatic APK build via .github/workflows/build_apk.yml" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n[1/3] Running flutter clean..." -ForegroundColor Green
flutter clean

Write-Host "`n[2/3] Fetching dependencies..." -ForegroundColor Green
flutter pub get

Write-Host "`n[3/3] Compiling Release APK..." -ForegroundColor Green
flutter build apk --release --build-number=1

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n============================================================" -ForegroundColor Green
    Write-Host "APK Built Successfully!" -ForegroundColor Green
    Write-Host "File Location: build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor White
    Write-Host "============================================================" -ForegroundColor Green
}
else {
    Write-Host "`n[ERROR] Build failed with exit code $LASTEXITCODE" -ForegroundColor Red
}

