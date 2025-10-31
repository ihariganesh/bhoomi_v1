# 🚀 Bhoomi App - Complete Setup Guide

## 📋 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Installation Steps](#installation-steps)
3. [Running the App](#running-the-app)
4. [Configuration Options](#configuration-options)
5. [Building for Production](#building-for-production)
6. [Troubleshooting](#troubleshooting)

---

## ✅ Prerequisites

### 1. Install Flutter SDK

**Linux:**
```bash
# Download Flutter
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz
tar xf flutter_linux_3.24.0-stable.tar.xz

# Add to PATH (add this to your ~/.bashrc or ~/.zshrc)
export PATH="$PATH:$HOME/flutter/bin"

# Reload shell configuration
source ~/.bashrc  # or source ~/.zshrc

# Verify installation
flutter doctor
```

**macOS:**
```bash
# Using Homebrew
brew install flutter

# Or download manually from https://flutter.dev/docs/get-started/install/macos
```

**Windows:**
1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
2. Extract to `C:\flutter`
3. Add `C:\flutter\bin` to your PATH
4. Run `flutter doctor` in Command Prompt

### 2. Install Required Tools

**Android Studio** (for Android development):
- Download from https://developer.android.com/studio
- Install Android SDK
- Install Android Emulator (optional, for testing)

**Xcode** (macOS only, for iOS development):
```bash
xcode-select --install
sudo xcodebuild -license accept
```

**Visual Studio Code** (recommended IDE):
```bash
# Install Flutter and Dart extensions
code --install-extension dart-code.flutter
code --install-extension dart-code.dart-code
```

---

## 📥 Installation Steps

### Step 1: Clone the Repository
```bash
cd ~/Desktop/pro
git clone https://github.com/ihariganesh/bhoomi_v1
cd bhoomi_v1
```

### Step 2: Check Flutter Environment
```bash
flutter doctor -v
```

Fix any issues reported by `flutter doctor` before proceeding.

### Step 3: Install Dependencies
```bash
# Get all Flutter packages
flutter pub get

# Generate localization files
flutter gen-l10n
```

### Step 4: Configure the App

**Option A: Offline/Development Mode (Default - No Firebase Required)**

The app is already configured to run in offline mode by default. No additional setup needed!

**Option B: Enable Firebase Authentication (Optional)**

If you want to use Google Sign-In and Firebase features:

1. Open `lib/main.dart`
2. Change this line:
   ```dart
   const bool kOfflineMode = true;  // Change to false
   ```

3. Set up Firebase:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or use existing
   - Add Android/iOS app to your Firebase project
   - Download and configure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update `lib/firebase_options.dart` with your credentials

---

## ▶️ Running the App

### Run on Connected Device
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in debug mode (hot reload enabled)
flutter run

# Run in release mode (optimized)
flutter run --release
```

### Run on Emulator/Simulator

**Android Emulator:**
```bash
# List available emulators
flutter emulators

# Start an emulator
flutter emulators --launch <emulator-id>

# Run app
flutter run
```

**iOS Simulator (macOS only):**
```bash
open -a Simulator
flutter run
```

### Run on Desktop

**Linux:**
```bash
flutter run -d linux
```

**macOS:**
```bash
flutter run -d macos
```

**Windows:**
```bash
flutter run -d windows
```

### Run on Web
```bash
flutter run -d chrome
# or
flutter run -d web-server
```

---

## ⚙️ Configuration Options

### 1. Offline Mode (Development)
In `lib/main.dart`:
```dart
const bool kOfflineMode = true;  // No Firebase, works offline
```

**Features Available:**
- ✅ Carbon Calculator (all 3 tabs)
- ✅ Eco-Score tracking
- ✅ Knowledge Hub (Gyan Kendra)
- ✅ Community Events & Heroes
- ✅ Profile Management
- ✅ Local data persistence
- ✅ Multi-language support (English, Hindi, Tamil)

**Limitations:**
- ❌ No Google Sign-In
- ❌ No cloud sync
- ❌ Data stored locally only

### 2. Firebase Mode (Production)
In `lib/main.dart`:
```dart
const bool kOfflineMode = false;  // Enable Firebase
```

**Additional Features:**
- ✅ Google Sign-In authentication
- ✅ User profile sync (when implemented)
- ✅ Cloud data backup (when implemented)

### 3. Language Selection
Users can switch between English, Hindi, and Tamil from the app drawer menu.

---

## 📦 Building for Production

### Android APK
```bash
# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build split APKs per ABI (smaller file size)
flutter build apk --split-per-abi

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (macOS only)
```bash
# Ensure code signing is configured in Xcode
flutter build ios --release

# Or build with Xcode
open ios/Runner.xcworkspace
# Then: Product -> Archive in Xcode
```

### Linux Desktop
```bash
flutter build linux --release

# Output: build/linux/x64/release/bundle/
```

### Web
```bash
flutter build web --release

# Output: build/web/
```

---

## 🐛 Troubleshooting

### Issue: `flutter: command not found`
**Solution:**
```bash
# Add Flutter to PATH
export PATH="$PATH:$HOME/flutter/bin"
source ~/.bashrc  # or ~/.zshrc
```

### Issue: `No devices found`
**Solution:**
```bash
# Check connected devices
adb devices

# Restart adb server
adb kill-server
adb start-server

# For emulator
flutter emulators --launch <emulator-name>
```

### Issue: Firebase initialization error
**Solution:**
- Set `kOfflineMode = true` in `lib/main.dart` to bypass Firebase
- Or properly configure Firebase credentials in `lib/firebase_options.dart`

### Issue: Build fails with dependency errors
**Solution:**
```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter run
```

### Issue: Gradle build fails (Android)
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: App crashes on startup
**Solution:**
1. Check logs: `flutter logs`
2. Ensure all dependencies are installed: `flutter pub get`
3. Try offline mode: Set `kOfflineMode = true`
4. Clear app data and reinstall

### Issue: Localization not working
**Solution:**
```bash
# Regenerate localization files
flutter gen-l10n

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

---

## 📱 Testing on Physical Device

### Android Device
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter run`

### iOS Device (macOS only)
1. Connect iPhone/iPad via USB
2. Trust the computer on device
3. Open Xcode and configure signing
4. Run: `flutter run`

---

## 🎨 Customization

### Change App Name
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application android:label="Your App Name">
```

Edit `ios/Runner/Info.plist`:
```xml
<key>CFBundleName</key>
<string>Your App Name</string>
```

### Change App Icon
```bash
# Install package
flutter pub add flutter_launcher_icons

# Configure in pubspec.yaml and run
flutter pub run flutter_launcher_icons
```

### Change Package Name
Use the `change_app_package_name` package or manually update:
- `android/app/build.gradle`
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner.xcodeproj`

---

## 📊 App Features

### ✅ Fully Implemented
- Carbon footprint calculator (Transportation, Food, Energy)
- Eco-score calculation and leveling system
- Knowledge hub with bilingual content
- Community events and eco-heroes showcase
- Profile management
- Streak tracking
- Multi-language support
- Local data persistence
- Beautiful glassmorphism UI

### 🔄 Ready for Extension
- Social sharing
- Push notifications
- More educational content
- Backend API integration
- Advanced analytics

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -am 'Add feature'`
4. Push to branch: `git push origin feature-name`
5. Submit a Pull Request

---

## 📄 License

This project is open source and available under the MIT License.

---

## 🆘 Support

- 📧 Email: support@bhoomi-app.com
- 🐛 Issues: https://github.com/ihariganesh/bhoomi_v1/issues
- 💬 Discussions: https://github.com/ihariganesh/bhoomi_v1/discussions

---

## 🎉 Success Checklist

- [ ] Flutter SDK installed and `flutter doctor` passes
- [ ] Dependencies installed with `flutter pub get`
- [ ] App runs successfully with `flutter run`
- [ ] Can navigate between all screens
- [ ] Calculator saves data and updates eco-score
- [ ] Language switching works
- [ ] Profile can be edited and saved

**Congratulations! Your Bhoomi app is ready to use! 🌱**
