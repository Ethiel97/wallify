import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/log.dart';
import 'package:tinycolor2/tinycolor2.dart';

import 'colors.dart';

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  LogUtils.log("messaging background...");
  // Or do other work.
}

class Startup {
  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    setTransparentStatusBar();
  }

  void setTransparentStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            ThemeProvider().currentTheme == AppTheme.dark.description
                ? AppColors.screenBackgroundColor
                : AppColors.whiteBackgroundColor.toTinyColor().darken(4).color,
        statusBarColor: Colors.transparent,
      ),
    );
  }
}
