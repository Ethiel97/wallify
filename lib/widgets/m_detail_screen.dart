import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/providers/navigation_provider.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/widgets/w_color_tag.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../utils/text_styles.dart';

mixin DetailsMixin<T> {
  late final T value;

  late double dragRatio;

  double sheetMaxSize = .4;

  late DraggableScrollableController scrollableController;

  String get imgUrl => value.toString();

  String get cacheKey => value.toString();

  String get photographer => value.toString();

  List<Color> get colors => [];

  String get imgSize => value.toString();

  T get selectedWallPaper => value;

  List<Widget> get colorsWidget => [
        ...colors
            .map((e) => ColorTag<T>(
                  color: e,
                  radius: Constants.kBorderRadius * 100,

                  /*voidCallback: () => scrollableController.animateTo(
                    .07,
                    duration: const Duration(
                      milliseconds: Constants.kDuration,
                    ),
                    curve: Curves.easeIn,
                  ),*/
                ))
            .toList()
      ];

  void download();

  void applyWallPaper();

  void save();

  void share();

  Widget buildScreen(
    BuildContext context,
    WallpaperViewModel<T> wallpaperViewModel,
  ) =>
      Material(
        type: MaterialType.transparency,
        color: Theme.of(context).backgroundColor,
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
                      Theme.of(Get.context!).backgroundColor.withOpacity(.2),
                      BlendMode.srcOver,
                    ),
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      imgUrl,
                      cacheKey: cacheKey,
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
                            icon: Icon(
                              Iconsax.arrow_left_1,
                              size: 32,
                              color: AppColors.textColor,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: Platform.isAndroid,
                    child: Align(
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
                              icon: Icon(
                                Iconsax.paintbucket,
                                size: 30,
                                color: AppColors.textColor,
                              ),
                              onPressed: applyWallPaper,
                            ),
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
                child: buildBottomSheet(wallpaperViewModel),
              ),
            ),
            // AnimatedCrossFade(firstChild: null,
          ],
        ),
      );

  Widget buildBottomSheet(WallpaperViewModel<T> wallpaperViewModel) => Consumer<
          NavigationProvider>(
      builder: (context, navigationProvider, _) => DraggableScrollableSheet(
            // controller: scrollableController,
            expand: true,
            initialChildSize: .07,
            maxChildSize: sheetMaxSize,
            minChildSize: .07,
            builder: (context, controller) => SingleChildScrollView(
              controller: controller,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(Constants.kBorderRadius * 2),
                  topRight: const Radius.circular(Constants.kBorderRadius * 2),
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
                      topLeft:
                          const Radius.circular(Constants.kBorderRadius * 2),
                      topRight:
                          const Radius.circular(Constants.kBorderRadius * 2),
                      bottomLeft: Radius.circular(
                        dragRatio == 1 ? Constants.kBorderRadius * 2 : 0,
                      ),
                      bottomRight: Radius.circular(
                          dragRatio == 1 ? Constants.kBorderRadius * 2 : 0),
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: colorsWidget,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          "${AppLocalizations.of(Get.context!)!.photograph}: $photographer",
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyles.textStyle.apply(
                            fontSizeDelta: -3,
                            fontWeightDelta: 4,
                            // color: Theme.of(context).textTheme.bodyText1!.color!,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save,
                              size: 20,
                              /*color: Theme.of(Get.context!)
                                  .textTheme
                                  .bodyText1!
                                  .color!,*/
                              color: AppColors.textColor,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              imgSize,
                              style: TextStyles.textStyle.apply(
                                /*color: Theme.of(Get.context!)
                                    .textTheme
                                    .bodyText1!
                                    .color!,*/
                                color: AppColors.textColor,
                                fontSizeDelta: -2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildActionButton(
                              Iconsax.document_download,
                              download,
                              AppLocalizations.of(Get.context!)!.download,
                            ),
                            if (Platform.isAndroid)
                              buildActionButton(
                                Iconsax.paintbucket,
                                applyWallPaper,
                                AppLocalizations.of(Get.context!)!.apply,
                              ),
                            buildActionButton(
                              wallpaperViewModel.isWallPaperSaved(cacheKey)
                                  ? Iconsax.box_remove
                                  : Iconsax.like,
                              () => save(),
                              wallpaperViewModel.isWallPaperSaved(cacheKey)
                                  ? AppLocalizations.of(Get.context!)!.remove
                                  : AppLocalizations.of(Get.context!)!.save,
                            ),
                            buildActionButton(
                              Iconsax.share,
                              share,
                              AppLocalizations.of(Get.context!)!.share,
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
          ));

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
                  child: Icon(
                    iconData,
                    // color: Theme.of(Get.context!).textTheme.bodyText1!.color!,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              text,
              style: TextStyles.textStyle.apply(
                /* color: TinyColor(
                        Theme.of(Get.context!).textTheme.bodyText1!.color!)
                    .tint()
                    .darken()
                    .color,*/
                color: AppColors.textColor,
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
            /*buildBottomSheet().controller?.animateTo(
              dragRatio == 1 ? .07 : sheetMaxSize,
              duration: const Duration(
                milliseconds: Constants.kDuration,
              ),
              curve: Curves.easeIn,
            );*/
          },
          icon: Icon(
            dragRatio == 1
                ? Icons.expand_more_outlined
                : Icons.expand_less_outlined,
            size: 30,
            color: AppColors.textColor,
          ),
        ),
      );

  Widget get loader => Shimmer(
        color: Provider.of<ThemeProvider>(Get.context!, listen: false)
                    .currentTheme ==
                AppTheme.light.description
            ? Theme.of(Get.context!).colorScheme.secondary
            : Theme.of(Get.context!).primaryColor,
        child: Container(
          height: Get.height,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Constants.kBorderRadius,
            ),
          ),
        ),
      );
}
