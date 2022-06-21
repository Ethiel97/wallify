import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

mixin WallpaperCard<T> {
  late final T value;

  String get imgUrl => value.toString();

  Widget buildCard(BuildContext context) => Hero(
        tag: imgUrl,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Constants.kBorderRadius),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: imgUrl,
            cacheKey: imgUrl,
            imageBuilder: (context, imageProvider) => Container(
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
                  fit: BoxFit.fitHeight,
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 8),
                    blurRadius: 16,
                    color: AppColors.darkColor.withOpacity(.08),
                  ),
                ],
              ),
            ),
            placeholder: (context, string) => loader,
          ),
        ),
      );

  Widget get loader => Shimmer(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            Constants.kBorderRadius,
          ),
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
                  color: AppColors.darkColor.withOpacity(.04),
                ),
              ],
            ),
          ),
        ),
      );
}
