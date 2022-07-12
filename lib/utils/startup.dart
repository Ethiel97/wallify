import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/models/pexels/wallpaper.dart' as px;
import 'package:mobile/models/pexels/wallpaper_src.dart';
import 'package:mobile/models/wallhaven/wallpaper.dart' as wh;
import 'package:mobile/models/wallhaven/wallpaper_thumbs.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';
import 'package:provider/provider.dart';

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  LogUtils.log("messaging background...");
}

class Startup {
  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _initHiveBox();

    setTransparentStatusBar(delay: 5);
  }

  void _initHiveBox() async {
    await Hive.initFlutter();
    Hive.registerAdapter(wh.WallPaperAdapter());
    Hive.registerAdapter(WallPaperThumbsAdapter());
    Hive.registerAdapter(WallPaperSrcAdapter());
    Hive.registerAdapter(px.WallPaperAdapter());
    await Hive.openBox<wh.WallPaper>(Constants.savedWhWallpapersBox);
    await Hive.openBox<wh.WallPaper>(Constants.savedPxWallpapersBox);
  }

  void setTransparentStatusBar({int delay = 0, ThemeProvider? themeProvider}) {
    try {
      ThemeProvider localThemeProvider = themeProvider ??
          Provider.of<ThemeProvider>(Get.context!, listen: false);

      Future.delayed(Duration(seconds: delay), () {
        bool isDarkMode =
            localThemeProvider.currentTheme == AppTheme.dark.description;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            /*systemNavigationBarColor: isDarkMode
                    ? AppColors.whiteBackgroundColor
                    : AppColors.darkBackgroundColor.toTinyColor().darken(4).color,*/
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                isDarkMode ? Brightness.light : Brightness.dark,
            statusBarBrightness:
                isDarkMode ? Brightness.light : Brightness.dark,
          ),
        );
      });
    } catch (e) {
      print(e);
    }
    // }
  }
}
