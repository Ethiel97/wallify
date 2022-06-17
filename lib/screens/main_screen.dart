import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/search_screen.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import '../widgets/w_nav_item.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  List<Widget> get screens => [
        const SearchScreen(),
        const HomeScreen(),
        const HomeScreen(),
      ];

  List<IconData> get icons => [
        Iconsax.search_normal,
        Iconsax.home1,
        Iconsax.user,
      ];

  @override
  Widget build(BuildContext context) => Consumer<NavigationProvider>(
        builder: (context, navigationProvider, _) => Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: PreferredSize(
            preferredSize: Size.zero,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ),
          body: Stack(
            children: [
              IndexedStack(
                children: [
                  screens[navigationProvider.currentIndex],
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...List.generate(
                        3,
                        (index) => (NavItem(
                          icon: icons[index],
                          index: index,
                        )),
                      ).toList()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
