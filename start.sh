#!/bin/bash

# Bhoomi App - Quick Start Script
# This script helps you get started with the Bhoomi app

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌱 Bhoomi App - Quick Start${NC}"
echo "================================"
echo ""

# Function to print success message
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to print error message
error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to print warning message
warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Function to print info message
info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if Flutter is installed
echo "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    error "Flutter is not installed or not in PATH"
    echo ""
    info "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    info "Or follow the instructions in SETUP_GUIDE.md"
    exit 1
else
    success "Flutter is installed"
    flutter --version | head -n 1
fi

echo ""
echo "Running Flutter Doctor..."
echo "================================"
flutter doctor
echo ""

# Check if dependencies are installed
info "Checking dependencies..."
if [ ! -d ".dart_tool" ]; then
    warning "Dependencies not installed yet"
    info "Installing dependencies..."
    flutter pub get
    success "Dependencies installed"
else
    success "Dependencies are already installed"
fi

echo ""
info "Checking for available devices..."
flutter devices

echo ""
echo "================================"
success "Setup verification complete!"
echo ""

# Ask user what they want to do
echo "What would you like to do?"
echo "1) Run the app in debug mode"
echo "2) Run the app in release mode"
echo "3) Build APK for Android"
echo "4) Clean and rebuild"
echo "5) Exit"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        info "Running app in debug mode..."
        flutter run
        ;;
    2)
        info "Running app in release mode..."
        flutter run --release
        ;;
    3)
        info "Building Android APK..."
        flutter build apk --release
        success "APK built successfully!"
        echo "Location: build/app/outputs/flutter-apk/app-release.apk"
        ;;
    4)
        info "Cleaning project..."
        flutter clean
        info "Getting dependencies..."
        flutter pub get
        info "Running app..."
        flutter run
        ;;
    5)
        echo "Goodbye! 👋"
        exit 0
        ;;
    *)
        error "Invalid choice"
        exit 1
        ;;
esac
