class AppRoutes {
  const AppRoutes._();

  // Auth routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main app routes
  static const String home = '/home';
  static const String main = '/main';
  static const String onboarding = '/onboarding';

  // Wallpaper routes
  static const String wallpaperDetail = '/wallpaper-detail';
  static const String wallpapersByColor = '/wallpapers-by-color';
  static const String search = '/search';

  // User routes
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Static route names for easier reference
  static const Map<String, String> routeNames = {
    'splash': splash,
    'login': login,
    'register': register,
    'forgotPassword': forgotPassword,
    'home': home,
    'main': main,
    'onboarding': onboarding,
    'wallpaperDetail': wallpaperDetail,
    'wallpapersByColor': wallpapersByColor,
    'search': search,
    'favorites': favorites,
    'profile': profile,
    'settings': settings,
  };
}
