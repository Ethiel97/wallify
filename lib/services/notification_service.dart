import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';
import 'package:overlay_support/overlay_support.dart';

import '../utils/colors.dart';
import '../utils/text_styles.dart';

class NotificationService {
  RemoteMessage remoteMessage;
  BuildContext context;

  NotificationService(this.remoteMessage, {required this.context});

  static prepareService() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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

  void showToast() {
    LogUtils.log("REMOTEMESSAGE ${remoteMessage.toString()}");

    var title = remoteMessage.notification?.title;
    var body = remoteMessage.notification?.body ?? "Notification";
    // var data = remoteMessage.data;

    //TODO - display a dialog for the random quote
    Widget toastWidget = Material(
      type: MaterialType.transparency,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        margin: const EdgeInsets.only(
          left: 14,
          right: 14,
          bottom: 40,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.accentColor,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/ico.png',
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title!,
                    style: TextStyles.textStyle.apply(
                      fontSizeDelta: -2,
                      fontWeightDelta: 2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    body,
                    style: TextStyles.textStyle.apply(
                      fontSizeDelta: -4,
                      fontWeightDelta: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showOverlayNotification(
      (context) => toastWidget,
      duration: const Duration(seconds: 12),
      position: NotificationPosition.bottom,
    );
  }
}
