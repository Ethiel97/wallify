import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

// import 'package:masonry_grid/masonry_grid.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:provider/provider.dart';

mixin WallpapersByColorsMixin<T> {
  Widget setWallPaperCard(int index);

  Color get selectedColor => Colors.black54;

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
            onPressed: () {
              Get.back();
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.colors,
                style: TextStyles.textStyle.apply(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSizeDelta: 3,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Container(
                  color: selectedColor,
                  // radius: Constants.kBorderRadius,
                  // size: 20,
                ),
              ),
            ],
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
            child: (wallpaperViewModel.filteredWallpapersByColor.isNotEmpty)
                ? MasonryGridView.count(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 18,
                    ),
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    shrinkWrap: true,
                    controller: wallpaperViewModel
                        .wallpapersByColorPageScrollController,
                    crossAxisSpacing: 4,
                    itemCount:
                        wallpaperViewModel.filteredWallpapersByColor.length,
                    itemBuilder: (context, i) {
                      return SizedBox(
                        height: Get.height * (i % 2 == 0 ? .25 : .3),
                        child: setWallPaperCard(i),
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/empty-${themeProvider.currentTheme}.png',
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      );
}
