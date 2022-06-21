import 'dart:async';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/repositories/wallpaper_repository.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/view_models/base_view_model.dart';

typedef WallPaperCallBack = void Function(String url);

class WallpaperViewModel<T> extends BaseViewModel {
  List<T> wallpapers = [];

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
    Get.toNamed("wallpaperDetail${wallPaperProvider.toString().capitalize!}",
        arguments: {'wallpaper': selectedWallpaper});
    reloadState();
  }

  final WallPaperRepository<T> wallpaperRepository;

  T get selectedWallpaper => _selectedWallpaper;

  WallpaperViewModel({required this.wallpaperRepository});

  confirmAction({
    String confirmText = "Confirmation",
    required String message,
    required WallPaperCallBack action,
    required String actionText,
  }) {
    Get.snackbar(
      confirmText,
      message,
      colorText: Theme.of(Get.context!).textTheme.bodyText1!.color,
      backgroundColor: Theme.of(Get.context!).backgroundColor,
      mainButton: TextButton.icon(
        icon: Icon(
          Iconsax.paintbucket,
          color: Theme.of(Get.context!).textTheme.bodyText1!.color,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Theme.of(Get.context!).colorScheme.secondary,
          ),
          textStyle: MaterialStateProperty.all(
            TextStyles.textStyle.apply(
                color: Theme.of(Get.context!).textTheme.bodyText1!.color),
          ),
        ),
        onPressed: () {
          action;
        },
        label: Text(
          actionText,
        ),
      ),
    );
  }

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

  downloadWallPaper(String url) async {
    try {
      var file = await DefaultCacheManager().getSingleFile(url);

      await GallerySaver.saveImage(file.path, albumName: Constants.appName);

      Get.snackbar(
        "Notification",
        "Successfully Downloaded",
        colorText: Colors.white,
      );
    } catch (e) {
      LogUtils.error("Could not save to gallery due to: ${e}");
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
        "Notification",
        "Fond d'ecran applique avec succes",
        colorText: Colors.white,
      );
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    } catch (e) {
      LogUtils.error("Failed to apply wallpaper due to: $e");
    }
  }
}
