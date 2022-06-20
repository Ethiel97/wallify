import 'dart:async';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile/repositories/wallpaper_repository.dart';
import 'package:mobile/utils/app_router.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';
import 'package:mobile/view_models/base_view_model.dart';

class WallpaperViewModel<T> extends BaseViewModel {
  List<T> wallpapers = [];

  late T _selectedWallpaper;

  int page = 1;
  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: .85,
  );

  List<T> filteredWallpapers = [];

  set defSelectedWallpaper(T wallpaper) {
    _selectedWallpaper = wallpaper;
    reloadState();
    Get.toNamed(wallpaperDetail, arguments: {'wallpaper': selectedWallpaper});
    reloadState();
  }

  final WallPaperRepository<T> wallpaperRepository;

  T get selectedWallpaper => _selectedWallpaper;

  WallpaperViewModel({required this.wallpaperRepository});

  @override
  FutureOr<void> init() async {
    //listening to pageview changes
    pageController.addListener(() async {
      notifyListeners();

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
    await fetchTopWallPapers();
  }

  fetchTopWallPapers(
      {Map<String, dynamic> query = const {'query': 'Cars'}}) async {
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
    await fetchTopWallPapers(query: {'page': page});
    reloadState();
  }

  searchWallpapers(String query) async {
    try {
      if (query.isNotEmpty) {
        debouncing(fn: () async {
          // filteredQuotes.clear();
          isLoading = true;
          List<T> results =
              await wallpaperRepository.searchItems(query: {'query': query});
          filteredWallpapers = [...results, ...filteredWallpapers];
        });
      }
    } catch (e) {
      LogUtils.error(e);
    } finally {
      finishLoading();
    }
  }

  downloadWallpaper(T value){
    // AsyncWallpaper.
  }

  applyWallpaper(T value){

  }
}
