import 'dart:async';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tinycolor2/tinycolor2.dart';

import 'package:mobile/models/pexels/wallpaper.dart' as px;
import 'package:mobile/providers/api_provider.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/providers/navigation_provider.dart';
import 'package:mobile/repositories/wallpaper_repository.dart';
import 'package:mobile/utils/app_router.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/base_view_model.dart';

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

  List<T> savedWallpapers = [];

  List<T> filteredWallpapersByColor = [];

  late Box<T> boxWallpapers;

  void defSelectedWallpaper(T wallpaper, WallPaperProvider wallPaperProvider,
      {bool errorWhenLoadingImage = false}) {
    if (errorWhenLoadingImage) {
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        AppLocalizations.of(Get.context!)!.image_could_not_be_loaded,
        colorText: Colors.white,
      );
      return;
    }
    _selectedWallpaper = wallpaper;
    // reloadState();

    String route = wallPaperProvider.description.capitalizeFirst!;

    Get.toNamed("/wallpaperDetail$route",
        arguments: {'wallpaper': selectedWallpaper});
  }

  final WallPaperRepository<T> wallpaperRepository;

  T get selectedWallpaper => _selectedWallpaper;

  List<T> get localSavedWallpapers => boxWallpapers.values.toList();

  WallpaperViewModel({required this.wallpaperRepository});

  bool isWallPaperSaved(String id) => boxWallpapers.containsKey(id);

  @override
  FutureOr<void> init() async {
    //listening to pageview changes

    try {
      boxWallpapers = Hive.box(T is px.WallPaper
          ? Constants.savedPxWallpapersBox
          : Constants.savedWhWallpapersBox);

      await fetchTopWallPapers();

      if (Provider.of<AuthProvider>(Get.context!, listen: false).status ==
          Status.authenticated) {
        fetchSavedWallpapers();
      }

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
    } catch (error, stackTrace) {
      this.error = true;

      print(error);

      await FirebaseCrashlytics.instance.recordError(error, stackTrace,
          reason: 'wallpaper view model initialization error');
    }
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

  void saveWallpaper(T wallpaper, String id) async {
    try {
      if (!boxWallpapers.containsKey(id)) {
        // wallpaper = wallpaper?.copyWith(saved: true);
        boxWallpapers.put(id, wallpaper);
        reloadState();

        isLoading = true;
        notifyListeners();

        await ApiProvider().saveWallPaper(id);
        await fetchSavedWallpapers();

        finishLoading();

        Get.snackbar(
          AppLocalizations.of(Get.context!)!.notification,
          AppLocalizations.of(Get.context!)!.wallpaper_saved_successfully,
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
            onPressed: () => goToFavScreen(),
            child: Text(
              AppLocalizations.of(Get.context!)!.view_saved_wallpapers,
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
      } else {
        removeWallpaper(wallpaper, id);
      }

      reloadState();
    } catch (e) {
      print(e);
    } finally {
      finishLoading();
    }
  }

  void removeWallpaper(T wallpaper, String id) async {
    // quote = quote.copyWith(saved: false);
    try {
      boxWallpapers.delete(id);
      reloadState();

      isLoading = true;
      notifyListeners();

      await ApiProvider().deleteSavedWallPaper(id);

      await fetchSavedWallpapers();

      finishLoading();

      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        AppLocalizations.of(Get.context!)!.wallpaper_removed_successfully,
        colorText: Colors.white,
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
            goToFavScreen();
          },
          child: Text(
            AppLocalizations.of(Get.context!)!.view_saved_wallpapers,
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
    } catch (e) {
      print(e);
    } finally {
      finishLoading();
    }
  }

  void goToFavScreen() {
    Get.offNamedUntil(landing, (route) => false);
    Provider.of<NavigationProvider>(
      Get.context!,
      listen: false,
    ).currentIndex = 2;
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

  fetchSavedWallpapers() async {
    try {
      List results = await ApiProvider().fetchUserSavedWallpapers();

      savedWallpapers.clear();

      for (var res in results) {
        //extract uid from res['attributes']['uid'] before the first dot
        String id = res['attributes']['uid'].split(':')[0];

        // String id = res['attributes']['uid']
        //     .substring(0, res['attributes']['uid'].indexOf(':'));

        LogUtils.log("id: $id");

        List<T> response =
            await wallpaperRepository.searchItems(query: {"q": "like:$id"});

        LogUtils.log("SAVED WALLPAPERS: ${response[0].toString()}");
        savedWallpapers = [...savedWallpapers, response[0]];
      }
      reloadState();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
