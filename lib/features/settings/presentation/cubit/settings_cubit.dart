import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/settings/settings.dart';

part 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository) : super(const SettingsState()) {
    _init();
  }

  final SettingsRepository _repository;

  void _init() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final themeMode = await _repository.getThemeMode();
      emit(
        state.copyWith(
          themeMode: themeMode.toSuccess<ThemeMode>(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          themeMode: 'Failed to load theme'.toError<ThemeMode>(),
        ),
      );
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    emit(
      state.copyWith(
        themeMode: null.toLoading<ThemeMode>(),
      ),
    );

    try {
      await _repository.setThemeMode(themeMode);
      emit(
        state.copyWith(
          themeMode: themeMode.toSuccess<ThemeMode>(),
        ),
      );
    } catch (e) {
      print('SettingsCubit: Error setting theme mode: $e');
      emit(
        state.copyWith(
          themeMode: 'Failed to update theme'.toError<ThemeMode>(),
        ),
      );
    }
  }

  Future<void> toggleThemeMode() async {
    final currentThemeMode = state.themeMode.maybeWhen(
      success: (themeMode) => themeMode,
      orElse: () => ThemeMode.system,
    );

    final nextThemeMode = switch (currentThemeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
    };

    await setThemeMode(nextThemeMode);
  }

  Future<void> setLanguageCode(String? languageCode) async {
    emit(
      state.copyWith(
        languageCode: null.toLoading<String?>(),
      ),
    );

    try {
      await _repository.setLanguageCode(languageCode);
      final updatedLanguageCode = await _repository.getLanguageCode();
      emit(
        state.copyWith(
          languageCode: updatedLanguageCode.toSuccess<String?>(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          languageCode: 'Failed to update language'.toError<String?>(),
        ),
      );
    }
  }
}
