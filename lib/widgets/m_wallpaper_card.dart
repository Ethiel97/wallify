import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

mixin WallpaperCard<T> {
  late final T value;

  String get imgUrl => value.toString();

  String get cacheKey => value.toString();

  Widget buildCard(BuildContext context) => Hero(
        tag: imgUrl,
        transitionOnUserGestures: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Constants.kBorderRadius),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: imgUrl,
            cacheKey: cacheKey,
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
                  filterQuality: FilterQuality.high,
                  colorFilter: ColorFilter.mode(
                    AppColors.darkColor.withOpacity(.3),
                    BlendMode.overlay,
                  ),
                  image: CachedNetworkImageProvider(
                    // wallpaper.src.large,
                    imgUrl,
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 20,
                    color: Theme.of(context).backgroundColor.withOpacity(.04),
                  ),
                ],
              ),
            ),
            placeholder: (context, string) => loader,
          ),
        ),
      );

  Widget get loader => ClipRRect(
        borderRadius: BorderRadius.circular(
          Constants.kBorderRadius,
        ),
        child: Shimmer(
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
                  offset: const Offset(0, 8),
                  blurRadius: 16,
                  color:
                      Theme.of(Get.context!).backgroundColor.withOpacity(.08),
                ),
              ],
            ),
          ),
        ),
      );
}
