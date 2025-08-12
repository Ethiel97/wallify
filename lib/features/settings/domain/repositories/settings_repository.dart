import 'package:flutter/material.dart';

abstract class SettingsRepository {
  /// Get current theme mode
  Future<ThemeMode> getThemeMode();

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode themeMode);


  /// Get language code
  Future<String?> getLanguageCode();

  /// Set language code
  Future<void> setLanguageCode(String? languageCode);
}
