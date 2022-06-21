import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/models/pexels/wallpaper.dart' as px;
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/views/base_view.dart';
import 'package:mobile/widgets/w_px_wallpaper_card.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor2/tinycolor2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedWallpaperIndex = 0;

  late AnimationController animationController;

  // late Animation slideAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: Constants.kDuration * 2,
      ),
    );

    /*slideAnimation = Tween<Offset>(
      begin: const Offset(0, .5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );*/

    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BaseView<WallpaperViewModel<px.WallPaper>>(
        key: UniqueKey(),
        vmBuilder: (context) =>
            Provider.of<WallpaperViewModel<px.WallPaper>>(context),
        builder: buildScreen,
      );

  Widget buildScreen(
    BuildContext context,
    WallpaperViewModel<px.WallPaper> wallpaperViewModel,
  ) {
    final progress = wallpaperViewModel.pageController.hasClients
        ? (wallpaperViewModel.pageController.page ?? 0)
        : 0;

    return Stack(
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaY: 25,
            sigmaX: 25,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: Constants.kDuration),
            child: Container(
              key: UniqueKey(),
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    AppColors.darkColor.withOpacity(.90),
                    BlendMode.overlay,
                  ),
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    wallpaperViewModel
                        .wallpapers[selectedWallpaperIndex].src.large2x,
                    cacheKey: wallpaperViewModel
                        .wallpapers[selectedWallpaperIndex].src.large2x,
                  ),
                ),
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: Constants.kDuration,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      Constants.appName.toLowerCase(),
                      style: TextStyles.textStyle.apply(
                          fontSizeDelta: 14,
                          fontWeightDelta: 20,
                          color: Theme.of(context).textTheme.bodyText1?.color),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Explore awesome wallpapers",
                      style: TextStyles.textStyle.apply(
                        fontSizeDelta: -4,
                        color: TinyColor(
                                Theme.of(context).textTheme.bodyText1!.color!)
                            .tint()
                            .darken()
                            .color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: Get.height / 20,
                child: ListView.builder(
                  itemCount: Constants.tags.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(
                      right: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Theme.of(context).textTheme.bodyText1!.color!,
                      ),
                      borderRadius: BorderRadius.circular(
                        Constants.kBorderRadius,
                      ),
                    ),
                    child: Text(
                      Constants.tags[index],
                      style: TextStyles.textStyle.apply(
                        fontSizeDelta: -7,
                        fontWeightDelta: 5,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Flexible(
                child: SizedBox(
                  height: Get.height * .71,
                  child: PageView.builder(
                    controller: wallpaperViewModel.pageController,
                    physics: const ClampingScrollPhysics(),
                    itemCount: wallpaperViewModel.wallpapers.length,
                    itemBuilder: (context, index) {
                      final wallpaper = wallpaperViewModel.wallpapers[index];

                      final isTheSelectedWallpaper =
                          progress > index - 0.5 && progress < index + 0.5;

                      if (isTheSelectedWallpaper) {
                        selectedWallpaperIndex = index;
                      }

                      return AnimatedPadding(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(
                            milliseconds: Constants.kDuration * 2),
                        padding: EdgeInsets.only(
                            bottom: isTheSelectedWallpaper ? 36 : 0,
                            left: 4,
                            right: 4),
                        child: AnimatedScale(
                          curve: Curves.fastLinearToSlowEaseIn,
                          scale: isTheSelectedWallpaper ? 1.05 : 1.0,
                          duration: const Duration(
                              milliseconds: Constants.kDuration * 2),
                          child: AnimatedAlign(
                            curve: Curves.fastLinearToSlowEaseIn,
                            duration: const Duration(
                              microseconds: Constants.kDuration * 2,
                            ),
                            alignment: isTheSelectedWallpaper
                                ? Alignment.bottomCenter
                                : const Alignment(0, -1.8),
                            child: PxWallPaperCard(
                              key: UniqueKey(),
                              wallPaper: wallpaper,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
