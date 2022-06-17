import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile/models/wallpaper.dart';
import 'package:mobile/utils/app_router.dart';
import 'package:mobile/view_models/base_view_model.dart';

class WallpaperViewModel extends BaseViewModel {
  List<Wallpaper> wallpapers = [];

  late Wallpaper _selectedWallpaper;

  int page = 1;
  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: .85,
  );

  List<Wallpaper> filteredWallpapers = [];

  set defSelectedWallpaper(Wallpaper wallpaper) {
    _selectedWallpaper = wallpaper;
    reloadState();
    Get.toNamed(wallpaperDetail,arguments: {'wallpaper': selectedWallaper});
    reloadState();
  }

  Wallpaper get selectedWallaper => _selectedWallpaper;

  @override
  FutureOr<void> init() async {
    //listening to pageview changes
    pageController.addListener(() async {
      notifyListeners();

      if (pageController.hasClients) {
        if (pageController.page?.floor() == wallpapers.length - 1) {
          // print("END OF SCROLLING");
          await paginate();
        }
      }
    });
    await fetchCuratedWallpapers();
  }

  fetchCuratedWallpapers({Map<String, dynamic> query = const {}}) async {
    try {
      // isLoading = true;
      var results = await wallpaperRepository.getItems(query: query);

      wallpapers = [...wallpapers, ...results];
      reloadState();
      // wallpapers.shuffle();
      // reloadState();

      // selectedTags = [tags[0]];
      // filterQuotesByTag();
    } catch (e) {
      print(e);
    } finally {
      reloadState();
      finishLoading();
    }
  }

  paginate() async {
    //handle pagination
    page += 1;
    await fetchCuratedWallpapers(query: {'page': page});
    reloadState();
  }

  searchWallpapers(String query) async {
    try {
      if (query.isNotEmpty) {
        debouncing(fn: () async {
          // filteredQuotes.clear();
          isLoading = true;
          var results =
              await wallpaperRepository.searchItems(query: {'query': query});
          filteredWallpapers = [...results, ...filteredWallpapers];
        });
      }
    } catch (e) {
      print(e);
    } finally {
      finishLoading();
    }
  }
}
