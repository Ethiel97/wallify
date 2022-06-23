import 'package:flutter/material.dart';
import 'package:mobile/providers/navigation_provider.dart';
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
  Widget build(BuildContext context) => Consumer<NavigationProvider>(
        builder: (context, navigationProvider, _) => AnimatedScale(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(
            milliseconds: Constants.kDuration,
          ),
          scale: navigationProvider.currentIndex == index ? 1.03 : 1.0,
          child: AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkColor.withOpacity(.4),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                )
              ],
              borderRadius: BorderRadius.circular(100),
              color: navigationProvider.currentIndex == index
                  ? Theme.of(context).textTheme.bodyText1?.color
                  : TinyColor(Theme.of(context).backgroundColor)
                      .lighten(4)
                      .color
                      .withOpacity(.85),
            ),
            duration: const Duration(milliseconds: 300),
            child: navigationProvider.currentIndex == index
                ? RadiantGradientMask(
                    child: buildIconButton(navigationProvider),
                  )
                : buildIconButton(navigationProvider),
          ),
        ),
      );

  IconButton buildIconButton(NavigationProvider navigationProvider) =>
      IconButton(
        icon: Icon(
          size: navigationProvider.currentIndex == index ? 28 : 24,
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
        shaderCallback: (bounds) => const LinearGradient(
          // center: Alignment.center,
          // radius: .4,
          colors: [
            Color(0xff12c2e9),
            Color(0xffc471ed),
            // Color(0xfff64f59),
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds),
        child: child,
      );
}
