import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/widgets/w_color_tag.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../utils/text_styles.dart';

mixin DetailsMixin<T> {
  late final T value;

  late double dragRatio;

  double sheetMaxSize = .4;

  late DraggableScrollableController scrollableController;

  String get imgUrl => value.toString();

  String get photographer => value.toString();

  List<Color> get colors => [];

  List<Widget> get colorsWidget => [
        ...colors
            .map((e) => ColorTag<T>(
                  color: e,
                  radius: Constants.kBorderRadius * 100,
                ))
            .toList()
      ];

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
              transitionOnUserGestures: true,
              child: Container(
                key: UniqueKey(),
                width: double.infinity,
                height: Get.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      AppColors.darkColor.withOpacity(.92),
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
              padding: const EdgeInsets.only(top: 50.0, left: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Constants.kBorderRadius * 100,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(.4),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaY: 25,
                            sigmaX: 25,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Iconsax.arrow_left_1,
                              size: 32,
                            ),
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Constants.kBorderRadius * 100,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(.4),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaY: 25,
                            sigmaX: 25,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Iconsax.paintbucket,
                              size: 30,
                            ),
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ),
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
                  maxChildSize: sheetMaxSize,
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
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: colorsWidget,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                "${AppLocalizations.of(context)!.photograph}: $photographer",
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
                                    download,
                                    AppLocalizations.of(context)!.download,
                                  ),
                                  buildActionButton(
                                    Iconsax.paintbucket,
                                    applyWallPaper,
                                    AppLocalizations.of(context)!.apply,
                                  ),
                                  buildActionButton(
                                    Iconsax.like,
                                    save,
                                    AppLocalizations.of(context)!.save,
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
      GestureDetector(
        onTap: onPress,
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(Constants.kBorderRadius * 100),
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
                      color:
                          Theme.of(Get.context!).textTheme.bodyText1!.color!),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              text,
              style: TextStyles.textStyle.apply(
                color: TinyColor(
                        Theme.of(Get.context!).textTheme.bodyText1!.color!)
                    .tint()
                    .darken()
                    .color,
                fontSizeDelta: -6,
                fontWeightDelta: 5,
              ),
            )
          ],
        ),
      );

  Widget buildDraggableControlButton() => AnimatedSwitcher(
        duration: const Duration(
          seconds: Constants.kDuration,
        ),
        child: IconButton(
          onPressed: () {
            scrollableController.animateTo(
              dragRatio == 1 ? .07 : sheetMaxSize,
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
