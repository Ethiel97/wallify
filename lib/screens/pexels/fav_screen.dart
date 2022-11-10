import 'package:flutter/material.dart';
import 'package:mobile/models/pexels/wallpaper_px.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/views/base_view.dart';
import 'package:mobile/widgets/m_fav_screen.dart';
import 'package:mobile/widgets/w_px_wallpaper_card.dart';
import 'package:provider/provider.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> with FavScreenMixin {
  @override
  Widget build(BuildContext context) => BaseView<WallpaperViewModel<WallPaper>>(
        key: UniqueKey(),
        vmBuilder: (context) =>
            Provider.of<WallpaperViewModel<WallPaper>>(context),
        builder: buildScreen,
      );

  @override
  Widget setWallPaperCard(int index) => PxWallPaperCard(
        wallPaper:
            Provider.of<WallpaperViewModel<WallPaper>>(context, listen: false)
                .savedWallpapers[index],
      );
}
