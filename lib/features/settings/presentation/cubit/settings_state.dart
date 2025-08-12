part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = const ValueWrapper<ThemeMode>(),
    this.languageCode = const ValueWrapper<String>(),
  });

  final ValueWrapper<ThemeMode> themeMode;
  final ValueWrapper<String?> languageCode;

  SettingsState copyWith({
    ValueWrapper<ThemeMode>? themeMode,
    ValueWrapper<String?>? languageCode,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [themeMode, languageCode];
}
