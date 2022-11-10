import 'package:flutter/material.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/secure_storage.dart';
import 'package:mobile/utils/startup.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:tinycolor2/tinycolor2.dart';

enum AppTheme {
  dark,
  light;

  String get description => name;
}

class ThemeProvider with ChangeNotifier {
  final String _themeMode = 'THEME_STATUS';
  String _currentTheme = AppTheme.dark.description;

  TextStyle textStyle = TextStyles.textStyle;

  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: TextStyles.textStyle.fontFamily,
    backgroundColor: AppColors.screenBackgroundColor,
    scaffoldBackgroundColor: AppColors.screenBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: AppColors.primaryColor,
    textTheme: TextTheme(
      bodyText1: TextStyles.textStyle.apply(
        color: AppColors.textColor,
      ),
      bodyText2: TextStyles.textStyle.apply(
        color: AppColors.textColor,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.grey,
            brightness: Brightness.dark,
            accentColor: Colors.redAccent)
        .copyWith(
      secondary: AppColors.accentColor,
    ),
  );

  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: TextStyles.textStyle.fontFamily,
    backgroundColor: AppColors.whiteBackgroundColor.darken(4),
    scaffoldBackgroundColor: AppColors.whiteBackgroundColor,
    primarySwatch: Colors.grey,
    primaryColor: AppColors.primaryColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: IconThemeData(color: AppColors.screenBackgroundColor),
    textTheme: TextTheme(
      bodyText1: TextStyles.textStyle.apply(
        color: AppColors.screenBackgroundColor,
      ),
      bodyText2: TextStyles.textStyle.apply(
        color: AppColors.screenBackgroundColor,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.grey,
            brightness: Brightness.light,
            accentColor: Colors.redAccent)
        .copyWith(
      secondary: AppColors.accentColor,
    ),
  );

  ThemeData? _themeData;

  ThemeData? get theme => _themeData ?? _darkTheme;

  String get currentTheme => _currentTheme;

  ThemeProvider() {
    SecureStorageService.readItem(key: _themeMode).then((value) {
      if (value != null) {
        switch (value.toString()) {
          case 'light':
            setLightMode();
            break;
          case 'dark':
            setDarkMode();
            break;
          default:
            setDarkMode();
            break;
        }
        notifyListeners();
      } else {
        setDarkMode();
        Startup().setTransparentStatusBar();
      }

      Startup().setTransparentStatusBar();
    }).catchError((e) {
      debugPrint(e);
      setDarkMode();
      Startup().setTransparentStatusBar();
    });
  }

  void setDarkMode() {
    _themeData = _darkTheme;
    _currentTheme = AppTheme.dark.description;
    SecureStorageService.saveItem(key: _themeMode, data: _currentTheme);
    notifyListeners();
  }

  void toggleMode() {
    if (_currentTheme == AppTheme.dark.description) {
      setLightMode();
    } else {
      setDarkMode();
    }
    Startup().setTransparentStatusBar();
  }

  void setLightMode() {
    _themeData = _lightTheme;
    _currentTheme = AppTheme.light.description;
    SecureStorageService.saveItem(key: _themeMode, data: _currentTheme);

    notifyListeners();
  }

/*changeStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: currentTheme == AppTheme.dark.description
            ? AppColors.screenBackgroundColor
            : AppColors.whiteBackgroundColor.darken(4),
      ),
    );
  }*/
}
