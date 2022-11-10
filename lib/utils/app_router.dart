import 'package:flutter/material.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/main_screen.dart';
import 'package:mobile/screens/onboarding_screen.dart';
import 'package:mobile/screens/pexels/wallpaper_by_color_screen.dart' as px;

// import 'package:mobile/screens/pexels/home_screen.dart';
import 'package:mobile/screens/pexels/wallpaper_detail_screen.dart' as px;
import 'package:mobile/screens/register_screen.dart';
import 'package:mobile/screens/splash_screen.dart';
import 'package:mobile/screens/wallhaven/wallpaper_by_color_screen.dart' as wh;
import 'package:mobile/screens/wallhaven/wallpaper_detail_screen.dart' as wh;

class RouteName {
  static const String splash = '/splash';
  static const String onBoarding = '/onboarding';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String landing = '/main';
  static const String auth = '/auth';
  static const String wallpaperDetailPx = '/wallpaperDetailPexels';
  static const String wallpaperDetailWh = '/wallpaperDetailWallhaven';
  static const String wallpaperByColorWh = '/wallpaperDetailByColorWh';
  static const String wallpaperByColorPx = '/wallpaperDetailByColorPx';

  static Map<String, WidgetBuilder> get calculateRoutes => {
        RouteName.splash: (context) => const SplashScreen(
              key: ValueKey("a"),
            ),
        RouteName.onBoarding: (context) => const OnboardingScreen(
              key: ValueKey("b"),
            ),
        RouteName.landing: (context) => const MainScreen(
              key: ValueKey("d"),
            ),
        RouteName.login: (context) => const LoginScreen(
              key: ValueKey("e"),
            ),
        RouteName.register: (context) => const RegisterScreen(
              key: ValueKey("f"),
            ),
        RouteName.wallpaperByColorWh: (context) =>
            const wh.WallpaperByColorScreen(
              key: ValueKey("g"),
            ),
        RouteName.wallpaperByColorPx: (context) =>
            const px.WallpaperByColorScreen(
              key: ValueKey("zz"),
            ),
        RouteName.wallpaperDetailPx: (context) =>
            const px.WallpaperDetailScreen(
              key: ValueKey("h"),
            ),
        RouteName.wallpaperDetailWh: (context) =>
            const wh.WallpaperDetailScreen(
              key: ValueKey("i"),
            ),
      };
}
