import 'package:wallinice/features/wallpapers/wallpapers.dart';

abstract class FavoritesRepository {
  Future<List<Wallpaper>> getFavoriteWallpapers();

  Future<void> addToFavorites(Wallpaper wallpaper);

  Future<void> removeFromFavorites(String wallpaperId);

  Future<bool> isWallpaperFavorited(String wallpaperId);

  Stream<List<Wallpaper>> watchFavoriteWallpapers();

  Future<void> clearAllFavorites();

  Future<int> getFavoritesCount();
}
