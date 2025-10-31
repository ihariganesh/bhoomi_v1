# API Configuration

## Groq API Key
This app uses Groq AI API for the chatbot feature.

### How to get your API key:
1. Go to https://console.groq.com
2. Sign up for a free account
3. Navigate to API Keys section
4. Create a new API key
5. Copy the key

### Where to add your key:
- Open `lib/services/ai_chat_service.dart`
- Replace `'YOUR_GROQ_API_KEY_HERE'` with your actual API key

```dart
static const String apiKey = 'gsk_YOUR_ACTUAL_KEY_HERE';
```

## MongoDB Atlas (for backend)
- Connection string template is in `bhoomi_backend/.env`
- Follow `bhoomi_backend/MONGODB_ATLAS_SETUP.md` for setup

## Important Security Notes:
⚠️ **Never commit actual API keys to GitHub!**
- Use environment variables for production
- Keep API keys in separate config files
- Add config files to `.gitignore`
