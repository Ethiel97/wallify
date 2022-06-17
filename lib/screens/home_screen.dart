import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/views/base_view.dart';
import 'package:mobile/widgets/w_wallpaper_card.dart';
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

  late Animation slideAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: Constants.kDuration * 2,
      ),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, .5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );

    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      key: UniqueKey(),
      vmBuilder: (context) => Provider.of<WallpaperViewModel>(context),
      builder: buildScreen,
    );
  }

  Widget buildScreen(
    BuildContext context,
    WallpaperViewModel wallpaperViewModel,
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
            duration: Duration(milliseconds: Constants.kDuration),
            child: Container(
              key: UniqueKey(),
              width: double.infinity,
              height: Get.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    AppColors.darkColor.withOpacity(.79),
                    BlendMode.overlay,
                  ),
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    wallpaperViewModel
                        .wallpapers[selectedWallpaperIndex].src.large2x,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 65,
          // alignment: Alignment.bottomCenter,
          child: AnimatedSwitcher(
            duration: Duration(
              milliseconds: Constants.kDuration,
            ),
            child: Column(
              children: [
                Text(
                  Constants.appName,
                  style: TextStyles.textStyle.apply(
                      fontSizeDelta: 20,
                      fontWeightDelta: 20,
                      color: Theme.of(context).textTheme.bodyText1?.color),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Explore awesome wallpapers",
                  style: TextStyles.textStyle.apply(
                    fontSizeDelta: -1.2,
                    color:
                        TinyColor(Theme.of(context).textTheme.bodyText1!.color!)
                            .tint()
                            .darken()
                            .color,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSlide(
          offset: slideAnimation.value,
          duration: Duration(milliseconds: Constants.kDuration * 2),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.zero,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            ),
            backgroundColor: Colors.transparent,
            body: PageView.builder(
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

                // print(index);
                if (index == Constants.perPageResults) {
                  print("PAGINATING");
                  // wallpaperViewModel.paginate();
                }

                return AnimatedPadding(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: Duration(milliseconds: Constants.kDuration * 2),
                  padding: EdgeInsets.only(
                    bottom: isTheSelectedWallpaper ? 12 : 0,
                  ),
                  child: AnimatedScale(
                    curve: Curves.fastLinearToSlowEaseIn,
                    scale: isTheSelectedWallpaper ? 1.02 : 1.0,
                    duration: Duration(milliseconds: Constants.kDuration * 2),
                    child: AnimatedAlign(
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: Duration(
                        microseconds: Constants.kDuration * 2,
                      ),
                      alignment: isTheSelectedWallpaper
                          ? Alignment.bottomCenter
                          : const Alignment(0, 1.3),
                      child: WallpaperCard(
                        key: UniqueKey(),
                        wallpaper: wallpaper,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
