import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/models/wallpaper.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:provider/provider.dart';

class WallpaperCard extends StatelessWidget {
  final Wallpaper wallpaper;

  const WallpaperCard({
    required this.wallpaper,
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<WallpaperViewModel>(
      builder: (context, wallpaperViewModel, _) => GestureDetector(
            onLongPress: () {
              wallpaperViewModel.defSelectedWallpaper = wallpaper;
            },
            onTap: () {
              wallpaperViewModel.defSelectedWallpaper = wallpaper;
            },
            child: Hero(
              tag: wallpaperViewModel.selectedWallaper.src.large2x,
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
                  image: DecorationImage(
                    filterQuality: FilterQuality.high,
                    colorFilter: ColorFilter.mode(
                      AppColors.darkColor.withOpacity(.08),
                      BlendMode.overlay,
                    ),
                    image: CachedNetworkImageProvider(
                      wallpaper.src.large,
                    ),
                    fit: BoxFit.cover,
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
            ),
          ));
}
