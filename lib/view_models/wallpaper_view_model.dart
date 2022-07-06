import 'dart:async';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:mobile/providers/navigation_provider.dart';
import 'package:mobile/repositories/wallpaper_repository.dart';
import 'package:mobile/utils/app_router.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/base_view_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tinycolor2/tinycolor2.dart';

typedef WallPaperCallBack = Future<dynamic> Function(String url);

class WallpaperViewModel<T> extends BaseViewModel {
  List<T> wallpapers = [];

  String? selectedTag = "Cars";

  String previousQuery = "";

  Color _selectedColor = Colors.black;

  Color get selectedColor => _selectedColor;

  int homeScreenCurrentPage = 0;

  set selectedColor(Color selectedColor) {
    _selectedColor = selectedColor;
    reloadState();
  }

  TextEditingController searchQueryTEC = TextEditingController(text: '');
  ScrollController searchPageScrollController = ScrollController();
  ScrollController wallpapersByColorPageScrollController = ScrollController();
  ScrollController tagsListScrollController = ScrollController();
  ScrollController colorsListScrollController = ScrollController();

  double searchPageMaxScrollExtent = 0.0;
  double wallpapersBycolorMaxScrollExtent = 0.0;

  String searchQuery = "";
  late T _selectedWallpaper;

  int currentPaginationPageSearch = 1;
  int currentPaginationPageHome = 1;
  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: .85,
  );

  List<T> filteredWallpapers = [];

  List<T> filteredWallpapersByColor = [];

  void defSelectedWallpaper(T wallpaper, WallPaperProvider wallPaperProvider) {
    _selectedWallpaper = wallpaper;
    // reloadState();

    String route = wallPaperProvider.description.capitalizeFirst!;

    Get.toNamed("/wallpaperDetail$route",
        arguments: {'wallpaper': selectedWallpaper});
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
      messageText: Text(
        message,
        style: TextStyles.textStyle.apply(
          color: Theme.of(Get.context!).backgroundColor,
          fontSizeDelta: -4.4,
          fontWeightDelta: 1,
        ),
      ),
      // titleText: ,
      // colorText: Theme.of(Get.context!).textTheme.bodyText1!.color,
      colorText: Theme.of(Get.context!).backgroundColor,
      snackPosition: SnackPosition.TOP,
      // backgroundColor: Theme.of(Get.context!).backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ),
      backgroundColor: Theme.of(Get.context!).textTheme.bodyText1!.color,
      duration: const Duration(milliseconds: Constants.kDuration * 42),
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
        onPressed: () => action(),
        child: Text(
          actionText,
          style: TextStyles.textStyle.apply(
            color: TinyColor(
              Theme.of(Get.context!).colorScheme.secondary,
            ).darken(15).color,
            fontSizeDelta: -4,
            fontWeightDelta: 10,
          ),
        ),
      ),
    );
  }

  @override
  FutureOr<void> init() async {
    //listening to pageview changes
    await fetchTopWallPapers();

    // Get.bottomSheet(bottomsheet)
    pageController.addListener(() async {
      //notifyListeners

        homeScreenCurrentPage = pageController.page!.floor();
        reloadState();

      // reloadState();
      if (pageController.hasClients) {
        //if the user reaches the last item, we search for the
        // next page results using pagination method
        if (pageController.page?.floor() ==
            (Constants.perPageResults * currentPaginationPageHome) - 1) {
          // print("END OF SCROLLING");
          loadMore();
        }
      }
    });

    tagsListScrollController.addListener(() {
      if (tagsListScrollController.hasClients) {
        // LogUtils.log("SCROLLING tags: ${tagsListScrollController.offset}");
      }
    });

    colorsListScrollController.addListener(() {
      if (colorsListScrollController.hasClients) {
        // LogUtils.log("SCROLLING tags: ${colorsListScrollController.offset}");
      }
    });

    searchPageScrollController.addListener(() {
      if (searchPageScrollController.hasClients) {
        LogUtils.log(
            "SEARCH PAGE SCROLLING: ${searchPageScrollController.offset}");
        LogUtils.log("SEARCH PAGE MAX EXTENT: $searchPageMaxScrollExtent");

        /*if (searchPageScrollController.position.pixels ==
            searchPageMaxScrollExtent) {
          loadMore();
        }*/
      }
    });

    wallpapersByColorPageScrollController.addListener(() {
      if (wallpapersByColorPageScrollController.hasClients) {
        // LogUtils.log("SEARCH PAGE SCROLLING: ${searchPageScrollController.position.pixels}");
        // LogUtils.log("SEARCH PAGE MAX EXTENT: $searchPageMaxScrollExtent");

        if (wallpapersByColorPageScrollController.position.pixels ==
            wallpapersBycolorMaxScrollExtent) {
          loadMore();
        }
      }
    });
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
  loadMore() async {
    //handle pagination

    if (Provider.of<NavigationProvider>(Get.context!, listen: false)
            .currentIndex ==
        1) {
      currentPaginationPageHome += 1;

      await fetchTopWallPapers(query: {
        'page': currentPaginationPageHome,
        'current_page': currentPaginationPageHome
      });
      reloadState();
    } else {
      currentPaginationPageSearch += 1;

      await searchWallpapers(searchQueryTEC.text,
          details: {'page': currentPaginationPageSearch});
    }
  }

  searchWallpapers(
    String query, {
    int delay = 500,
    Map<String, Object> details = const {},
  }) async {
    int navigationCurrentPage =
        Provider.of<NavigationProvider>(Get.context!, listen: false)
            .currentIndex;
    searchQueryTEC.text = query;

    bool isSameCategory = previousQuery == query;

    selectedTag = Constants.tags.firstWhereOrNull(
      (element) => element.toLowerCase() == query.toLowerCase(),
    );

    /*if (selectedTag != null && selectedTag!.isNotEmpty) {
      reloadState();
    }*/

    try {
      if (query.isNotEmpty || details.isNotEmpty) {
        LogUtils.log(query);

        debouncing(
          waitForMs: delay,
          fn: () async {
            isLoading = true;

            var requestQuery = {'query': query, 'q': query};

            List<T> results = await wallpaperRepository
                .searchItems(query: {...requestQuery, ...details});
            if (details.isNotEmpty && details.containsKey('colors')) {
              filteredWallpapersByColor = [...results];
              // reloadState();
              _selectedColor = details['color'] as Color;
              // reloadState();
              finishLoading();

              Get.toNamed(wallpaperByColorWh);

              return;
            }

            //search page
            else if (navigationCurrentPage == 0) {
              filteredWallpapers = [
                if (isSameCategory) ...filteredWallpapers,
                ...results,
              ];

              if (searchPageScrollController.hasClients) {
                // print("ANIMATING TO END");

                searchPageScrollController.animateTo(
                  searchPageMaxScrollExtent * currentPaginationPageHome,
                  duration: const Duration(milliseconds: Constants.kDuration),
                  curve: Curves.easeInOutCubicEmphasized,
                );
              }
              // reloadState();
            }

            //home page
            else if (navigationCurrentPage == 1) {
              wallpapers = [
                ...results,
                if (isSameCategory) ...wallpapers,
              ];
              reloadState();

              if (pageController.hasClients) {
                pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: Constants.kDuration),
                  curve: Curves.easeInOutCubicEmphasized,
                );
              }
            }

            finishLoading();
          },
        );
      }
    } catch (e) {
      LogUtils.error(e);
    } finally {
      finishLoading();
      previousQuery = searchQueryTEC.text;
    }
  }

  void downloadWallPaper(String url) async {
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

  //TODO: add deep linking or app url
  void shareWallPaper(String url) async {
    try {
      var file = await DefaultCacheManager().getSingleFile(url);

      await Share.shareFiles([file.path],
          subject: AppLocalizations.of(Get.context!)!.browse_awesome_wallpapers,
          text:
              AppLocalizations.of(Get.context!)!.beautiful_wallpaper_wallinice);
      LogUtils.log("FILE: ${file.toString()}");

      /*Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        AppLocalizations.of(Get.context!)!.successfully_downloaded,
        colorText: Colors.white,
      );*/
    } catch (e) {
      LogUtils.error("Could not share wallpaper: $e");
    }
  }

  void applyWallPaper(String url) async {
    String result;
    var file = await DefaultCacheManager().getSingleFile(url);
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setWallpaperFromFile(
        file.path,
        AsyncWallpaper.HOME_SCREEN,
      );

      LogUtils.log("WALLPAPER RESULT: $result");

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
