import 'dart:async';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:mobile/repositories/wallpaper_repository.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/base_view_model.dart';
import 'package:tinycolor2/tinycolor2.dart';

typedef WallPaperCallBack = Future<dynamic> Function(String url);

class WallpaperViewModel<T> extends BaseViewModel {
  List<T> wallpapers = [];

  String? selectedTag = "Cars";

  TextEditingController searchQueryTEC = TextEditingController(text: '');
  ScrollController scrollController = ScrollController();

  String searchQuery = "";
  late T _selectedWallpaper;

  int page = 1;
  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: .85,
  );

  List<T> filteredWallpapers = [];

  defSelectedWallpaper(T wallpaper, WallPaperProvider wallPaperProvider) {
    _selectedWallpaper = wallpaper;
    reloadState();

    String route = wallPaperProvider.description.capitalizeFirst!;

    Get.toNamed("/wallpaperDetail$route",
        arguments: {'wallpaper': selectedWallpaper});
    reloadState();
  }

  final WallPaperRepository<T> wallpaperRepository;

  T get selectedWallpaper => _selectedWallpaper;

  WallpaperViewModel({required this.wallpaperRepository});

  void confirmAction({
    String confirmText = "Confirmation",
    required String message,
    required VoidCallback action,
    required String actionText,
  }) {
    Get.snackbar(
      confirmText,
      message,
      colorText: Theme.of(Get.context!).textTheme.bodyText1!.color,
      snackPosition: SnackPosition.TOP,
      // backgroundColor: Theme.of(Get.context!).backgroundColor,

      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ),
      duration: const Duration(milliseconds: Constants.kDuration * 20),
      mainButton: TextButton(
        /*icon: Icon(
          Iconsax.paintbucket,
          color: Theme.of(Get.context!).textTheme.bodyText1!.color,
        ),*/
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          backgroundColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
        ),
        onPressed: () {
          action();
        },
        child: Text(
          actionText,
          style: TextStyles.textStyle.apply(
              color: TinyColor(
                Theme.of(Get.context!).colorScheme.secondary,
              ).lighten(15).color,
              fontSizeDelta: -4,
              fontWeightDelta: 10),
        ),
      ),
    );
  }

  @override
  FutureOr<void> init() async {
    //listening to pageview changes
    pageController.addListener(() async {
      //notifyListeners
      reloadState();
      if (pageController.hasClients) {
        //if the user reaches the last item, we search for the
        // next page results using pagination method
        if (pageController.page?.floor() ==
            (Constants.perPageResults * page) - 1) {
          // print("END OF SCROLLING");
          paginate();
        }
      }
    });

    scrollController.addListener(() {

      if(scrollController.hasClients){
        LogUtils.log("SCROLLING: ${scrollController.offset}");
      }
    });

    await fetchTopWallPapers();
  }

  fetchTopWallPapers({Map<String, dynamic> query = const {'q': 'Cars'}}) async {
    try {
      // isLoading = true;

      List<T> results = await wallpaperRepository.getItems(query: query);

      wallpapers = [...wallpapers..shuffle(), ...results..shuffle()];

      _selectedWallpaper = wallpapers.first;
      reloadState();
      // wallpapers.shuffle();
      // reloadState();

      // selectedTags = [tags[0]];
      // filterQuotesByTag();
    } catch (e) {
      LogUtils.error(e);
    } finally {
      reloadState();
      finishLoading();
    }
  }

  @override
  paginate() async {
    //handle pagination
    page += 1;
    await fetchTopWallPapers(query: {'page': page, 'current_page': page});
    reloadState();
  }

  searchWallpapers(String query,
      {int delay = 500, String page = 'Search'}) async {

    searchQueryTEC.text = query;

    selectedTag = Constants.tags.firstWhereOrNull(
        (element) => element.toLowerCase() == query.toLowerCase());

    /*if (selectedTag != null && selectedTag!.isNotEmpty) {
      reloadState();
    }*/

    try {
      if (query.isNotEmpty) {
        LogUtils.log(query);

        debouncing(
          waitForMs: delay,
          fn: () async {
            isLoading = true;

            List<T> results = await wallpaperRepository
                .searchItems(query: {'query': query, 'q': query});

            // filteredWallpapers = [...results, ...filteredWallpapers];

            if (page == 'Search') {
              filteredWallpapers = results;
              reloadState();
            }

            if (page == 'Home') {
              wallpapers = results;
              reloadState();

              pageController.animateToPage(0,
                  duration: const Duration(milliseconds: Constants.kDuration),
                  curve: Curves.easeInOutCubicEmphasized);
            }

            finishLoading();
          },
        );
      }
    } catch (e) {
      LogUtils.error(e);
    }
  }

  downloadWallPaper(String url) async {
    try {
      var file = await DefaultCacheManager().getSingleFile(url);

      LogUtils.log("FILE: ${file.toString()}");
      await GallerySaver.saveImage(file.path, albumName: Constants.appName);

      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        AppLocalizations.of(Get.context!)!.successfully_downloaded,
        colorText: Colors.white,
      );
    } catch (e) {
      LogUtils.error("Could not save to gallery due to: $e");
    }
  }

  applyWallPaper(String url) async {
    String result;
    var file = await DefaultCacheManager().getSingleFile(url);
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setWallpaperFromFile(
        file.path,
        AsyncWallpaper.HOME_SCREEN,
      );

      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        AppLocalizations.of(Get.context!)!.successfully_applied,
        colorText: Colors.white,
      );
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    } catch (e) {
      LogUtils.error("Failed to apply wallpaper due to: $e");
    }
  }
}
