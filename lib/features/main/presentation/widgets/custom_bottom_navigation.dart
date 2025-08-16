import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wallinice/features/main/main.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  static const List<IconData> _icons = [
    Iconsax.search_normal,
    Iconsax.home,
    Iconsax.heart,
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Wrap(
          runAlignment: WrapAlignment.spaceBetween,
          runSpacing: 20,
          spacing: 50,
          children: List.generate(
            _icons.length,
            (index) => Transform.translate(
              // Elevate the middle (home) button
              offset: Offset(0, index == 1 ? -18 : 0),
              child: NavItem(
                icon: _icons[index],
                index: index,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
