// Route names for type-safe navigation
import 'package:auto_route/auto_route.dart';

class RouteNames {
  const RouteNames._();

  // Auth routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // App routes
  static const String onboarding = '/onboarding';
  static const String main = '/main';
  static const String home = '/main/home';
  static const String search = '/main/search';
  static const String favorites = '/main/favorites';
  static const String profile = '/main/profile';

  // Feature routes
  static const String wallpaperDetail = '/wallpaper';
  static const String wallpapersByColor = '/wallpapers/color';
  static const String settings = '/settings';
}

// Extension for easier navigation
extension AppRouterExtension on StackRouter {
  // Auth navigation
  Future<void> pushLogin() => pushNamed(RouteNames.login);

  Future<void> pushRegister() => pushNamed(RouteNames.register);

  Future<void> pushForgotPassword() => pushNamed(RouteNames.forgotPassword);

  // Replace with login (clear stack)
  Future<void> goToLogin() => pushAndClearStack(RouteNames.login);

  // Main app navigation
  Future<void> pushOnboarding() => pushNamed(RouteNames.onboarding);

  Future<void> goToMain() => pushAndClearStack(RouteNames.main);

  Future<void> goToHome() => pushNamed(RouteNames.home);

  // Feature navigation
  Future<void> pushWallpaperDetail(String id) =>
      pushNamed('${RouteNames.wallpaperDetail}/$id');

  Future<void> pushWallpapersByColor(String color) =>
      pushNamed('${RouteNames.wallpapersByColor}/$color');

  Future<void> pushSearch({String? query}) {
    final route =
    query != null ? '${RouteNames.search}?query=$query' : RouteNames.search;
    return pushNamed(route);
  }

  Future<void> pushSettings() => pushNamed(RouteNames.settings);

  // Utility methods
  Future<void> pushAndClearStack(String routeName) {
    return pushAndClearStack(routeName);
  }
}
