import 'package:flutter/material.dart';
import 'package:mobile/models/wallhaven/wallpaper.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/widgets/w_wallpaper_card.dart';
import 'package:provider/provider.dart';

class WhWallpaperCard extends StatelessWidget with WallpaperCard<WallPaper> {
  final WallPaper wallPaper;

  WhWallpaperCard({
    Key? key,
    required this.wallPaper,
  }) : super(key: key);

  String get imgUrl => wallPaper.url ?? imgUrl;

  @override
  Widget build(BuildContext context) => Consumer<WallpaperViewModel<WallPaper>>(
        builder: (context, viewModel, _) => GestureDetector(
          onLongPress: () {
            viewModel.defSelectedWallpaper = wallPaper;
          },
          onTap: () {
            viewModel.defSelectedWallpaper = wallPaper;
          },
          child: buildCard(context),
        ),
      );
}
