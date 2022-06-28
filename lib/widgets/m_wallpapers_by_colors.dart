import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:provider/provider.dart';

mixin WallpapersByColorsMixin<T> {
  Widget setWallPaperCard(int index);

  Widget buildScreen(
          BuildContext context, WallpaperViewModel<T> wallpaperViewModel) =>
      Scaffold(
        backgroundColor: Theme.of(Get.context!).backgroundColor,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Iconsax.arrow_left_1,
              // size: 32,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            AppLocalizations.of(context)!.colors,
            style: TextStyles.textStyle.apply(
              color: Theme.of(context).textTheme.bodyText1!.color,
              fontSizeDelta: 3,
            ),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) =>
              NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollNotification) {
              wallpaperViewModel.searchPageMaxScrollExtent =
                  scrollNotification.metrics.maxScrollExtent;

              return false;
            },
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              controller:
                  wallpaperViewModel.wallpapersByColorPageScrollController,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 18,
              ),
              children: [
                if (wallpaperViewModel.filteredWallpapersByColor.isNotEmpty)
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      /* LogUtils.log(
                              "SCROLL EXTENT: ${notification.metrics.pixels}");
                      */
                      return false;
                    },
                    child: MasonryGrid(
                      staggered: true,
                      column: 3,
                      children: List.generate(
                        wallpaperViewModel.filteredWallpapersByColor.length,
                        (i) => SizedBox(
                          height: Get.height * (i % 2 == 0 ? .25 : .3),
                          child: setWallPaperCard(i),
                        ),
                      ).toList(),
                    ),
                  )
                else
                  Image.asset(
                    'assets/images/empty-${themeProvider.currentTheme}.png',
                    fit: BoxFit.contain,
                  ),
              ],
            ),
          ),
        ),
      );
}
