import 'package:injectable/injectable.dart';
import 'package:wallinice/core/errors/errors.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

@LazySingleton(as: WallpaperRepository)
class WallpaperRepositoryImpl implements WallpaperRepository {
  const WallpaperRepositoryImpl(
    this._pexelsRemoteDataSource,
    this._wallhavenRemoteDataSource,
  );

  final PexelsRemoteDataSource _pexelsRemoteDataSource;
  final WallhavenRemoteDataSource _wallhavenRemoteDataSource;

  @override
  Future<List<Wallpaper>> getCuratedWallpapers({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      // Get from both sources and combine them
      final pexelsWallpapers =
          await _pexelsRemoteDataSource.getCuratedWallpapers(
        page: page,
        perPage: perPage ~/ 2, // Half from each source
      );

      final wallhavenWallpapers =
          await _wallhavenRemoteDataSource.searchWallpapers(
        page: page,
        perPage: perPage ~/ 2,
      );

      final allWallpapers = <Wallpaper>[
        ...pexelsWallpapers.map((model) => model.toEntity()),
        ...wallhavenWallpapers.map((model) => model.toEntity()),
      ];

      return allWallpapers;
    } catch (e, stack) {
      print('Error: $e\n $stack');

      // Fallback to just Pexels if Wallhaven fails
      try {
        final pexelsWallpapers =
            await _pexelsRemoteDataSource.getCuratedWallpapers(
          page: page,
          perPage: perPage,
        );
        return pexelsWallpapers.map((model) => model.toEntity()).toList();
      } catch (e, stack) {
        print('Error: $e\n $stack');
        throw ServerException(e.toString());
      }
    }
  }

  @override
  Future<List<Wallpaper>> searchWallpapers({
    required String query,
    int page = 1,
    int perPage = 20,
    String? color,
  }) async {
    try {
      // Search in both sources
      final futures = await Future.wait([
        _pexelsRemoteDataSource
            .searchWallpapers(
              query: query,
              page: page,
              perPage: perPage ~/ 2,
              color: color,
            )
            .catchError((e) => <PexelsWallpaperModel>[]),
        _wallhavenRemoteDataSource
            .searchWallpapers(
              query: query,
              page: page,
              perPage: perPage ~/ 2,
              color: color,
            )
            .catchError((e) => <WallhavenWallpaperModel>[]),
      ]);

      final allWallpapers = <Wallpaper>[
        ...futures[0]
            .map((model) => (model as PexelsWallpaperModel).toEntity()),
        ...futures[1]
            .map((model) => (model as WallhavenWallpaperModel).toEntity()),
      ];

      if (allWallpapers.isEmpty) {
        throw ServerException('No wallpapers found for query: $query');
      }

      return allWallpapers;
    } catch (e, stack) {
      print("Search error: $e\n $stack");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Wallpaper>> getWallpapersByColor({
    required String color,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final futures = await Future.wait([
        _pexelsRemoteDataSource
            .getWallpapersByColor(
              color: color,
              page: page,
              perPage: perPage ~/ 2,
            )
            .catchError((e) => <PexelsWallpaperModel>[]),
        _wallhavenRemoteDataSource
            .searchWallpapers(
              color: color,
              page: page,
              perPage: perPage ~/ 2,
            )
            .catchError((e) => <WallhavenWallpaperModel>[]),
      ]);

      final allWallpapers = <Wallpaper>[
        ...futures[0].map(
          (model) => (model as PexelsWallpaperModel).toEntity(),
        ),
        ...futures[1].map(
          (model) => (model as WallhavenWallpaperModel).toEntity(),
        ),
      ];

      return allWallpapers;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Wallpaper> getWallpaperById(String id) async {
    try {
      // Try to determine source from ID format and fetch accordingly
      if (id.contains('pexels') || int.tryParse(id) != null) {
        // Likely a Pexels ID
        final model = await _pexelsRemoteDataSource.getWallpaperById(id);
        return model.toEntity();
      } else {
        // Likely a Wallhaven ID
        final model = await _wallhavenRemoteDataSource.getWallpaperById(id);
        return model.toEntity();
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
