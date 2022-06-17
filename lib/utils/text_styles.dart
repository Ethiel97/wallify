import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/utils/colors.dart';

mixin TextStyles {
  static TextStyle get textStyle => GoogleFonts.sora(
        fontSize: 17,
        fontWeight: FontWeight.normal,
        color:
            WidgetsBinding.instance.window.platformBrightness == Brightness.dark
                ? AppColors.darkColor
                : Colors.white,
        decoration: TextDecoration.none,
      );

  static TextStyle get secondaryTextStyle => GoogleFonts.epilogue(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.none,
      );
}
