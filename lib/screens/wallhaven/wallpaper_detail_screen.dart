import 'package:flutter/material.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/views/base_view.dart';
import 'package:mobile/widgets/m_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../models/wallhaven/wallpaper.dart';

class WallpaperDetailScreen extends StatefulWidget {
  const WallpaperDetailScreen({Key? key}) : super(key: key);

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen>
    with Details<WallPaper> {
  // calculate drag ratio with notificationscrolllistener
  /*dragRatio = (notification.extent - notification.minExtent) /
  (notification.maxExtent - notification.minExtent);*/
  @override
  void initState() {
    scrollableController = DraggableScrollableController();
    dragRatio = 0.21;

    scrollableController.addListener(() {
      dragRatio = scrollableController.size / 0.33;

      print("dragratio :${dragRatio}");
      print("dragratio inverse :${1 / dragRatio}");
    });
    super.initState();
  }

  @override
  String get imgUrl => Provider.of<WallpaperViewModel<WallPaper>>(context)
      .selectedWallpaper
      .thumbs!
      .large;

  @override
  String get photographer => "N/A";

  @override
  List<Color> get colors => [
        ...List.from(Provider.of<WallpaperViewModel<WallPaper>>(context)
                .selectedWallpaper
                .colors!
                .toList())
            .map((e) => TinyColor.fromString(e).color)
            .toList()
      ];

  @override
  Widget build(BuildContext context) {
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

    viewModel.confirmAction(
        message: "Are you sure you want to apply this wallpaper?",
        action: Provider.of<WallpaperViewModel<WallPaper>>(context)
            .applyWallPaper(viewModel.selectedWallpaper.thumbs!.large),
        actionText: "Yes, apply!");
  }

  @override
  void download() {
    var viewModel = Provider.of<WallpaperViewModel<WallPaper>>(context);

    viewModel.confirmAction(
      message: "Are you sure you want to download this wallpaper?",
      action: Provider.of<WallpaperViewModel<WallPaper>>(context)
          .downloadWallPaper(viewModel.selectedWallpaper.thumbs!.large),
      actionText: "Yes, download!",
    );
  }

  @override
  void save() {
    // TODO: implement save
  }
}
