@echo off
REM Bhoomi App - Quick Start Script for Windows
REM This script helps you get started with the Bhoomi app

setlocal EnableDelayedExpansion

echo.
echo ==============================
echo 🌱 Bhoomi App - Quick Start
echo ==============================
echo.

REM Check if Flutter is installed
echo Checking Flutter installation...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed or not in PATH
    echo.
    echo ℹ️  Please install Flutter from: https://flutter.dev/docs/get-started/install/windows
    echo ℹ️  Or follow the instructions in SETUP_GUIDE.md
    pause
    exit /b 1
)
echo ✅ Flutter is installed
flutter --version | findstr /C:"Flutter"

echo.
echo Running Flutter Doctor...
echo ==============================
flutter doctor
echo.

REM Check if dependencies are installed
echo ℹ️  Checking dependencies...
if not exist ".dart_tool" (
    echo ⚠️  Dependencies not installed yet
    echo ℹ️  Installing dependencies...
    flutter pub get
    echo ✅ Dependencies installed
) else (
    echo ✅ Dependencies are already installed
)

echo.
echo ℹ️  Checking for available devices...
flutter devices

echo.
echo ==============================
echo ✅ Setup verification complete!
echo ==============================
echo.

REM Ask user what they want to do
echo What would you like to do?
echo 1) Run the app in debug mode
echo 2) Run the app in release mode
echo 3) Build APK for Android
echo 4) Clean and rebuild
echo 5) Exit
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo ℹ️  Running app in debug mode...
    flutter run
) else if "%choice%"=="2" (
    echo ℹ️  Running app in release mode...
    flutter run --release
) else if "%choice%"=="3" (
    echo ℹ️  Building Android APK...
    flutter build apk --release
    echo ✅ APK built successfully!
    echo Location: build\app\outputs\flutter-apk\app-release.apk
    pause
) else if "%choice%"=="4" (
    echo ℹ️  Cleaning project...
    flutter clean
    echo ℹ️  Getting dependencies...
    flutter pub get
    echo ℹ️  Running app...
    flutter run
) else if "%choice%"=="5" (
    echo Goodbye! 👋
    exit /b 0
) else (
    echo ❌ Invalid choice
    pause
    exit /b 1
)
