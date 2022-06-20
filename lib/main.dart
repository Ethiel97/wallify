import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:mobile/repositories/wallpaper_repository.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/startup.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'models/pexels/wallpaper.dart' as px;
import 'models/wallhaven/wallpaper.dart' as wh;
import 'providers/navigation_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_router.dart';

typedef CreatorCallback<T> = T Function(Map<String, dynamic>);

void main() async {
  await Startup().init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<WallpaperViewModel<wh.WallPaper>>(
          create: (_) => WallpaperViewModel<wh.WallPaper>(
            wallpaperRepository: WallPaperRepository<wh.WallPaper>(
              wallPaperProvider: WallPaperProvider.wallhaven,
              creatorCallback: wh.WallPaper.fromJson,
              baseApiUrl: Constants.wallhavenApiHost!,
            ),
          ),
        ),
        ChangeNotifierProvider<WallpaperViewModel<px.WallPaper>>(
          create: (_) => WallpaperViewModel<px.WallPaper>(
            wallpaperRepository: WallPaperRepository<px.WallPaper>(
              creatorCallback: px.WallPaper.fromJson,
              baseApiUrl: Constants.pexelsApiHost!,
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => Sizer(
          builder: (context, orientation, deviceType) => OverlaySupport(
            child: GetMaterialApp(
              title: 'dailyQ',
              localizationsDelegates: const [
                // AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              // supportedLocales: AppLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
              theme: themeProvider.theme,
              routes: appRoutes,
              home: const SplashScreen(
                key: ValueKey("spash"),
              ),
            ),
          ),
        ),
      );
}
