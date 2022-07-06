import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/log.dart';
import 'package:provider/provider.dart';
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

    setTransparentStatusBar(delay: 5);
  }

  void setTransparentStatusBar({int delay = 0}) {
    Future.delayed(
        Duration(seconds: delay),
        () => {
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  systemNavigationBarColor:
                      Provider.of<ThemeProvider>(Get.context!, listen: false)
                                  .currentTheme ==
                              AppTheme.dark.description
                          ? AppColors.screenBackgroundColor
                          : AppColors.whiteBackgroundColor
                              .toTinyColor()
                              .darken(4)
                              .color,
                  statusBarColor: Colors.transparent,
                ),
              )
            });

    // }
  }
}
