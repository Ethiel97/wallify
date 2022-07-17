import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/providers/navigation_provider.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:tinycolor2/tinycolor2.dart';

mixin WallpaperCard<T> {
  late final T value;

  bool errorWhenLoadingImage = false;

  String get imgUrl => value.toString();

  String get cacheKey => value.toString();

  Widget buildCard(BuildContext context) => Consumer<NavigationProvider>(
        builder: (context, navigationProvider, _) => Hero(
          tag: imgUrl,
          transitionOnUserGestures: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Constants.kBorderRadius),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: imgUrl,
              cacheKey: cacheKey,
              memCacheHeight: (Get.height * .5).toInt(),
              memCacheWidth: (Get.width * .9).toInt(),
              errorWidget: (context, error, dynamic) => loader,
              imageBuilder: (context, imageProvider) => Container(
                height: Get.height * .7,
                width: Get.width,
                margin: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    Constants.kBorderRadius,
                  ),
                  image: DecorationImage(
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.low,
                    // filterQuality: FilterQuality.high,
                    colorFilter: ColorFilter.mode(
                      AppColors.darkColor.withOpacity(.3),
                      BlendMode.overlay,
                    ),
                    image: CachedNetworkImageProvider(
                      // wallpaper.src.large,
                      imgUrl,
                      cacheKey: cacheKey,
                      errorListener: () {
                        errorWhenLoadingImage = true;
                      },
                      maxHeight: (Get.height * .7).toInt(),
                      maxWidth: Get.width.toInt(),
                      scale: .2,
                      // maxHeight: 200,
                      // maxWidth: 100
                    ),
                    fit: BoxFit.cover,
                    onError: (object, stackTrace) => {
                      errorWhenLoadingImage = true,
                    },
                    scale: .2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 8),
                      blurRadius: 16,
                      spreadRadius: 8,
                      color: Theme.of(context)
                          .backgroundColor
                          .toTinyColor()
                          .lighten()
                          .color
                          .withOpacity(.003),
                    ),
                  ],
                ),
              ),
              placeholder: (context, string) => loader,
            ),
          ),
        ),
      );

  Widget get loader => ClipRRect(
        borderRadius: BorderRadius.circular(
          Constants.kBorderRadius,
        ),
        child: Shimmer(
          color: Provider.of<ThemeProvider>(Get.context!, listen: false)
                      .currentTheme ==
                  AppTheme.light.description
              ? Theme.of(Get.context!).colorScheme.secondary
              : Theme.of(Get.context!).primaryColor,
          child: Container(
            height: Get.height * .7,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Constants.kBorderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 16),
                  blurRadius: 32,
                  spreadRadius: 64,
                  color:
                      Theme.of(Get.context!).backgroundColor.withOpacity(.04),
                ),
              ],
            ),
          ),
        ),
      );
}
