// lib/providers/language_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  String get currentLanguageCode => _locale.languageCode;

  bool get isEnglish => _locale.languageCode == 'en';

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
    }
    notifyListeners();
  }

  void changeLanguage(String languageCode) {
    if (_locale.languageCode == languageCode) return;
    
    _locale = Locale(languageCode);
    
    // Save to SharedPreferences
    _saveLanguage(languageCode);
    
    notifyListeners();
  }

  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  void setLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}