@echo off
echo ============================================================
echo Building Rake: Zen Sand Garden - Android Release APK
echo ============================================================

where flutter >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Flutter SDK was not found in your system PATH.
    echo Please install Flutter or add its bin directory to PATH.
    echo Alternatively, use the automated GitHub Action in .github/workflows/build_apk.yml
    pause
    exit /b 1
)

echo [1/3] Cleaning previous build artifacts...
call flutter clean

echo [2/3] Fetching Flutter dependencies...
call flutter pub get

echo [3/3] Compiling Release APK...
call flutter build apk --release --build-number=1

if %ERRORLEVEL% equ 0 (
    echo ============================================================
    echo APK Build Complete!
    echo Output: build\app\outputs\flutter-apk\app-release.apk
    echo ============================================================
) else (
    echo [ERROR] APK compilation failed. Please review logs above.
)

pause

