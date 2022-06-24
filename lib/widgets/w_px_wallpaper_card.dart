import 'package:flutter/material.dart';
import 'package:mobile/models/pexels/wallpaper.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/widgets/m_wallpaper_card.dart';
import 'package:provider/provider.dart';

class PxWallPaperCard extends StatelessWidget with WallpaperCard<WallPaper> {
  final WallPaper wallPaper;

  PxWallPaperCard({
    Key? key,
    required this.wallPaper,
  }) : super(key: key);

  @override
  String get imgUrl => wallPaper.src.large2x;

  @override
  Widget build(BuildContext context) => Consumer<WallpaperViewModel<WallPaper>>(
        builder: (context, viewModel, _) => GestureDetector(
          onLongPress: () {
            viewModel.defSelectedWallpaper(wallPaper, WallPaperProvider.pexels);
          },
          onTap: () {
            viewModel.defSelectedWallpaper(wallPaper, WallPaperProvider.pexels);
          },
          child: buildCard(context),
        ),
      );
}
