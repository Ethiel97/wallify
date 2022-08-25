import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/text_styles.dart';

class WTextButton extends StatelessWidget {
  const WTextButton({
    Key? key,
    required this.onPress,
    required this.text,
    this.borderRadius = Constants.kBorderRadius,
    this.backgroundColor = const Color(0xff12c2e9),
  }) : super(key: key);

  final VoidCallback onPress;
  final String text;
  final double borderRadius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => TextButton(
      onPressed: onPress,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        fixedSize: Size(Get.width, 50),
      ),
      child: Text(
        text,
        style: TextStyles.textStyle.apply(
          color: Theme.of(context).backgroundColor,
          fontSizeDelta: 2,
        ),
      ),
    );
}
