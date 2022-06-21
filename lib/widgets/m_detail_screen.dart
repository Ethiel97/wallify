import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../utils/text_styles.dart';

mixin Details<T> {
  late final T value;

  late double dragRatio;

  late DraggableScrollableController scrollableController;

  String get imgUrl => value.toString();

  String get photographer => value.toString();

  List<Color> get colors => [];

  void download();

  void applyWallPaper();

  void save();

  Widget buildScreen(
          BuildContext context, WallpaperViewModel<T> wallpaperViewModel) =>
      Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Hero(
              tag: imgUrl,
              child: Container(
                key: UniqueKey(),
                width: double.infinity,
                height: Get.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      AppColors.darkColor.withOpacity(.59),
                      BlendMode.overlay,
                    ),
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      imgUrl,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 36.0, left: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(
                        Iconsax.arrow_left_1,
                        size: 30,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(
                        Iconsax.paintbucket,
                        size: 30,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ],
              ),
            ),

            Positioned.fill(
              // alignment: Alignment(0,2),
              // duration: Duration(seconds: Constants.kDuration),
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedPadding(
                duration: const Duration(seconds: Constants.kDuration),
                padding: const EdgeInsets.only(
                  top: 36.0,
                  left: 12,
                  right: 12,
                  bottom: 0,
                ),
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
                        topLeft:
                            const Radius.circular(Constants.kBorderRadius * 2),
                        topRight:
                            const Radius.circular(Constants.kBorderRadius * 2),
                        bottomLeft: Radius.circular(
                            dragRatio == 1 ? Constants.kBorderRadius * 2 : 0),
                        bottomRight: Radius.circular(
                            dragRatio == 1 ? Constants.kBorderRadius * 2 : 0),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(seconds: Constants.kDuration),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .backgroundColor
                              .withOpacity(dragRatio),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(
                                Constants.kBorderRadius * 2),
                            topRight: const Radius.circular(
                                Constants.kBorderRadius * 2),
                            bottomLeft: Radius.circular(
                              dragRatio == 1 ? Constants.kBorderRadius * 2 : 0,
                            ),
                            bottomRight: Radius.circular(dragRatio == 1
                                ? Constants.kBorderRadius * 2
                                : 0),
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaY: dragRatio * 25,
                            sigmaX: dragRatio * 25,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildDraggableControlButton(),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                "Photographe: ${photographer}",
                                maxLines: 1,
                                softWrap: true,
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
                                  buildActionButton(
                                    Iconsax.document_download,
                                    () {},
                                    'Telecharger',
                                  ),
                                  buildActionButton(
                                    Iconsax.paintbucket,
                                    () {},
                                    'Appliquer',
                                  ),
                                  buildActionButton(
                                    Iconsax.like,
                                    () {},
                                    'Enregistrer',
                                  ),
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
                color: Theme.of(Get.context!)
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
                    color: Theme.of(Get.context!).textTheme.bodyText1!.color!),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: TextStyles.textStyle.apply(
              color:
                  TinyColor(Theme.of(Get.context!).textTheme.bodyText1!.color!)
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
        duration: const Duration(
          seconds: Constants.kDuration,
        ),
        child: IconButton(
          onPressed: () {
            scrollableController.animateTo(
              dragRatio == 1 ? .07 : .33,
              duration: const Duration(
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
            color: Theme.of(Get.context!).textTheme.bodyText1!.color!,
          ),
        ),
      );
}
