import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/views/base_view.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../utils/colors.dart';

class WallpaperDetailScreen extends StatefulWidget {
  const WallpaperDetailScreen({Key? key}) : super(key: key);

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen> {
  late DraggableScrollableController scrollableController;
  double dragRatio = 0.0;

  @override
  void initState() {
    scrollableController = DraggableScrollableController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        key: UniqueKey(),
        vmBuilder: (context) => Provider.of<WallpaperViewModel>(context),
        builder: buildScreen);
  }

  Widget buildScreen(
          BuildContext context, WallpaperViewModel wallpaperViewModel) =>
      Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Hero(
              tag: wallpaperViewModel.selectedWallaper.src.large2x,
              child: Container(
                key: UniqueKey(),
                width: double.infinity,
                height: Get.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      AppColors.darkColor.withOpacity(.49),
                      BlendMode.overlay,
                    ),
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      wallpaperViewModel.selectedWallaper.src.large2x,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 36.0,
                left: 12,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Iconsax.arrow_left_1,
                    size: 30,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ),

            Positioned.fill(
              // alignment: Alignment(0,2),
              // duration: Duration(seconds: Constants.kDuration),
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedPadding(
                duration: Duration(seconds: Constants.kDuration),
                padding: const EdgeInsets.only(
                  top: 36.0,
                  left: 12,
                  right: 12,
                  bottom: 0,
                ),
                child: NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    print("${notification.extent}");

                    dragRatio = (notification.extent - notification.minExtent) /
                        (notification.maxExtent - notification.minExtent);

                    return false;
                  },
                  child: DraggableScrollableSheet(
                    controller: scrollableController,
                    expand: true,
                    initialChildSize: .07,
                    maxChildSize: .33,
                    minChildSize: .07,
                    builder: (context, controller) => SingleChildScrollView(
                      controller: controller,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Constants.kBorderRadius * 2),
                          topRight:
                              Radius.circular(Constants.kBorderRadius * 2),
                          bottomLeft: Radius.circular(
                              dragRatio == 1 ? Constants.kBorderRadius * 2 : 0),
                          bottomRight: Radius.circular(
                              dragRatio == 1 ? Constants.kBorderRadius * 2 : 0),
                        ),
                        child: AnimatedContainer(
                          duration: Duration(seconds: Constants.kDuration),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: dragRatio == 1
                                ? Theme.of(context)
                                    .backgroundColor
                                    .withOpacity(0)
                                : Theme.of(context)
                                    .backgroundColor
                                    .withOpacity(1),
                            borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(Constants.kBorderRadius * 2),
                              topRight:
                                  Radius.circular(Constants.kBorderRadius * 2),
                              bottomLeft: Radius.circular(
                                dragRatio == 1
                                    ? Constants.kBorderRadius * 2
                                    : 0,
                              ),
                              bottomRight: Radius.circular(dragRatio == 1
                                  ? Constants.kBorderRadius * 2
                                  : 0),
                            ),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaY: dragRatio * 15,
                              sigmaX: dragRatio * 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                buildDraggableControlButton(),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "Photographe: ${wallpaperViewModel.selectedWallaper.photographer}",
                                  style: TextStyles.textStyle.apply(
                                    fontWeightDelta: 4,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color!,
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    buildActionButton(Iconsax.document_download,
                                        () {}, 'Telecharger'),
                                    buildActionButton(Iconsax.paintbucket,
                                        () {}, 'Telecharger'),
                                    buildActionButton(
                                        Iconsax.like, () {}, 'Telecharger'),
                                  ],
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // AnimatedCrossFade(firstChild: null,
          ],
        ),
      );

  Widget buildActionButton(
    IconData iconData,
    VoidCallback onPress,
    String text,
  ) =>
      Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Constants.kBorderRadius * 100),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(.2),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaY: 10,
                  sigmaX: 10,
                ),
                child: Icon(iconData,
                    color: Theme.of(context).textTheme.bodyText1!.color!),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: TextStyles.textStyle.apply(
              color: TinyColor(Theme.of(context).textTheme.bodyText1!.color!)
                  .tint()
                  .darken()
                  .color,
              fontSizeDelta: -6,
              fontWeightDelta: 5,
            ),
          )
        ],
      );

  Widget buildDraggableControlButton() => AnimatedSwitcher(
        duration: Duration(
          seconds: Constants.kDuration,
        ),
        child: IconButton(
          onPressed: () {
            scrollableController.animateTo(
              dragRatio == 1 ? .07 : .33,
              duration: Duration(
                milliseconds: Constants.kDuration,
              ),
              curve: Curves.easeIn,
            );
          },
          icon: Icon(
            dragRatio == 1
                ? Icons.expand_more_outlined
                : Icons.expand_less_outlined,
            size: 30,
            color: Theme.of(context).textTheme.bodyText1!.color!,
          ),
        ),
      );
}
