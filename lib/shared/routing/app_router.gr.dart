// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:wallinice/features/main/presentation/pages/main_wrapper_page.dart'
    as _i2;
import 'package:wallinice/features/splash/presentation/pages/splash_page.dart'
    as _i3;
import 'package:wallinice/features/wallpapers/presentation/pages/wallpapers_by_color_page.dart'
    as _i4;
import 'package:wallinice/shared/routing/app_router.dart' as _i1;

/// generated route for
/// [_i1.FavoritesPage]
class FavoritesRoute extends _i5.PageRouteInfo<void> {
  const FavoritesRoute({List<_i5.PageRouteInfo>? children})
      : super(
          FavoritesRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavoritesRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.FavoritesPage();
    },
  );
}

/// generated route for
/// [_i1.ForgotPasswordPage]
class ForgotPasswordRoute extends _i5.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i5.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i1.LoginPage]
class LoginRoute extends _i5.PageRouteInfo<void> {
  const LoginRoute({List<_i5.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.LoginPage();
    },
  );
}

/// generated route for
/// [_i2.MainWrapperPage]
class MainWrapperRoute extends _i5.PageRouteInfo<void> {
  const MainWrapperRoute({List<_i5.PageRouteInfo>? children})
      : super(
          MainWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainWrapperRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.MainWrapperPage();
    },
  );
}

/// generated route for
/// [_i1.OnboardingPage]
class OnboardingRoute extends _i5.PageRouteInfo<void> {
  const OnboardingRoute({List<_i5.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i1.ProfilePage]
class ProfileRoute extends _i5.PageRouteInfo<void> {
  const ProfileRoute({List<_i5.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.ProfilePage();
    },
  );
}

/// generated route for
/// [_i1.RegisterPage]
class RegisterRoute extends _i5.PageRouteInfo<void> {
  const RegisterRoute({List<_i5.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.RegisterPage();
    },
  );
}

/// generated route for
/// [_i1.SearchPage]
class SearchRoute extends _i5.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i6.Key? key,
    String? query,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            query: query,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SearchRouteArgs>(orElse: () => const SearchRouteArgs());
      return _i1.SearchPage(
        key: args.key,
        query: args.query,
      );
    },
  );
}

class SearchRouteArgs {
  const SearchRouteArgs({
    this.key,
    this.query,
  });

  final _i6.Key? key;

  final String? query;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, query: $query}';
  }
}

/// generated route for
/// [_i1.SettingsPage]
class SettingsRoute extends _i5.PageRouteInfo<void> {
  const SettingsRoute({List<_i5.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.SettingsPage();
    },
  );
}

/// generated route for
/// [_i3.SplashPage]
class SplashRoute extends _i5.PageRouteInfo<void> {
  const SplashRoute({List<_i5.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.SplashPage();
    },
  );
}

/// generated route for
/// [_i1.WallpaperDetailPage]
class WallpaperDetailRoute extends _i5.PageRouteInfo<WallpaperDetailRouteArgs> {
  WallpaperDetailRoute({
    required String id,
    _i6.Key? key,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          WallpaperDetailRoute.name,
          args: WallpaperDetailRouteArgs(
            id: id,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WallpaperDetailRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WallpaperDetailRouteArgs>();
      return _i1.WallpaperDetailPage(
        id: args.id,
        key: args.key,
      );
    },
  );
}

class WallpaperDetailRouteArgs {
  const WallpaperDetailRouteArgs({
    required this.id,
    this.key,
  });

  final String id;

  final _i6.Key? key;

  @override
  String toString() {
    return 'WallpaperDetailRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i4.WallpapersByColorPage]
class WallpapersByColorRoute
    extends _i5.PageRouteInfo<WallpapersByColorRouteArgs> {
  WallpapersByColorRoute({
    required String colorHex,
    _i6.Key? key,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          WallpapersByColorRoute.name,
          args: WallpapersByColorRouteArgs(
            colorHex: colorHex,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WallpapersByColorRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WallpapersByColorRouteArgs>();
      return _i4.WallpapersByColorPage(
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

  final _i6.Key? key;

  @override
  String toString() {
    return 'WallpapersByColorRouteArgs{colorHex: $colorHex, key: $key}';
  }
}
