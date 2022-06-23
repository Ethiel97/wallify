import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/widgets/w_wallpaper_tag.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor2/tinycolor2.dart';

mixin SearchMixin<T> {
  void search() {
    var viewModel =
        Provider.of<WallpaperViewModel<T>>(Get.context!, listen: false);

    if (viewModel.searchQueryTEC.text.isNotEmpty) {
      viewModel.searchWallpapers(viewModel.searchQueryTEC.text, delay: 1200);
    }
  }

  Widget setWallPaperCard(int index);

  Widget buildScreen(
          BuildContext context, WallpaperViewModel<T> wallpaperViewModel) =>
      Scaffold(
        backgroundColor: Theme.of(Get.context!).backgroundColor,
        extendBodyBehindAppBar: false,
        body: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) => ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 18,
            ),
            children: [
              const SizedBox(
                height: 48,
              ),
              Text(
                Constants.appName.toLowerCase(),
                textAlign: TextAlign.center,
                style: TextStyles.textStyle.apply(
                  fontWeightDelta: 5,
                  fontSizeDelta: 2,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              searchField(wallpaperViewModel),
              const SizedBox(
                height: 36,
              ),
              SizedBox(
                height: Get.height / 20,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: ListView.builder(
                    itemCount: Constants.tags.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => WWallPaperTag(
                      viewModel: wallpaperViewModel,
                      tag: Constants.tags[index],
                    ),
                  ),
                ),
              ),
              wallpaperViewModel.filteredWallpapers.isNotEmpty
                  ? MasonryGrid(
                      staggered: true,
                      column: 2,
                      children: List.generate(
                        wallpaperViewModel.filteredWallpapers.length,
                        (i) => SizedBox(
                          height: Get.height * (i % 2 == 0 ? .25 : .3),
                          child: setWallPaperCard(i),
                        ),
                      ).toList(),
                    )
                  : Image.asset(
                      'assets/images/empty-${themeProvider.currentTheme}.png',
                      fit: BoxFit.contain,
                    ),
            ],
          ),
        ),
      );

  Widget searchField(WallpaperViewModel wallpaperViewModel) => Container(
        // padding: const EdgeInsets.
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TinyColor(Theme.of(Get.context!).backgroundColor)
              .color
              .lighten()
              .withOpacity(.45),
          borderRadius: BorderRadius.circular(
            Constants.kBorderRadius,
          ),
        ),
        child: TextField(
          controller: wallpaperViewModel.searchQueryTEC,
          onSubmitted: (text) {
            search();
          },
          /*onChanged: (text) async {
            search(text);
          },*/
          decoration: InputDecoration(
            prefixIcon: Icon(
              Iconsax.search_normal,
              color: Theme.of(Get.context!).textTheme.bodyText1?.color,
              size: 18,
            ),
            border: InputBorder.none,
            hintText: AppLocalizations.of(Get.context!)!.search_here,
            hintStyle: TextStyle(
              color: Theme.of(Get.context!).textTheme.bodyText1?.color,
              fontSize: 13,
            ),
          ),
        ),
      );
}
