import 'package:flutter/material.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/main_screen.dart';
import 'package:mobile/screens/onboarding_screen.dart';
import 'package:mobile/screens/splash_screen.dart';
import 'package:mobile/screens/wallpaper_detail_screen.dart';

const String splash = '/splash';
const String onBoarding = '/onboarding';
const String home = '/home';
const String login = '/login';
const String register = '/register';
const String landing = '/main';
const String auth = '/auth';
const String wallpaperDetail = '/wallpaperDetail';

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
  wallpaperDetail: (context) => const WallpaperDetailScreen(
        key: ValueKey("e"),
      ),
};
