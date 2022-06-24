import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:mobile/models/wallhaven/wallpaper.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/views/base_view.dart';
import 'package:mobile/widgets/w_wallpaper_tag.dart';
import 'package:mobile/widgets/w_wh_wallpaper_card.dart';
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
  Widget build(BuildContext context) => BaseView<WallpaperViewModel<WallPaper>>(
        key: UniqueKey(),
        vmBuilder: (context) =>
            Provider.of<WallpaperViewModel<WallPaper>>(context),
        builder: buildScreen,
      );

  Widget buildScreen(
    BuildContext context,
    WallpaperViewModel<WallPaper> wallpaperViewModel,
  ) {
    final progress = wallpaperViewModel.pageController.hasClients
        ? (wallpaperViewModel.pageController.page ?? 0)
        : 0;

    return Stack(
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaY: 18,
            sigmaX: 18,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: Constants.kDuration),
            child: Container(
              key: UniqueKey(),
              height: Get.height,
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
                        .wallpapers[selectedWallpaperIndex].thumbs!.large,
                    cacheKey: wallpaperViewModel
                        .wallpapers[selectedWallpaperIndex].thumbs!.large,
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
                      /*wallpaperViewModel
                          .wallpapers[selectedWallpaperIndex].category!,*/
                      AppLocalizations.of(context)!.browse_awesome_wallpapers,
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

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(
                              milliseconds: Constants.kDuration,
                            ),
                            top: isTheSelectedWallpaper ? -12 : 0,
                            left: 0,
                            right: 0,

                            child: AnimatedScale(
                              curve: Curves.fastLinearToSlowEaseIn,
                              scale: isTheSelectedWallpaper ? 1.01 : .92,
                              duration: const Duration(
                                  milliseconds: Constants.kDuration * 2),
                              child: AnimatedAlign(
                                curve: Curves.fastLinearToSlowEaseIn,
                                duration: const Duration(
                                  microseconds: Constants.kDuration * 2,
                                ),
                                alignment: isTheSelectedWallpaper
                                    ? Alignment.bottomCenter
                                    : const Alignment(0, -1.5),
                                child: WhWallpaperCard(
                                  key: UniqueKey(),
                                  wallPaper: wallpaper,
                                ),
                              ),
                            ),
                          ),
                        ],
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
