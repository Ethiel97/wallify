import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:tap_builder/tap_builder.dart';

import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color textColor;
  final VoidCallback onTap;
  final bool processing;
  final bool enabled;
  final Widget? child;

  const CustomButton({
    Key? key,
    required this.text,
    this.processing = false,
    this.child,
    this.enabled = true,
    required this.onTap,
    this.color,
    this.textColor = Colors.white,
  }) : super(key: key);

  Color get backgroundColor => color ?? Theme.of(Get.context!).backgroundColor;

  Widget get content =>
      this.child ??
      Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyles.textStyle.apply(
          color: textColor,
          fontWeightDelta: 10,
          fontSizeDelta: -1,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  @override
  Widget build(BuildContext context) => TapBuilder(
        onTap: enabled ? onTap : null,
        builder: (context, state, _) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: state == TapState.pressed
              ? const EdgeInsets.all(16)
              : const EdgeInsets.all(
                  18,
                ),
          width: double.infinity,
          decoration: BoxDecoration(
              color:
                  enabled ? backgroundColor : backgroundColor.withOpacity(.65),
              borderRadius: BorderRadius.circular(
                Constants.kBorderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: state == TapState.pressed
                      ? Theme.of(context).backgroundColor.withOpacity(.5)
                      : Theme.of(context).backgroundColor.withOpacity(.2),
                  blurRadius: state == TapState.pressed ? 5 : 3,
                  offset: state == TapState.pressed
                      ? const Offset(0, 10)
                      : const Offset(0, 6),
                ),
              ]),
          child: processing
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : content,
        ),
      );
}
