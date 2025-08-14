import 'package:flutter/material.dart';

class SizeConfig {
  static const double _designWidth = 375;
  static const double _designHeight = 812;

  static double getProportionateScreenWidth(
    BuildContext context,
    double inputWidth,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return (inputWidth / _designWidth) * screenWidth;
  }

  static double getProportionateScreenHeight(
    BuildContext context,
    double inputHeight,
  ) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return (inputHeight / _designHeight) * screenHeight;
  }

  static bool isTablet(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.shortestSide >= 600;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  static EdgeInsets paddingOf(BuildContext context) {
    return MediaQuery.paddingOf(context);
  }

  static EdgeInsets viewInsetsOf(BuildContext context) {
    return MediaQuery.viewInsetsOf(context);
  }
}

// Extension methods for easier usage
extension SizeExtensions on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  Size get screenSize => MediaQuery.sizeOf(this);
  Orientation get orientation => MediaQuery.orientationOf(this);
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  double proportionateWidth(double inputWidth) =>
      SizeConfig.getProportionateScreenWidth(this, inputWidth);

  double proportionateHeight(double inputHeight) =>
      SizeConfig.getProportionateScreenHeight(this, inputHeight);
}
