import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleKey = 'selected_locale';
const _hasChosenKey = 'has_chosen_language';

  Future<bool> hasChosenLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasChosenKey) ?? false;
  }

  Future<void> setChosenLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasChosenKey, true);
    saveLocale(locale);
  }

Future<Locale> loadSavedLocale({Locale fallback = const Locale('en')}) async {
  final prefs = await SharedPreferences.getInstance();
  final language = prefs.getString(_kLocaleKey);
  if (language == null || language.isEmpty) return fallback;
  return Locale(language);
}

Future<void> saveLocale(Locale locale) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_kLocaleKey, locale.languageCode);
}
