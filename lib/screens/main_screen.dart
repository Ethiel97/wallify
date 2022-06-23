import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/screens/wallhaven/home_screen.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import '../widgets/w_nav_item.dart';
import 'wallhaven/search_screen.dart';

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
                alignment: Alignment.center,
                children: [
                  screens[navigationProvider.currentIndex],
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Wrap(
                    // mainAxisSize: MainAxisSize.max,
                    runAlignment: WrapAlignment.spaceBetween,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 20.0,
                    spacing: 50,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...List.generate(
                        3,
                        (index) => Transform.translate(
                          offset: Offset(0, index == 1 ? -18 : 0),
                          child: NavItem(
                            icon: icons[index],
                            index: index,
                          ),
                        ),
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
