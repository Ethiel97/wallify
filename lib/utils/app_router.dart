import 'package:flutter/material.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/main_screen.dart';
import 'package:mobile/screens/onboarding_screen.dart';

// import 'package:mobile/screens/pexels/home_screen.dart';
import 'package:mobile/screens/pexels/wallpaper_detail_screen.dart' as px;
import 'package:mobile/screens/register_screen.dart';
import 'package:mobile/screens/splash_screen.dart';
import 'package:mobile/screens/wallhaven/wallpaper_by_color_screen.dart' as wh;
import 'package:mobile/screens/wallhaven/wallpaper_detail_screen.dart' as wh;

const String splash = '/splash';
const String onBoarding = '/onboarding';
const String home = '/home';
const String login = '/login';
const String register = '/register';
const String landing = '/main';
const String auth = '/auth';
const String wallpaperDetailPx = '/wallpaperDetailPexels';
const String wallpaperDetailWh = '/wallpaperDetailWallhaven';
const String wallpaperByColorWh = '/wallpaperDetailByColorWh';

Map<String, WidgetBuilder> appRoutes = {
  splash: (context) => const SplashScreen(
        key: ValueKey("a"),
      ),
  onBoarding: (context) => const OnboardingScreen(
        key: ValueKey("b"),
      ),
  landing: (context) => const MainScreen(
        key: ValueKey("d"),
      ),
  login: (context) => const LoginScreen(
        key: ValueKey("e"),
      ),
  register: (context) => const RegisterScreen(
        key: ValueKey("f"),
      ),
  wallpaperByColorWh: (context) => const wh.WallpaperByColorScreen(
        key: ValueKey("g"),
      ),
  wallpaperDetailPx: (context) => const px.WallpaperDetailScreen(
        key: ValueKey("h"),
      ),
  wallpaperDetailWh: (context) => const wh.WallpaperDetailScreen(
        key: ValueKey("i"),
      ),
};
