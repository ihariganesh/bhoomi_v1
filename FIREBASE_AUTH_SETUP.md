# 🔐 Firebase Authentication Setup Guide for Bhoomi App

## ✅ What's Been Implemented

### 1. **Authentication Features**
- ✅ Google Sign-In integration
- ✅ Login Screen with beautiful animations
- ✅ Auto-login (checks if user is already signed in)
- ✅ Logout functionality in the drawer menu
- ✅ Auth state management with Firebase

### 2. **Files Created/Modified**

#### New Files:
- `lib/services/auth_service.dart` - Authentication service
- `lib/screens/login_screen.dart` - Login UI
- `lib/firebase_options.dart` - Firebase configuration

#### Modified Files:
- `lib/main.dart` - Added Firebase initialization and auth state checking
- `lib/widgets/animated_drawer.dart` - Added logout button
- `lib/screens/home_screen.dart` - Already has Builder widget for drawer
- `pubspec.yaml` - Added Firebase dependencies

### 3. **Packages Installed**
```yaml
firebase_core: ^3.15.2
firebase_auth: ^5.7.0
google_sign_in: ^6.3.0
crypto: ^3.0.6
```

## 📋 Firebase Console Setup (You Need to Do This)

### Step 1: Get Your Firebase Configuration

1. **Go to Firebase Console**: https://console.firebase.google.com/

2. **Select your project** or create a new one

3. **Navigate to Project Settings** (gear icon)

4. **Scroll down to "Your apps"** section

5. **Find your Android app** (com.example.bhoomi_v1)

6. **Copy the configuration values**:
   - Web API Key
   - App ID  
   - Project ID
   - Messaging Sender ID

### Step 2: Update firebase_options.dart

Open `/home/hari/Desktop/bhoomi/bhoomi_v1/lib/firebase_options.dart` and replace the placeholder values:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_ANDROID_API_KEY_FROM_FIREBASE',
  appId: 'YOUR_ACTUAL_APP_ID_FROM_FIREBASE',
  messagingSenderId: 'YOUR_ACTUAL_SENDER_ID',
  projectId: 'YOUR_ACTUAL_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

### Step 3: Enable Google Sign-In in Firebase

1. In Firebase Console, go to **Authentication** → **Sign-in method**

2. Click on **Google** in the providers list

3. Toggle **Enable**

4. Set a **Project public-facing name**: "Bhoomi"

5. Set a **Support email**: your email

6. Click **Save**

### Step 4: Configure Google Sign-In for Android

1. In Firebase Console, go to **Project Settings**

2. Under **Your apps**, find your Android app

3. Add **SHA-1** certificate fingerprint:

Run this command in terminal:
```bash
cd android
./gradlew signingReport
```

4. Copy the SHA-1 fingerprint from debug key

5. Add it to Firebase Console (Project Settings → Your apps → Add fingerprint)

6. **Download the updated `google-services.json`** file

7. Replace the old one at:
```
/home/hari/Desktop/bhoomi/bhoomi_v1/android/app/google-services.json
```

## 🚀 How to Test

### Option 1: Run on your phone (once authorized)
```bash
flutter devices  # Check if phone is connected
flutter run -d <DEVICE_ID>
```

### Option 2: Run on Linux (for testing UI)
```bash
flutter run -d linux
```

## 🎯 How the Authentication Flow Works

### First Launch (Not Signed In):
1. App starts → Shows **Login Screen**
2. User taps "Continue with Google"
3. Google Sign-In popup appears
4. User selects account and authorizes
5. Redirects to **Home Screen**

### Subsequent Launches (Already Signed In):
1. App starts → Checks auth state
2. User is already signed in → Goes directly to **Home Screen**
3. No need to login again!

### Sign Out:
1. User opens drawer menu (hamburger icon)
2. Taps "Logout"
3. Signs out from Google
4. Redirects to **Login Screen**

## 🎨 What the Login Screen Looks Like

- **Animated Bhoomi logo** with green gradient circle
- **Welcome text**: "Welcome to Bhoomi - Join us in creating a sustainable future"
- **Google Sign-In button** with blue-green gradient
- **Glassmorphism effects** consistent with your app theme
- **Smooth animations**: fade-in and slide-up effects
- **Loading indicator** while signing in

## 📱 Testing Without Phone

If you want to test the UI without a phone:

```bash
# Run on Linux desktop
flutter run -d linux

# The Google Sign-In won't work on Linux, but you can see the UI
```

## ⚠️ Important Notes

1. **SHA-1 Certificate**: Required for Google Sign-In on Android
   - Get it from: `cd android && ./gradlew signingReport`
   - Add to Firebase Console

2. **google-services.json**: Must be updated after adding SHA-1
   - Download from Firebase Console
   - Replace in `android/app/google-services.json`

3. **Internet Permission**: Already configured in AndroidManifest.xml

4. **Package Name**: Must match Firebase: `com.example.bhoomi_v1`

## 🐛 Troubleshooting

### Error: "SHA-1 certificate not found"
- Run `cd android && ./gradlew signingReport`
- Add SHA-1 to Firebase Console
- Download new google-services.json

### Error: "Google Sign-In failed"
- Check if Google provider is enabled in Firebase Console
- Verify SHA-1 is added
- Make sure google-services.json is up to date

### Error: "Unable to reach Firebase"
- Check internet connection
- Verify firebase_options.dart has correct values
- Ensure google-services.json exists in android/app/

### Menu button not working
- Already fixed! Using Builder widget in HomeScreen

## 📞 Next Steps

1. ✅ Update `firebase_options.dart` with your actual Firebase config
2. ✅ Get SHA-1 certificate: `cd android && ./gradlew signingReport`
3. ✅ Add SHA-1 to Firebase Console
4. ✅ Download updated `google-services.json`
5. ✅ Replace `android/app/google-services.json`
6. ✅ Authorize your phone for USB debugging
7. ✅ Run: `flutter run -d <YOUR_DEVICE_ID>`

## 🎉 You're All Set!

Once you complete the Firebase setup, your app will have:
- ✨ Beautiful login screen
- 🔐 Secure Google authentication
- 🔄 Auto-login for returning users
- 🚪 Easy logout from drawer menu
- 📱 Ready for production use!

---

**Need Help?** Check the Firebase Console documentation:
https://firebase.google.com/docs/auth/android/google-signin
