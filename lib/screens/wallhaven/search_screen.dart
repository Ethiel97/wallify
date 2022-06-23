import 'package:flutter/material.dart';
import 'package:mobile/models/wallhaven/wallpaper.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/views/base_view.dart';
import 'package:mobile/widgets/w_wh_wallpaper_card.dart';
import 'package:provider/provider.dart';

import '../../widgets/m_search_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SearchMixin<WallPaper> {
  @override
  Widget build(BuildContext context) => BaseView<WallpaperViewModel<WallPaper>>(
        key: UniqueKey(),
        vmBuilder: (context) =>
            Provider.of<WallpaperViewModel<WallPaper>>(context),
        builder: buildScreen,
      );

  @override
  Widget setWallPaperCard(int index) => WhWallpaperCard(
        wallPaper: Provider.of<WallpaperViewModel<WallPaper>>(context)
            .filteredWallpapers[index],
      );
}
