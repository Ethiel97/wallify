import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:wallinice/core/storage/storage.dart';
import 'package:wallinice/features/favorites/favorites.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteWallpaperModel>> getFavoriteWallpapers();

  Future<void> addToFavorites(FavoriteWallpaperModel wallpaper);

  Future<void> removeFromFavorites(String wallpaperId);

  Future<bool> isWallpaperFavorited(String wallpaperId);

  Stream<List<FavoriteWallpaperModel>> watchFavoriteWallpapers();

  Future<void> clearAllFavorites();

  Future<int> getFavoritesCount();
}

@LazySingleton(as: FavoritesLocalDataSource)
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  FavoritesLocalDataSourceImpl(this._storageService);

  static const String _collection = 'favorite_wallpapers';
  final StorageService _storageService;

  @override
  Future<List<FavoriteWallpaperModel>> getFavoriteWallpapers() async {
    final favorites =
        await _storageService.getAll<FavoriteWallpaperModel>(_collection);
    // Sort by most recent first
    favorites.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return favorites;
  }

  @override
  Future<void> addToFavorites(FavoriteWallpaperModel wallpaper) async {
    await _storageService.put<FavoriteWallpaperModel>(
      _collection,
      wallpaper.id,
      wallpaper,
    );
  }

  @override
  Future<void> removeFromFavorites(String wallpaperId) async {
    await _storageService.delete(_collection, wallpaperId);
  }

  @override
  Future<bool> isWallpaperFavorited(String wallpaperId) async {
    return _storageService.containsKey(_collection, wallpaperId);
  }

  @override
  Stream<List<FavoriteWallpaperModel>> watchFavoriteWallpapers() {
    return _storageService
        .watch<FavoriteWallpaperModel>(_collection)
        .map((favorites) {
      // Sort by most recent first
      favorites.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      return favorites;
    });
  }

  @override
  Future<void> clearAllFavorites() async {
    await _storageService.clear(_collection);
  }

  @override
  Future<int> getFavoritesCount() async {
    return _storageService.count(_collection);
  }
}
