import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/infrastructure/observer.dart';
import 'package:mobile/models/pexels/wallpaper_px.dart' as px;
import 'package:mobile/screens/pexels/fav_screen.dart' as px;
import 'package:mobile/screens/pexels/home_screen.dart' as px;
import 'package:mobile/screens/pexels/search_screen.dart' as px;
import 'package:mobile/screens/wallhaven/fav_screen.dart' as wh;
import 'package:mobile/screens/wallhaven/home_screen.dart' as wh;
import 'package:mobile/screens/wallhaven/search_screen.dart' as wh;
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/secure_storage.dart';
import 'package:mobile/view_models/wallpaper_view_model.dart';

class WallpaperProviderObserver extends BaseObserver<WallpaperViewModel>
    with ChangeNotifier {
  WallpaperProviderObserver() : super('') {
    // getProvider();
  }

  /*FutureOr<WallPaperProvider> getProvider() async {
    String provider = await SecureStorageService.readItem(
            key: Constants.wallpaperProviderKey) ??
        WallPaperProvider.wallhaven.name;

    current = WallPaperProvider.values.byName(provider);

    return _provider;
  }*/

  List screens = [
    const wh.SearchScreen(),
    const wh.HomeScreen(),
    const wh.FavScreen()
  ];

  WallPaperProvider _provider = WallPaperProvider.wallhaven;

  WallPaperProvider get provider => _provider;

  set current(WallPaperProvider provider) {
    _provider = provider;
    SecureStorageService.saveItem(
        key: Constants.wallpaperProviderKey, data: provider.name.toLowerCase());
    notifyListeners();
  }

  @override
  void notify(WallpaperViewModel observable) {
    print("NOTIFYING");
    if (observable is WallpaperViewModel<px.WallPaper>) {
      current = WallPaperProvider.pexels;
      notifyListeners();
      screens = [
        const px.SearchScreen(),
        const px.HomeScreen(),
        const px.FavScreen()
      ];
      notifyListeners();
    } else {
      current = WallPaperProvider.wallhaven;
      notifyListeners();
      screens = [
        const wh.SearchScreen(),
        const wh.HomeScreen(),
        const wh.FavScreen()
      ];
      notifyListeners();
    }
  }
}
