import 'package:flutter/material.dart';
import 'package:mobile/models/wallhaven/wallpaper.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/views/base_view.dart';
import 'package:mobile/widgets/m_search_screen.dart';
import 'package:mobile/widgets/w_wh_wallpaper_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SearchMixin<WallPaper>, AutomaticKeepAliveClientMixin {
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
                .filteredWallpapers[index],
      );

  @override
  bool get wantKeepAlive => true;
}
