# 🚀 Bhoomi App - Quick Reference

## ⚡ Quick Commands

```bash
# Get the app running in 3 commands
cd /home/hari/Desktop/pro/bhoomi_v1
flutter pub get
flutter run

# Or use the quick start script
./start.sh          # Linux/Mac
start.bat           # Windows
```

---

## 📁 Key Files to Know

| File | What It Does |
|------|--------------|
| `lib/main.dart` | App entry point, offline mode setting |
| `lib/providers/app_state.dart` | Central state management |
| `lib/screens/*.dart` | All app screens |
| `pubspec.yaml` | Dependencies and assets |
| `SETUP_GUIDE.md` | Complete installation guide |
| `FEATURES.md` | All features documented |

---

## ⚙️ Quick Settings

### Enable/Disable Offline Mode
**File:** `lib/main.dart` (line 17)
```dart
const bool kOfflineMode = true;   // Offline (default)
const bool kOfflineMode = false;  // Firebase enabled
```

### Change Default Language
**File:** `lib/providers/language_provider.dart`
```dart
Locale _currentLocale = const Locale('en');  // English
Locale _currentLocale = const Locale('hi');  // Hindi
Locale _currentLocale = const Locale('ta');  // Tamil
```

---

## 🏗️ Build Commands

```bash
# Android
flutter build apk --release                    # Single APK
flutter build apk --split-per-abi              # Split APKs (smaller)
flutter build appbundle --release              # For Play Store

# iOS (macOS only)
flutter build ios --release

# Web
flutter build web --release

# Desktop
flutter build linux --release
flutter build macos --release
flutter build windows --release
```

---

## 📦 Project Structure

```
bhoomi_v1/
├── lib/
│   ├── main.dart                 # Entry point
│   ├── models/                   # Data models
│   ├── providers/                # State management
│   ├── screens/                  # UI screens
│   ├── services/                 # Auth & other services
│   ├── utils/                    # Utilities & theme
│   ├── widgets/                  # Reusable widgets
│   └── l10n/                     # Translations
├── assets/                       # Images, icons, animations
├── android/                      # Android config
├── ios/                          # iOS config
├── web/                          # Web config
├── SETUP_GUIDE.md               # Installation guide
├── FEATURES.md                  # Feature documentation
├── PROJECT_STATUS.md            # Status report
└── pubspec.yaml                 # Dependencies
```

---

## 🎯 App Screens

| Screen | Route | Description |
|--------|-------|-------------|
| Home | `/` | Dashboard with eco-score |
| Calculator | `/calculator` | Carbon footprint calculator |
| Knowledge | `/knowledge` | Educational tips |
| Community | `/community` | Events & heroes |
| Profile | `/profile` | User profile & stats |
| Login | `/login` | Authentication (optional) |

---

## 🔑 Key Features

| Feature | Status | Location |
|---------|--------|----------|
| Carbon Calculator | ✅ Working | `calculator_screen.dart` |
| Eco-Score | ✅ Working | `home_screen.dart` |
| Knowledge Hub | ✅ Working | `knowledge_screen.dart` |
| Community | ✅ Working | `community_screen.dart` |
| Profile | ✅ Working | `profile_screen.dart` |
| Multi-language | ✅ Working | `l10n/` folder |
| Offline Mode | ✅ Working | `main.dart` |

---

## 🐛 Common Issues & Fixes

### Issue: Flutter not found
```bash
export PATH="$PATH:$HOME/flutter/bin"
source ~/.bashrc  # or ~/.zshrc
```

### Issue: Dependencies not installed
```bash
flutter pub get
```

### Issue: Build fails
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Emulator not starting
```bash
flutter emulators
flutter emulators --launch <emulator-name>
```

---

## 📱 Device Commands

```bash
# List devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run on Android
flutter run -d android

# Run on iOS (macOS only)
flutter run -d ios

# Run on Web
flutter run -d chrome

# Run on Desktop
flutter run -d linux    # or macos, windows
```

---

## 🎨 UI Customization

### Change Theme Colors
**File:** `lib/utils/app_theme.dart`
```dart
static const Color primaryGreen = Color(0xFF2ECC71);
static const Color leafGreen = Color(0xFF52B788);
// Modify these to change app colors
```

### Change App Name
**Android:** `android/app/src/main/AndroidManifest.xml`
**iOS:** `ios/Runner/Info.plist`

---

## 📊 Data & State

### Where Data is Stored
- **Local Storage:** SharedPreferences
- **Location:** Device-specific
- **Persistence:** Survives app restarts
- **Sync:** Local only (unless Firebase enabled)

### Reset App Data
```dart
// In app, or manually:
flutter clean
// Then reinstall app
```

---

## 🌐 Languages Supported

| Language | Code | Status |
|----------|------|--------|
| English | `en` | ✅ Complete |
| Hindi | `hi` | ✅ Complete |
| Tamil | `ta` | ✅ Partial |

**Switch Language:** Drawer menu → Language selector

---

## 📞 Getting Help

1. **Setup Issues** → Read `SETUP_GUIDE.md`
2. **Feature Questions** → Read `FEATURES.md`
3. **Technical Details** → Read `TECHNICAL_SUMMARY.md`
4. **Status Info** → Read `PROJECT_STATUS.md`
5. **Bugs/Issues** → GitHub Issues
6. **Questions** → GitHub Discussions

---

## ✅ Pre-Flight Checklist

Before running the app:
- [ ] Flutter installed (`flutter --version`)
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Device/emulator ready (`flutter devices`)
- [ ] No build errors (`flutter analyze`)

---

## 🎉 Success Indicators

App is working if you can:
- ✅ Launch app without errors
- ✅ Navigate between all 5 screens
- ✅ Input data in calculator
- ✅ See eco-score update
- ✅ Change language
- ✅ Edit profile
- ✅ Data persists after restart

---

## 📈 Performance Tips

```bash
# Release mode (faster)
flutter run --release

# Profile mode (debugging + performance)
flutter run --profile

# Analyze code
flutter analyze

# Check for outdated packages
flutter pub outdated
```

---

## 🔐 Security Note

**Offline Mode (Default):**
- No network access needed
- Data stays on device
- Privacy-first approach
- Perfect for development

**Firebase Mode:**
- Requires authentication
- Cloud sync available
- Configure Firebase credentials

---

## 📦 Dependencies

```yaml
Core: flutter, provider, shared_preferences
UI: google_fonts, glassmorphism, flutter_animate
Charts: fl_chart, percent_indicator
Icons: font_awesome_flutter
Auth: firebase_core, firebase_auth, google_sign_in
i18n: intl, flutter_localizations
```

---

## 🚀 Deploy Checklist

Before deploying:
- [ ] Test on target platform
- [ ] Update version in `pubspec.yaml`
- [ ] Build release version
- [ ] Test release build
- [ ] Update app icons
- [ ] Update splash screen
- [ ] Review permissions
- [ ] Test offline mode
- [ ] Configure Firebase (if used)

---

## 💡 Pro Tips

1. Use `flutter run --release` for best performance
2. Enable hot reload for fast development
3. Use `flutter doctor` to check setup
4. Keep offline mode for development
5. Use scripts (`start.sh`) for quick launch
6. Read all .md files for complete info

---

**🌱 Quick help: `./start.sh` or see SETUP_GUIDE.md**

**Made with 💚 for a sustainable future**
