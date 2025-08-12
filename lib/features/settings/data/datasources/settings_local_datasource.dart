import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:wallinice/core/storage/storage.dart';

abstract class SettingsLocalDataSource {
  Future<ThemeMode> getThemeMode();
  Future<void> setThemeMode(ThemeMode themeMode);
  Future<String?> getLanguageCode();
  Future<void> setLanguageCode(String? languageCode);
  void dispose();
}

@LazySingleton(as: SettingsLocalDataSource)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl(this._storageService);

  static const String _collection = 'app_settings';
  static const String _themeModeKey = 'theme_mode';
  static const String _languageCodeKey = 'language_code';

  final StorageService _storageService;

  @override
  Future<ThemeMode> getThemeMode() async {
    final themeModeString =
        await _storageService.get<String>(_collection, _themeModeKey);
    return _parseThemeMode(themeModeString);
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    final themeModeString = _themeModeToString(themeMode);
    await _storageService.put<String>(
        _collection, _themeModeKey, themeModeString,);
  }

  @override
  Future<String?> getLanguageCode() async {
    return _storageService.get<String>(_collection, _languageCodeKey);
  }

  @override
  Future<void> setLanguageCode(String? languageCode) async {
    if (languageCode != null) {
      await _storageService.put<String>(
          _collection, _languageCodeKey, languageCode,);
    } else {
      await _storageService.delete(_collection, _languageCodeKey);
    }
  }

  ThemeMode _parseThemeMode(String? themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      case null: // Default to system if not set
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  @override
  @disposeMethod  
  void dispose() {
    // No resources to dispose
  }
}
