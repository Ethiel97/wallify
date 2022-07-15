import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

class MyBackButton extends StatefulWidget {
  final Color iconColor;

  final Color backgroundColor;

  final bool transparentize;

  final IconData icon;

  const MyBackButton({
    Key? key,
    this.transparentize = true,
    this.icon = Iconsax.arrow_left_1,
    this.iconColor = const Color(0xff7FDD05),
    this.backgroundColor = const Color(0xff7FDD05),
  }) : super(
          key: key,
        );

  @override
  _MyBackButtonState createState() => _MyBackButtonState();
}

class _MyBackButtonState extends State<MyBackButton> {
  @override
  Widget build(BuildContext context) => InkWell(
        radius: 50,
        borderRadius: BorderRadius.circular(50),
        onTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.all(2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.transparentize
                ? widget.backgroundColor.withOpacity(.38)
                : widget.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              widget.icon,
              color: widget.iconColor,
              size: 24,
            ),
          ),
        ),
      );
}
