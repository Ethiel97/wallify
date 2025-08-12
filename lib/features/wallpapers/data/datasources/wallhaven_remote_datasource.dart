import 'package:injectable/injectable.dart';
import 'package:wallinice/core/constants/constants.dart';
import 'package:wallinice/core/errors/errors.dart';
import 'package:wallinice/core/network/network.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

abstract class WallhavenRemoteDataSource {
  Future<List<WallhavenWallpaperModel>> searchWallpapers({
    String? query,
    int page = 1,
    int perPage = ApiConstants.defaultPageSize,
    String? color,
  });

  Future<WallhavenWallpaperModel> getWallpaperById(String id);
}

@LazySingleton(as: WallhavenRemoteDataSource)
class WallhavenRemoteDataSourceImpl implements WallhavenRemoteDataSource {
  WallhavenRemoteDataSourceImpl(this._networkClient);

  final NetworkClient _networkClient;

  @override
  Future<List<WallhavenWallpaperModel>> searchWallpapers({
    String? query,
    int page = 1,
    int perPage = ApiConstants.defaultPageSize,
    String? color,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page.toString(),
        'purity': '100', // SFW only
        'categories': '111', // General, Anime, People
        'sorting': 'relevance',
        'order': 'desc',
        'per_page': perPage.toString(),
      };

      if (query != null && query.isNotEmpty) {
        queryParameters['q'] = query;
      }

      if (color != null && color.isNotEmpty) {
        queryParameters['colors'] = color;
      }

      // Add API key if available
      if (ApiConstants.wallhavenApiKey != 'YOUR_WALLHAVEN_API_KEY') {
        queryParameters['apikey'] = ApiConstants.wallhavenApiKey;
      }

      final response = await _networkClient.get(
        '${ApiConstants.wallhavenBaseUrl}search',
        queryParameters: queryParameters,
      );

      final wallhavenResponse = WallhavenResponse.fromJson(response);
      return wallhavenResponse.data;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e, stack) {

      print('Error $e\n $stack');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<WallhavenWallpaperModel> getWallpaperById(String id) async {
    try {
      final queryParameters = <String, dynamic>{};

      // Add API key if available
      if (ApiConstants.wallhavenApiKey != 'YOUR_WALLHAVEN_API_KEY') {
        queryParameters['apikey'] = ApiConstants.wallhavenApiKey;
      }

      final response = await _networkClient.get(
        '${ApiConstants.wallhavenBaseUrl}w/$id',
        queryParameters: queryParameters,
      );

      return WallhavenWallpaperModel.fromJson(
          response['data'] as Map<String, dynamic>,);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
