import 'package:flutter/material.dart';
import 'package:mobile/models/wallhaven/wallpaper_wh.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/widgets/m_wallpaper_card.dart';
import 'package:provider/provider.dart';

class WhWallpaperCard extends StatelessWidget with WallpaperCard<WallPaper> {
  final WallPaper wallPaper;

  WhWallpaperCard({
    Key? key,
    required this.wallPaper,
  }) : super(key: key);

  @override
  String get imgUrl => wallPaper.thumbs!.original;

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
      WallPaperProvider.wallhaven,
      errorWhenLoadingImage:  errorWhenLoadingImage,
    );
  }
}
