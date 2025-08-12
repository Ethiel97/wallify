// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i10;
import 'package:wallinice/features/favorites/presentation/pages/favorites_page.dart'
    as _i1;
import 'package:wallinice/features/main/presentation/pages/main_wrapper_page.dart'
    as _i3;
import 'package:wallinice/features/search/presentation/pages/search_page.dart'
    as _i4;
import 'package:wallinice/features/splash/presentation/pages/splash_page.dart'
    as _i5;
import 'package:wallinice/features/wallpapers/presentation/pages/wallpaper_detail_page.dart'
    as _i6;
import 'package:wallinice/features/wallpapers/presentation/pages/wallpapers_by_color_page.dart'
    as _i7;
import 'package:wallinice/features/wallpapers/wallpapers.dart' as _i9;
import 'package:wallinice/shared/routing/app_router.dart' as _i2;

/// generated route for
/// [_i1.FavoritesPage]
class FavoritesRoute extends _i8.PageRouteInfo<void> {
  const FavoritesRoute({List<_i8.PageRouteInfo>? children})
      : super(
          FavoritesRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavoritesRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.FavoritesPage();
    },
  );
}

/// generated route for
/// [_i2.ForgotPasswordPage]
class ForgotPasswordRoute extends _i8.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i8.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute({List<_i8.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i8.PageRouteInfo<void> {
  const LoginRoute({List<_i8.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.LoginPage();
    },
  );
}

/// generated route for
/// [_i3.MainWrapperPage]
class MainWrapperRoute extends _i8.PageRouteInfo<void> {
  const MainWrapperRoute({List<_i8.PageRouteInfo>? children})
      : super(
          MainWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainWrapperRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.MainWrapperPage();
    },
  );
}

/// generated route for
/// [_i2.OnboardingPage]
class OnboardingRoute extends _i8.PageRouteInfo<void> {
  const OnboardingRoute({List<_i8.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i2.ProfilePage]
class ProfileRoute extends _i8.PageRouteInfo<void> {
  const ProfileRoute({List<_i8.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.ProfilePage();
    },
  );
}

/// generated route for
/// [_i2.RegisterPage]
class RegisterRoute extends _i8.PageRouteInfo<void> {
  const RegisterRoute({List<_i8.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.RegisterPage();
    },
  );
}

/// generated route for
/// [_i4.SearchPage]
class SearchRoute extends _i8.PageRouteInfo<void> {
  const SearchRoute({List<_i8.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.SearchPage();
    },
  );
}

/// generated route for
/// [_i2.SettingsPage]
class SettingsRoute extends _i8.PageRouteInfo<void> {
  const SettingsRoute({List<_i8.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.SettingsPage();
    },
  );
}

/// generated route for
/// [_i5.SplashPage]
class SplashRoute extends _i8.PageRouteInfo<void> {
  const SplashRoute({List<_i8.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.SplashPage();
    },
  );
}

/// generated route for
/// [_i6.WallpaperDetailPage]
class WallpaperDetailRoute extends _i8.PageRouteInfo<WallpaperDetailRouteArgs> {
  WallpaperDetailRoute({
    required _i9.Wallpaper wallpaper,
    _i10.Key? key,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          WallpaperDetailRoute.name,
          args: WallpaperDetailRouteArgs(
            wallpaper: wallpaper,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WallpaperDetailRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WallpaperDetailRouteArgs>();
      return _i6.WallpaperDetailPage(
        wallpaper: args.wallpaper,
        key: args.key,
      );
    },
  );
}

class WallpaperDetailRouteArgs {
  const WallpaperDetailRouteArgs({
    required this.wallpaper,
    this.key,
  });

  final _i9.Wallpaper wallpaper;

  final _i10.Key? key;

  @override
  String toString() {
    return 'WallpaperDetailRouteArgs{wallpaper: $wallpaper, key: $key}';
  }
}

/// generated route for
/// [_i7.WallpapersByColorPage]
class WallpapersByColorRoute
    extends _i8.PageRouteInfo<WallpapersByColorRouteArgs> {
  WallpapersByColorRoute({
    required String colorHex,
    _i10.Key? key,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          WallpapersByColorRoute.name,
          args: WallpapersByColorRouteArgs(
            colorHex: colorHex,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WallpapersByColorRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WallpapersByColorRouteArgs>();
      return _i7.WallpapersByColorPage(
        colorHex: args.colorHex,
        key: args.key,
      );
    },
  );
}

class WallpapersByColorRouteArgs {
  const WallpapersByColorRouteArgs({
    required this.colorHex,
    this.key,
  });

  final String colorHex;

  final _i10.Key? key;

  @override
  String toString() {
    return 'WallpapersByColorRouteArgs{colorHex: $colorHex, key: $key}';
  }
}
