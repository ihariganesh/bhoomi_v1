import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/app_theme.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: languageProvider.currentLocale.languageCode,
          icon: Icon(
            Icons.language,
            color: AppTheme.primaryGreen,
          ),
          dropdownColor: AppTheme.surfaceLight,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          items: const [
            DropdownMenuItem(
              value: 'en',
              child: Row(
                children: [
                  Text('🇬🇧 '),
                  SizedBox(width: 8),
                  Text('English'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'hi',
              child: Row(
                children: [
                  Text('🇮🇳 '),
                  SizedBox(width: 8),
                  Text('हिंदी'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'ta',
              child: Row(
                children: [
                  Text('🇮🇳 '),
                  SizedBox(width: 8),
                  Text('தமிழ்'),
                ],
              ),
            ),
          ],
          onChanged: (String? value) {
            if (value != null) {
              languageProvider.changeLanguage(value);
              
              String message = 'Language changed!';
              if (value == 'hi') {
                message = 'भाषा बदल गई!';
              } else if (value == 'ta') {
                message = 'மொழி மாற்றப்பட்டது!';
              }
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppTheme.primaryGreen,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
