#!/bin/bash

# 🚀 Quick Android SDK Setup for Flutter
# This script installs Android SDK on Arch Linux

echo "🔧 Installing Android SDK for Flutter..."
echo ""

# Check if running on Arch Linux
if ! command -v pacman &> /dev/null; then
    echo "❌ This script is for Arch Linux only"
    exit 1
fi

# Install Android SDK
echo "📦 Installing Android SDK packages..."
yay -S --noconfirm android-sdk android-sdk-platform-tools android-sdk-build-tools

# Set environment variables
echo ""
echo "🔧 Setting up environment variables..."

# Check if already in .zshrc
if ! grep -q "ANDROID_HOME" ~/.zshrc; then
    echo "" >> ~/.zshrc
    echo "# Android SDK" >> ~/.zshrc
    echo "export ANDROID_HOME=/opt/android-sdk" >> ~/.zshrc
    echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools" >> ~/.zshrc
    echo "✅ Added ANDROID_HOME to ~/.zshrc"
else
    echo "ℹ️  ANDROID_HOME already in ~/.zshrc"
fi

# Load environment variables
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Accept licenses
echo ""
echo "📜 Accepting Android SDK licenses..."
yes | sdkmanager --licenses 2>/dev/null

# Verify installation
echo ""
echo "✅ Verifying installation..."
flutter doctor -v

echo ""
echo "🎉 Android SDK setup complete!"
echo ""
echo "To apply changes, run:"
echo "  source ~/.zshrc"
echo ""
echo "Then build your APK with:"
echo "  cd /home/hari/Desktop/pro/bhoomi_v1"
echo "  flutter build apk --release"
