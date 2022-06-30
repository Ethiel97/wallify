import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:mobile/repositories/wallpaper_repository.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';
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
import 'services/notification_service.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    super.initState();

    _firebaseMessaging = FirebaseMessaging.instance;

    _firebaseMessaging.subscribeToTopic(Constants.randomWallpaperTopic);
    // _firebaseMessaging.subscribeToTopic(testTopic);

    FirebaseMessaging.onMessage.listen((event) {
      NotificationService(event, context: Get.context!).showToast();
    });

    if (Platform.isIOS) {
      _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          )
          .then((value) => null)
          .catchError((error) {
        LogUtils.error(error);
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => Sizer(
          builder: (context, orientation, deviceType) => OverlaySupport(
            child: GetMaterialApp(
              builder: (context, widget) {
                Widget error = const Text('...rendering error...');
                // if (widget is Scaffold || widget is Navigator || widget is Material) {
                error = Container(
                  height: Get.height / 2,
                  child: Opacity(
                      opacity: 1, child: Scaffold(body: Center(child: error))),
                );
                // }

                if (Get.currentRoute == wallpaperDetailWh ||
                    Get.currentRoute == wallpaperByColorWh) {
                  ErrorWidget.builder =
                      (FlutterErrorDetails errorDetails) => const Material(
                            type: MaterialType.transparency,
                            child: Opacity(
                              opacity: 1,
                              child: Center(
                                child: Text(""),
                              ),
                            ),
                          );
                }

                if (widget != null) return widget;
                throw ('widget is null');
              },
              title: Constants.appName.toLowerCase(),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
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
