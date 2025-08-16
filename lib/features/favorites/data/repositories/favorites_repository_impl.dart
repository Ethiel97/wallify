import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:wallinice/features/favorites/favorites.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
  );

  final FavoritesLocalDataSource _localDataSource;
  final FavoritesRemoteDataSource _remoteDataSource;

  @override
  Future<List<Wallpaper>> getFavoriteWallpapers() async {
    try {
      final favoriteModels = await _localDataSource.getFavoriteWallpapers();
      return favoriteModels.map((model) => model.toEntity()).toList();
    } catch (e, stack) {
      // Log error and return empty list instead of throwing
      // In production, you might want to use a logger here

      log(
        'Error fetching favorite wallpapers: $e',
        error: e,
        stackTrace: stack,
        name: 'FavoritesRepositoryImpl.getFavoriteWallpapers',
      );
      return [];
    }
  }

  @override
  Future<void> addToFavorites(Wallpaper wallpaper) async {
    try {
      // Add to local cache first (immediate feedback)
      final favoriteModel = FavoriteWallpaperModel.fromWallpaper(wallpaper);
      await _localDataSource.addToFavorites(favoriteModel);

      // Try to save to remote in background
      try {
        await _remoteDataSource.saveWallpaper(wallpaper.id);
      } catch (remoteError) {
        // Remote save failed, but local save succeeded - this is acceptable
        print('Failed to save to remote favorites: $remoteError');
      }
    } catch (e, stack) {
      log(
        'Error adding wallpaper to favorites: $e',
        error: e,
        stackTrace: stack,
        name: 'FavoritesRepositoryImpl.addToFavorites',
      );
      rethrow;
    }
  }

  @override
  Future<void> removeFromFavorites(String wallpaperId) async {
    try {
      // Remove from local cache first (immediate feedback)
      await _localDataSource.removeFromFavorites(wallpaperId);

      // Try to remove from remote in background
      try {
        await _remoteDataSource.deleteSavedWallpaper(wallpaperId);
      } catch (remoteError) {
        // Remote removal failed, but local removal succeeded -
        // this is acceptable
        print('Failed to remove from remote favorites: $remoteError');
      }
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
      // Clear local cache first
      await _localDataSource.clearAllFavorites();

      // Try to clear remote favorites in background
      try {
        await _remoteDataSource.deleteUserSavedWallpapers();
      } catch (remoteError) {
        // Remote clear failed, but local clear succeeded - this is acceptable
        print('Failed to clear remote favorites: $remoteError');
      }
    } catch (e, stack) {
      log(
        'Error clearing all favorites: $e',
        error: e,
        stackTrace: stack,
        name: 'FavoritesRepositoryImpl.clearAllFavorites',
      );
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

  // Cache-first approach with remote sync
  @override
  Future<List<Favorite>> getUserSavedWallpapers() async {
    try {
      // Try to fetch from remote first
      final remoteFavorites = await _remoteDataSource.getUserSavedWallpapers();

      // Update local cache with remote data
      await _syncLocalWithRemote(remoteFavorites);

      return remoteFavorites.map((model) => model.toEntity()).toList();
    } catch (e, stack) {
      log(
        'Error fetching remote favorites: $e',
        error: e,
        stackTrace: stack,
        name: 'FavoritesRepositoryImpl.getUserSavedWallpapers',
      );

      // Fallback to local cache if remote fails
      try {
        final localFavorites = await _localDataSource.getFavoriteWallpapers();
        return localFavorites
            .map(
              (model) => Favorite(
                id: model.id,
                uid: model.id, // Use wallpaper id as uid
                userId: 'local', // Placeholder for local storage
              ),
            )
            .toList();
      } catch (localError) {
        print('Error fetching local favorites: $localError');
        return [];
      }
    }
  }

  @override
  Future<void> saveWallpaper(String wallpaperId) async {
    try {
      // Save to remote first
      await _remoteDataSource.saveWallpaper(wallpaperId);
    } catch (e, stack) {
      log(
        'Error saving wallpaper to remote: $e',
        error: e,
        stackTrace: stack,
        name: 'FavoritesRepositoryImpl.saveWallpaper',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteSavedWallpaper(String wallpaperId) async {
    try {
      // Delete from remote first
      await _remoteDataSource.deleteSavedWallpaper(wallpaperId);

      // Also remove from local cache if it exists
      await _localDataSource.removeFromFavorites(wallpaperId);
    } catch (e, stack) {
      log(
        'Error deleting saved wallpaper from remote: $e',
        error: e,
        stackTrace: stack,
        name: 'FavoritesRepositoryImpl.deleteSavedWallpaper',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteUserSavedWallpapers() async {
    try {
      // Clear remote first
      await _remoteDataSource.deleteUserSavedWallpapers();

      // Also clear local cache
      await _localDataSource.clearAllFavorites();
    } catch (e, stack) {
      log(
        'Error deleting user saved wallpapers: $e',
        error: e,
        stackTrace: stack,
        name: 'FavoritesRepositoryImpl.deleteUserSavedWallpapers',
      );
      rethrow;
    }
  }

  // Helper method to sync local cache with remote data
  Future<void> _syncLocalWithRemote(List<FavoriteModel> remoteFavorites) async {
    try {
      // Get current local favorites
      final localFavorites = await _localDataSource.getFavoriteWallpapers();

      // Get remote wallpaper IDs
      final remoteWallpaperIds =
          remoteFavorites.map((f) => f.uid.split(':')[0]).toSet();

      // Remove local favorites that are not in remote
      for (final localFavorite in localFavorites) {
        if (!remoteWallpaperIds.contains(localFavorite.id)) {
          await _localDataSource.removeFromFavorites(localFavorite.id);
        }
      }

      // For remote favorites that aren't in local cache, we would need to:
      // 1. Fetch the full wallpaper data from the wallpaper API
      // 2. Convert to FavoriteWallpaperModel
      // 3. Add to local cache
      //
      // Since we don't have the wallpaper data in the favorite model,
      // we'll skip this for now and rely on the user's local interactions
      // to populate the cache over time
    } catch (e, stack) {
      // Silently fail sync - not critical for functionality

      log(
        'Error syncing local with remote: $e',
        error: e,
        stackTrace: stack,
        name: 'FavoritesRepositoryImpl._syncLocalWithRemote',
      );
    }
  }
}
