import 'package:wallinice/features/wallpapers/wallpapers.dart';
import '../entities/favorite.dart';

abstract class FavoritesRepository {
  Future<List<Wallpaper>> getFavoriteWallpapers();

  Future<void> addToFavorites(Wallpaper wallpaper);

  Future<void> removeFromFavorites(String wallpaperId);

  Future<bool> isWallpaperFavorited(String wallpaperId);

  Stream<List<Wallpaper>> watchFavoriteWallpapers();

  Future<void> clearAllFavorites();

  Future<int> getFavoritesCount();

  // Remote API methods
  Future<List<Favorite>> getUserSavedWallpapers();
  Future<void> saveWallpaper(String wallpaperId);
  Future<void> deleteSavedWallpaper(String wallpaperId);
  Future<void> deleteUserSavedWallpapers();
}
