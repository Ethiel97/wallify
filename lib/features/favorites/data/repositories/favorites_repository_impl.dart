import 'package:injectable/injectable.dart';
import 'package:wallinice/features/favorites/favorites.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._localDataSource);

  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<List<Wallpaper>> getFavoriteWallpapers() async {
    try {
      final favoriteModels = await _localDataSource.getFavoriteWallpapers();
      return favoriteModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Log error and return empty list instead of throwing
      // In production, you might want to use a logger here
      print('Error getting favorite wallpapers: $e');
      return [];
    }
  }

  @override
  Future<void> addToFavorites(Wallpaper wallpaper) async {
    try {
      final favoriteModel = FavoriteWallpaperModel.fromWallpaper(wallpaper);
      await _localDataSource.addToFavorites(favoriteModel);
    } catch (e) {
      print('Error adding wallpaper to favorites: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeFromFavorites(String wallpaperId) async {
    try {
      await _localDataSource.removeFromFavorites(wallpaperId);
    } catch (e) {
      print('Error removing wallpaper from favorites: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isWallpaperFavorited(String wallpaperId) async {
    try {
      return await _localDataSource.isWallpaperFavorited(wallpaperId);
    } catch (e) {
      print('Error checking if wallpaper is favorited: $e');
      return false;
    }
  }

  @override
  Stream<List<Wallpaper>> watchFavoriteWallpapers() {
    return _localDataSource.watchFavoriteWallpapers().map(
          (favoriteModels) =>
              favoriteModels.map((model) => model.toEntity()).toList(),
        );
  }

  @override
  Future<void> clearAllFavorites() async {
    try {
      await _localDataSource.clearAllFavorites();
    } catch (e) {
      print('Error clearing all favorites: $e');
      rethrow;
    }
  }

  @override
  Future<int> getFavoritesCount() async {
    try {
      return await _localDataSource.getFavoritesCount();
    } catch (e) {
      print('Error getting favorites count: $e');
      return 0;
    }
  }
}
