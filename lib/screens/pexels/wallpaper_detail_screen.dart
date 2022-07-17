import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/utils/app_router.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/views/base_view.dart';
import 'package:mobile/widgets/m_detail_screen.dart';
import 'package:mobile/widgets/utilities.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../models/pexels/wallpaper.dart';

class WallpaperDetailScreen extends StatefulWidget {
  const WallpaperDetailScreen({Key? key}) : super(key: key);

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen>
    with DetailsMixin<WallPaper>, AutomaticKeepAliveClientMixin {
  // calculate drag ratio with notificationscrolllistener
  /*dragRatio = (notification.extent - notification.minExtent) /
  (notification.maxExtent - notification.minExtent);*/
  @override
  void initState() {
    scrollableController = DraggableScrollableController();
    dragRatio = 0.21;

    scrollableController.addListener(() {
      dragRatio = scrollableController.size / sheetMaxSize;
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  String get imgUrl => Provider.of<WallpaperViewModel<WallPaper>>(context)
      .selectedWallpaper
      .src
      .large2x;

  @override
  String get photographer => Provider.of<WallpaperViewModel<WallPaper>>(context)
      .selectedWallpaper
      .photographer;

  @override
  List<Color> get colors => [
        TinyColor.fromString(Provider.of<WallpaperViewModel<WallPaper>>(context)
                .selectedWallpaper
                .avgColor)
            .color
      ];

  @override
  String get cacheKey =>
      Provider.of<WallpaperViewModel<WallPaper>>(context, listen: false)
          .selectedWallpaper
          .src.large2x
          .toString();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BaseView<WallpaperViewModel<WallPaper>>(
      key: UniqueKey(),
      vmBuilder: (context) =>
          Provider.of<WallpaperViewModel<WallPaper>>(context),
      builder: buildScreen,
    );
  }

  @override
  void applyWallPaper() {
    var viewModel = Provider.of<WallpaperViewModel<WallPaper>>(context);

    utilities.confirmAction(
      message:
          AppLocalizations.of(Get.context!)!.wallpaper_application_confirmation,
      action: () {
        viewModel.applyWallPaper(viewModel.selectedWallpaper.src.large2x);
      },
      actionText: AppLocalizations.of(Get.context!)!.yes_apply,
    );
  }

  @override
  void download() {
    var viewModel =
        Provider.of<WallpaperViewModel<WallPaper>>(context, listen: false);

    utilities.confirmAction(
      message:
          AppLocalizations.of(Get.context!)!.wallpaper_download_confirmation,
      action: () {
        viewModel.downloadWallPaper(viewModel.selectedWallpaper.src.large2x);
      },
      actionText: AppLocalizations.of(Get.context!)!.yes_download,
    );
  }

  @override
  void save() {
    // TODO: implement save

    if (Provider.of<AuthProvider>(context, listen: false).status ==
        Status.authenticated) {
      var viewModel =
          Provider.of<WallpaperViewModel<WallPaper>>(context, listen: false);

      bool isFavorite = viewModel.isWallPaperSaved(cacheKey);

      //check if user is on the favorite screen
      utilities.confirmAction(
        message: isFavorite
            ? AppLocalizations.of(Get.context!)!.wallpaper_remove_confirmation
            : AppLocalizations.of(Get.context!)!.wallpaper_save_confirmation,
        action: () {
          viewModel.saveWallpaper(viewModel.selectedWallpaper,
              viewModel.selectedWallpaper.id.toString());
        },
        actionText: isFavorite
            ? AppLocalizations.of(Get.context!)!.remove
            : AppLocalizations.of(Get.context!)!.save,
      );
    } else {
      Get.toNamed(login);
    }
  }

  @override
  void share() {
    var viewModel =
        Provider.of<WallpaperViewModel<WallPaper>>(context, listen: false);

    viewModel.shareWallPaper(viewModel.selectedWallpaper.src.large);

    /*viewModel.confirmAction(
      message:
      AppLocalizations.of(Get.context!)!.wallpaper_download_confirmation,
      action: () {
        viewModel.downloadWallPaper(viewModel.selectedWallpaper.path!);
      },
      actionText: AppLocalizations.of(Get.context!)!.yes_download,
    );*/
  }
}
