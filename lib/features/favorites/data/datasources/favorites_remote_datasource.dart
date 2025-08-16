import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:wallinice/core/constants/api_constants.dart';
import 'package:wallinice/core/errors/exceptions.dart';
import 'package:wallinice/core/network/network_client.dart';
import 'package:wallinice/features/favorites/data/models/favorite_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<FavoriteModel>> getUserSavedWallpapers();

  Future<void> saveWallpaper(String wallpaperId);

  Future<void> deleteSavedWallpaper(String wallpaperId);

  Future<void> deleteUserSavedWallpapers();
}

@LazySingleton(as: FavoritesRemoteDataSource)
class FavoritesDataSourceImpl implements FavoritesRemoteDataSource {
  FavoritesDataSourceImpl(this._networkClient);

  final NetworkClient _networkClient;

  @override
  Future<List<FavoriteModel>> getUserSavedWallpapers() async {
    try {
      final response = await _networkClient.get(
        '${ApiConstants.customApiUrl}saved-wallpapers/user',
      );

      final data = response['data'] as List<dynamic>? ?? [];

      log(
        'Fetched ${data.length} saved wallpapers from API',
        name: 'FavoritesDataSourceImpl.getUserSavedWallpapers',
      );

      return data
          .map(
            (item) =>
                FavoriteModel.fromApiResponse(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e, stack) {
      log(
        'Error fetching saved wallpapers: $e',
        stackTrace: stack,
        name: 'FavoritesDataSourceImpl.getUserSavedWallpapers',
      );
      throw NetworkException('Failed to fetch saved wallpapers: $e');
    }
  }

  @override
  Future<void> saveWallpaper(String wallpaperId) async {
    try {
      await _networkClient.post(
        '${ApiConstants.customApiUrl}saved-wallpapers',
        data: {
          'data': {'uid': wallpaperId},
        },
      );
    } catch (e) {
      throw NetworkException('Failed to save wallpaper: $e');
    }
  }

  @override
  Future<void> deleteSavedWallpaper(String wallpaperId) async {
    try {
      await _networkClient.delete(
        '${ApiConstants.customApiUrl}saved-wallpapers/remove/$wallpaperId',
      );
    } catch (e) {
      throw NetworkException('Failed to delete saved wallpaper: $e');
    }
  }

  @override
  Future<void> deleteUserSavedWallpapers() async {
    try {
      await _networkClient.delete(
        '${ApiConstants.customApiUrl}saved-wallpapers/remove',
      );
    } catch (e) {
      throw NetworkException('Failed to delete user saved wallpapers: $e');
    }
  }
}
