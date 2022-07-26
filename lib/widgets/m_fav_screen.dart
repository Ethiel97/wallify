import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/widgets/w_empty_placeholder.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor2/tinycolor2.dart';

mixin FavScreenMixin<T> {
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
          builder: (context, themeProvider, _) => ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 18,
            ),
            children: [
              const SizedBox(
                height: 48,
              ),
              // TODO implement slivers
              Text(
                AppLocalizations.of(context)!.my_favorite,
                style: TextStyles.textStyle.apply(
                  color: Theme.of(context).textTheme.bodyText1!.color!,
                  fontSizeDelta: 4,
                  fontWeightDelta: 6,
                ),
                textAlign: TextAlign.center,
              ),
              (wallpaperViewModel.savedWallpapers.isNotEmpty)
                  ? MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      shrinkWrap: true,
                      controller: wallpaperViewModel.searchPageScrollController,
                      crossAxisSpacing: 4,
                      itemCount: wallpaperViewModel.savedWallpapers.length,
                      itemBuilder: (context, i) => SizedBox(
                        height: Get.height * ((i % 2) == 0 ? .26 : .32),
                        child: setWallPaperCard(i),
                      ),
                    )
                  : EmptyPlaceholder(
                      text: AppLocalizations.of(context)!.no_saved_image,
                    )
            ],
          ),
        ),
      );
}
