import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:tinycolor2/tinycolor2.dart';

mixin utilities {
 static void confirmAction({
    String confirmText = "Confirmation",
    required String message,
    required VoidCallback action,
    required String actionText,
  }) {
    Get.snackbar(
      confirmText,
      message,
      messageText: Text(
        message,
        style: TextStyles.textStyle.apply(
          color: Theme.of(Get.context!).backgroundColor,
          fontSizeDelta: -4.4,
          fontWeightDelta: 1,
        ),
      ),
      // titleText: ,
      // colorText: Theme.of(Get.context!).textTheme.bodyText1!.color,
      colorText: Theme.of(Get.context!).backgroundColor,
      snackPosition: SnackPosition.TOP,
      // backgroundColor: Theme.of(Get.context!).backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ),
      backgroundColor: Theme.of(Get.context!).textTheme.bodyText1!.color,
      duration: const Duration(milliseconds: Constants.kDuration * 30),
      mainButton: TextButton(
        /*icon: Icon(
          Iconsax.paintbucket,
          color: Theme.of(Get.context!).textTheme.bodyText1!.color,
        ),*/
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          backgroundColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
        ),
        onPressed: () => action(),
        child: Text(
          actionText,
          style: TextStyles.textStyle.apply(
            color: TinyColor(
              Theme.of(Get.context!).colorScheme.secondary,
            ).darken(15).color,
            fontSizeDelta: -4,
            fontWeightDelta: 10,
          ),
        ),
      ),
    );
  }
}
