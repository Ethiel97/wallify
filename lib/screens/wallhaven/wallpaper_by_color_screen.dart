import 'package:flutter/material.dart';
import 'package:mobile/models/wallhaven/wallpaper_wh.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/views/base_view.dart';
import 'package:mobile/widgets/m_wallpapers_by_colors.dart';
import 'package:mobile/widgets/w_wh_wallpaper_card.dart';
import 'package:provider/provider.dart';

class WallpaperByColorScreen extends StatefulWidget {
  const WallpaperByColorScreen({
    required Key key,
  }) : super(key: key);

  @override
  WallpaperByColorScreenState createState() => WallpaperByColorScreenState();
}

class WallpaperByColorScreenState extends State<WallpaperByColorScreen>
    with WallpapersByColorsMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Color get selectedColor =>
      Provider.of<WallpaperViewModel<WallPaper>>(context).selectedColor;

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
  Widget setWallPaperCard(int index) => WhWallpaperCard(
        wallPaper:
            Provider.of<WallpaperViewModel<WallPaper>>(context, listen: false)
                .filteredWallpapersByColor[index],
      );
}
