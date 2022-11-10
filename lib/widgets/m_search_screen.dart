import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/infrastructure/observable.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/providers/wallpaper_provider.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/widgets/w_color_tag.dart';
import 'package:mobile/widgets/w_empty_placeholder.dart';
import 'package:mobile/widgets/w_wallpaper_tag.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor2/tinycolor2.dart';

mixin SearchMixin<T> {
  late WallpaperViewModel viewModel;

  bool get canSearchByColor => true;

  Future<void> search() async {
    viewModel = Provider.of<WallpaperViewModel<T>>(Get.context!, listen: false);

    if (viewModel.searchQueryTEC.text.trim().isNotEmpty) {
      viewModel.searchWallpapers(viewModel.searchQueryTEC.text, delay: 1200);
    }
  }

  Widget setWallPaperCard(int index);

  Widget buildScreen(
          BuildContext context, WallpaperViewModel<T> wallpaperViewModel) =>
      Scaffold(
        backgroundColor: Theme.of(Get.context!)
            .backgroundColor
            .toTinyColor()
            .shade(15)
            .color
            .withOpacity(.06),
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
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 18,
              ),
              children: [
                const SizedBox(
                  height: 100,
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

                // TODO implement slivers
                if (canSearchByColor) ...[
                  const SizedBox(
                    height: 24,
                  ),
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
                    height: Get.height / 20,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
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
                ],
                const SizedBox(
                  height: 36,
                ),
                SizedBox(
                  height: Get.height / 20,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 0.0),
                    controller: wallpaperViewModel.tagsListScrollController,
                    itemCount: Constants.tags.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => FittedBox(
                      child: WWallPaperTag(
                        viewModel: wallpaperViewModel,
                        tag: Constants.tags[index],
                      ),
                    ),
                  ),
                ),
                (wallpaperViewModel.filteredWallpapers.isNotEmpty)
                    ? MasonryGridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        shrinkWrap: true,
                        controller:
                            wallpaperViewModel.searchPageScrollController,
                        crossAxisSpacing: 4,
                        itemCount: wallpaperViewModel.filteredWallpapers.length,
                        itemBuilder: (context, i) => SizedBox(
                          height: Get.height * ((i % 2) == 0 ? .25 : .3),
                          child: setWallPaperCard(i),
                        ),
                      )
                    : EmptyPlaceholder(
                        text: AppLocalizations.of(context)!
                            .no_results_for_your_search,
                      ),
              ],
            ),
          ),
        ),
      );

  Widget searchField(WallpaperViewModel wallpaperViewModel) => Row(
        children: [
          Consumer<WallpaperProviderObserver>(
              builder: (context, wallpaperProvider, _) {
            return Expanded(
              child: Container(
                // padding: const EdgeInsets.
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: TinyColor(Theme.of(Get.context!).backgroundColor)
                      .color
                      .tint(Provider.of<ThemeProvider>(Get.context!,
                                      listen: false)
                                  .currentTheme ==
                              AppTheme.dark.description
                          ? 10
                          : 92)
                      .withOpacity(.55),
                  borderRadius: BorderRadius.circular(
                    Constants.kBorderRadius,
                  ),
                ),
                child: TextField(
                  style: TextStyles.textStyle.apply(
                    color: Theme.of(Get.context!).textTheme.bodyText1?.color,
                    fontSizeDelta: -5,
                    fontWeightDelta: 1,
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
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Get.bottomSheet(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 32,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(Constants.kBorderRadius),
                                topRight:
                                    Radius.circular(Constants.kBorderRadius),
                              ),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  Provider.of<Observable>(context,
                                          listen: false)
                                      .transform(WallPaperProvider
                                          .values[index].providerClass);
                                  Get.back();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 12),
                                  child: Text(
                                    WallPaperProvider.values[index].description,
                                    style: TextStyles.textStyle.apply(
                                      color: wallpaperProvider
                                                  .provider.description ==
                                              WallPaperProvider
                                                  .values[index].description
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Theme.of(Get.context!)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                    ),
                                  ),
                                ),
                              ),
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: WallPaperProvider.values.length,
                            ),
                          ),
                          backgroundColor:
                              Theme.of(Get.context!).backgroundColor,
                        );
                      },
                      icon: Icon(Iconsax.filter,
                          color:
                              Theme.of(Get.context!).textTheme.bodyText1?.color,
                          size: 20),
                    ),
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(Get.context!)!.search_here,
                    hintStyle: TextStyles.textStyle.apply(
                      color: TinyColor(
                        Theme.of(Get.context!).textTheme.bodyText1!.color!,
                      ).darken().tint().color,
                      fontSizeDelta: -2,
                    ),
                  ),
                ),
              ),
            );
          }),

/*
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
          ),
*/
        ],
      );
}
