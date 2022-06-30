import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/widgets/w_color_tag.dart';
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
              controller: wallpaperViewModel.searchPageScrollController,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 18,
              ),
              children: [
                const SizedBox(
                  height: 48,
                ),
                /*Text(
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
                    ),*/
                searchField(wallpaperViewModel),
                const SizedBox(
                  height: 24,
                ),
                // TODO implement sliverlist
                Text(
                  AppLocalizations.of(context)!.color_tone,
                  style: TextStyles.textStyle.apply(
                    color: Theme.of(context).textTheme.bodyText1!.color!,
                    fontSizeDelta: -2,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: Get.height / 16,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 0.0),
                    controller: wallpaperViewModel.colorsListScrollController,
                    itemCount: Constants.colors.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => ColorTag<T>(
                      radius: Constants.kBorderRadius / 2,
                      size: 50,
                      color: Constants.colors[index],

                    ),
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                SizedBox(
                  height: Get.height / 18,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 0.0),
                    controller: wallpaperViewModel.tagsListScrollController,
                    itemCount: Constants.tags.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => WWallPaperTag(
                      viewModel: wallpaperViewModel,
                      tag: Constants.tags[index],
                    ),
                  ),
                ),
                if (wallpaperViewModel.filteredWallpapers.isNotEmpty)
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
                        wallpaperViewModel.filteredWallpapers.length,
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

  Widget searchField(WallpaperViewModel wallpaperViewModel) => Row(
        children: [
          Expanded(
            child: Container(
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
                style: TextStyles.textStyle.apply(
                  color: Theme.of(Get.context!).textTheme.bodyText1?.color,
                  fontSizeDelta: -4,
                ),
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
                  hintStyle: TextStyles.textStyle.apply(
                    color: TinyColor(
                            Theme.of(Get.context!).textTheme.bodyText1!.color!)
                        .darken()
                        .tint()
                        .color,
                    fontSizeDelta: -2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                width: .8,
                color: TinyColor(
                  Theme.of(Get.context!).textTheme.bodyText1!.color!,
                ).color,
              ),
              borderRadius: BorderRadius.circular(
                Constants.kBorderRadius,
              ),
              color: TinyColor(Theme.of(Get.context!).backgroundColor)
                  .color
                  .tint()
                  .withOpacity(.6),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Iconsax.filter_search,
                size: 20,
                color: Theme.of(Get.context!).textTheme.bodyText1?.color,
              ),
            ),
          )
        ],
      );
}
