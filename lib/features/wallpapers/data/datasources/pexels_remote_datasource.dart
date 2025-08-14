import 'package:injectable/injectable.dart';
import 'package:wallinice/core/constants/constants.dart';
import 'package:wallinice/core/errors/errors.dart';
import 'package:wallinice/core/network/network.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

abstract class PexelsRemoteDataSource {
  Future<List<PexelsWallpaperModel>> getCuratedWallpapers({
    int page = 1,
    int perPage = ApiConstants.defaultPageSize,
  });

  Future<List<PexelsWallpaperModel>> searchWallpapers({
    required String query,
    int page = 1,
    int perPage = ApiConstants.defaultPageSize,
    String? color,
  });

  Future<List<PexelsWallpaperModel>> getWallpapersByColor({
    required String color,
    int page = 1,
    int perPage = ApiConstants.defaultPageSize,
  });

  Future<PexelsWallpaperModel> getWallpaperById(String id);
}

@LazySingleton(as: PexelsRemoteDataSource)
class PexelsRemoteDataSourceImpl implements PexelsRemoteDataSource {
  PexelsRemoteDataSourceImpl(this._networkClient);

  final NetworkClient _networkClient;

  @override
  Future<List<PexelsWallpaperModel>> getCuratedWallpapers({
    int page = 1,
    int perPage = ApiConstants.defaultPageSize,
  }) async {
    try {
      final response = await _networkClient.get(
        '${ApiConstants.pexelsBaseUrl}curated',
        queryParameters: {
          'page': page.toString(),
          'per_page': perPage.toString(),
        },
        headers: {
          'Authorization': ApiConstants.pexelsApiKey!,
        },
      );

      final pexelsResponse = PexelsResponse.fromJson(response);
      return pexelsResponse.photos;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e, stack) {
      print('Error: $e, $stack');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PexelsWallpaperModel>> searchWallpapers({
    required String query,
    int page = 1,
    int perPage = ApiConstants.defaultPageSize,
    String? color,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'query': query,
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      if (color != null && color.isNotEmpty) {
        queryParameters['color'] = color;
      }

      final response = await _networkClient.get(
        '${ApiConstants.pexelsBaseUrl}search',
        queryParameters: queryParameters,
        headers: {
          'Authorization': ApiConstants.pexelsApiKey!,
        },
      );

      final pexelsResponse = PexelsResponse.fromJson(response);
      return pexelsResponse.photos;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PexelsWallpaperModel>> getWallpapersByColor({
    required String color,
    int page = 1,
    int perPage = ApiConstants.defaultPageSize,
  }) async {
    try {
      final response = await _networkClient.get(
        '${ApiConstants.pexelsBaseUrl}search',
        queryParameters: {
          'query': color,
          'color': color,
          'page': page.toString(),
          'per_page': perPage.toString(),
        },
        headers: {
          'Authorization': ApiConstants.pexelsApiKey!,
        },
      );

      final pexelsResponse = PexelsResponse.fromJson(response);
      return pexelsResponse.photos;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PexelsWallpaperModel> getWallpaperById(String id) async {
    try {
      final response = await _networkClient.get(
        '${ApiConstants.pexelsBaseUrl}photos/$id',
        headers: {
          'Authorization': ApiConstants.pexelsApiKey!,
        },
      );

      return PexelsWallpaperModel.fromJson(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
