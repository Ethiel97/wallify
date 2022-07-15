import 'package:flutter/material.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/providers/navigation_provider.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor2/tinycolor2.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final int index;

  const NavItem({
    required this.icon,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer3<NavigationProvider, ThemeProvider, AuthProvider>(
        builder:
            (context, navigationProvider, themeProvider, authProvider, _) =>
                AnimatedScale(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(
            milliseconds: Constants.kDuration,
          ),
          scale: navigationProvider.currentIndex == index ? 1.01 : .92,
          child: AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkColor.withOpacity(.02),
                  offset: const Offset(0, 20),
                  blurRadius: 40,
                  spreadRadius: 30,
                ),
              ],
              borderRadius: BorderRadius.circular(Constants.kBorderRadius * 10),
              color: navigationProvider.currentIndex == index
                  ? themeProvider.currentTheme == AppTheme.dark.description
                      ? Theme.of(context).textTheme.bodyText1?.color
                      : AppColors.whiteBackgroundColor
                  : TinyColor(Theme.of(context).backgroundColor)
                      .lighten(4)
                      .color
                      .withOpacity(.9),
            ),
            duration: const Duration(milliseconds: 300),
            child: navigationProvider.currentIndex == index
                ? RadiantGradientMask(
                    child: buildIconButton(navigationProvider, authProvider),
                  )
                : buildIconButton(navigationProvider, authProvider),
          ),
        ),
      );

  IconButton buildIconButton(
          NavigationProvider navigationProvider, AuthProvider authProvider) =>
      IconButton(
        icon: Icon(
          size: navigationProvider.currentIndex == index ? 32 : 24,
          icon,
        ),
        onPressed: () {
          navigationProvider.currentIndex = index;
        },
      );
}

class RadiantGradientMask extends StatelessWidget {
  const RadiantGradientMask({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
          // center: Alignment.center,
          // radius: .4,
          colors: [
            // Theme.of(context).primaryColor,
            // Theme.of(context).colorScheme.secondary,
            AppColors.primaryColor,
            AppColors.accentColor,
            // Colors.blueGrey,
            // Color(0xfff64f59),
          ],

          tileMode: TileMode.mirror,
        ).createShader(bounds),
        child: child,
      );
}
