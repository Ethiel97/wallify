import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:mobile/infrastructure/observable.dart';
import 'package:mobile/providers/api_provider.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/repositories/wallpaper_repository.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';
import 'package:mobile/utils/startup.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'models/pexels/wallpaper_px.dart' as px;
import 'models/wallhaven/wallpaper_wh.dart' as wh;
import 'providers/navigation_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/wallpaper_provider.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';
import 'utils/app_router.dart';

typedef CreatorCallback<T> = T Function(Map<String, dynamic>);

void main() async {
  await Startup().init();

  runZonedGuarded(() {
    runApp(
      MultiProvider(
        providers: [
          Provider<ApiProvider>(
            create: (context) => ApiProvider(),
          ),
          ChangeNotifierProvider<NavigationProvider>(
            create: (_) => NavigationProvider(),
          ),
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(),
          ),
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(),
          ),
          ChangeNotifierProvider<Observable>(
            create: (_) => Observable<WallpaperViewModel>(),
          ),
          ChangeNotifierProvider<WallpaperProviderObserver>(
            create: (_) => WallpaperProviderObserver(),
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
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseMessaging _firebaseMessaging;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.delayed(Duration.zero, () {
      if (mounted) {
        Provider.of<Observable>(context, listen: false).subscribe(
            Provider.of<WallpaperProviderObserver>(context, listen: false));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _firebaseMessaging = FirebaseMessaging.instance;

    _firebaseMessaging.subscribeToTopic(Constants.randomWallpaperTopic);
    // _firebaseMessaging.subscribeToTopic(Constants.testTopic);

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
  Widget build(BuildContext context) => Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, authProvider, _) => IgnorePointer(
          ignoring: authProvider.appStatus == AppStatus.processing,
          child: OverlaySupport(
            child: GetMaterialApp(
              builder: (context, widget) {
                Widget error = const Text('...rendering error...');
                // if (widget is Scaffold || widget is Navigator || widget is Material) {
                error = SizedBox(
                  height: Get.height / 2,
                  child: Opacity(
                      opacity: 1, child: Scaffold(body: Center(child: error))),
                );
                // }

                if (Get.currentRoute == RouteName.wallpaperDetailWh ||
                    Get.currentRoute == RouteName.wallpaperByColorWh) {
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
              routes: RouteName.calculateRoutes,
              home: const SplashScreen(
                key: ValueKey("splash"),
              ),
            ),
          ),
        ),
      );
}

// #keytool -genkeypair -keystore E:/app_keys/wallinice/app.jks -keyalg RSA -keysize 2048 -validity 9125 -alias upload

// #keytool -export -rfc -alias upload -file E:/app_keys/wallinice/wallinice_upload.pem -keystore E:/app_keys/wallinice/app.jks
