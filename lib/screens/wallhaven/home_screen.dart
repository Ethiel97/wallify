import 'package:flutter/material.dart';
import 'package:mobile/models/wallhaven/wallpaper.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';
import 'package:mobile/views/base_view.dart';
import 'package:mobile/widgets/m_home_screen.dart';
import 'package:mobile/widgets/w_wh_wallpaper_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, HomeScreenMixin<WallPaper> {
  late AnimationController animationController;

  // late Animation slideAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: Constants.kDuration * 2,
      ),
    );

    /*slideAnimation = Tween<Offset>(
      begin: const Offset(0, .5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );*/

    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  String get selectedWallPaperImgUrl =>
      Provider.of<WallpaperViewModel<WallPaper>>(context, listen: false)
          .wallpapers[selectedWallpaperIndex + 1]
          .thumbs!
          .large;

  @override
  Widget build(BuildContext context) => BaseView<WallpaperViewModel<WallPaper>>(
        key: UniqueKey(),
        vmBuilder: (context) =>
            Provider.of<WallpaperViewModel<WallPaper>>(context),
        builder: buildScreen,
      );

  @override
  Widget setWallPaperCard(int index) => WhWallpaperCard(
        wallPaper: Provider.of<WallpaperViewModel<WallPaper>>(
          context,
          listen: false,
        ).wallpapers[index],
      );
}
