import 'package:flutter/material.dart';
import 'package:mobile/screens/main_screen.dart';
import 'package:mobile/screens/onboarding_screen.dart';
import 'package:mobile/screens/pexels/home_screen.dart';
import 'package:mobile/screens/pexels/wallpaper_detail_screen.dart' as px;
import 'package:mobile/screens/splash_screen.dart';
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

Map<String, WidgetBuilder> appRoutes = {
  splash: (context) => const SplashScreen(
        key: ValueKey("a"),
      ),
  onBoarding: (context) => const OnboardingScreen(
        key: ValueKey("b"),
      ),
  home: (context) => const HomeScreen(
        key: ValueKey("c"),
      ),
  landing: (context) => const MainScreen(
        key: ValueKey("d"),
      ),
  wallpaperDetailPx: (context) => const px.WallpaperDetailScreen(
        key: ValueKey("e"),
      ),
  wallpaperDetailWh: (context) => const wh.WallpaperDetailScreen(
        key: ValueKey("f"),
      ),
};
