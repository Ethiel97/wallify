import 'package:flutter/material.dart';
import 'package:mobile/models/pexels/wallpaper_px.dart';
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
  String get imgUrl => wallPaper.src.large;

  @override
  String get cacheKey => wallPaper.id.toString();

  @override
  Widget build(BuildContext context) => Consumer<WallpaperViewModel<WallPaper>>(
        builder: (context, viewModel, _) => GestureDetector(
          onLongPress: () => viewDetail(viewModel),
          onTap: () => viewDetail(viewModel),
          child: buildCard(context),
        ),
      );

  void viewDetail(WallpaperViewModel<WallPaper> viewModel) {
    viewModel.defSelectedWallpaper(
      wallPaper,
      WallPaperProvider.pexels,
      errorWhenLoadingImage: errorWhenLoadingImage,
    );
  }
}
