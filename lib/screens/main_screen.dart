import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/providers/navigation_provider.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/screens/wallhaven/fav_screen.dart';
import 'package:mobile/screens/wallhaven/home_screen.dart';
import 'package:mobile/utils/app_router.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/widgets/w_nav_item.dart';
import 'package:mobile/widgets/w_text_button.dart';
import 'package:provider/provider.dart';

import 'wallhaven/search_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  List<Widget> get screens => [
        const SearchScreen(),
        const HomeScreen(),
        const FavScreen(),
      ];

  List<IconData> get icons => [
        Iconsax.search_normal,
        Iconsax.home1,
        Iconsax.heart_tick,
      ];

  @override
  Widget build(BuildContext context) =>
      Consumer3<NavigationProvider, ThemeProvider, AuthProvider>(
        builder:
            (context, navigationProvider, themeProvider, authProvider, _) =>
                Scaffold(
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
                key: UniqueKey(),
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
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 38.0,
                    left: 10,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (authProvider.status == Status.authenticated) {
                        showAccountModalBottomSheet(context, authProvider);
                      } else {
                        Get.toNamed(login);
                      }
                    },
                    icon: Icon(
                      Iconsax.user_octagon,
                      size: 28,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 38.0,
                    right: 10,
                  ),
                  child: IconButton(
                    onPressed: () => themeProvider.toggleMode(),
                    icon: Icon(
                      themeProvider.currentTheme == AppTheme.dark.description
                          ? Iconsax.sun_15
                          : Iconsax.moon5,
                      size: 28,
                    ),
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  void showAccountModalBottomSheet(
      BuildContext context, AuthProvider authProvider) {
    Get.bottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Constants.kBorderRadius),
          topRight: Radius.circular(Constants.kBorderRadius),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(Constants.kBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              radius: 50,
              child: Text(
                authProvider.authUser!.username!.toUpperCase().substring(0, 1),
                style: TextStyles.textStyle.apply(
                    fontWeightDelta: 5,
                    fontSizeDelta: 20,
                    color: Theme.of(context).backgroundColor),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              authProvider.authUser!.username!,
              textAlign: TextAlign.center,
              style: TextStyles.textStyle.apply(
                fontWeightDelta: 5,
                fontSizeDelta: 4,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.user,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(
                    authProvider.authUser!.email!,
                    style: TextStyles.textStyle.apply(
                      fontSizeDelta: 2,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                Get.back();
                authProvider.confirmLogout();
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Constants.kBorderRadius,
                  ),
                ),
                fixedSize: Size(Get.width, 50),
              ),
              child: Text(
                'Logout',
                style: TextStyles.textStyle.apply(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSizeDelta: 2,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            WTextButton(
              onPress: () {
                Get.back();
                authProvider.confirmAccountDeletion();
              },
              text: AppLocalizations.of(context)!.delete_account,
            ),
          ],
        ),
      ),
    );
  }
}
