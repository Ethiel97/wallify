import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:wallinice/features/settings/settings.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<ThemeMode> getThemeMode() async {
    try {
      return await _localDataSource.getThemeMode();
    } catch (e) {
      // Log error and return default
      print('Error getting theme mode: $e');
      return ThemeMode.system;
    }
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      await _localDataSource.setThemeMode(themeMode);
    } catch (e) {
      print('Error setting theme mode: $e');
      rethrow;
    }
  }

  @override
  Future<String?> getLanguageCode() async {
    try {
      return await _localDataSource.getLanguageCode();
    } catch (e) {
      print('Error getting language code: $e');
      return null;
    }
  }

  @override
  Future<void> setLanguageCode(String? languageCode) async {
    try {
      await _localDataSource.setLanguageCode(languageCode);
    } catch (e) {
      print('Error setting language code: $e');
      rethrow;
    }
  }
}
