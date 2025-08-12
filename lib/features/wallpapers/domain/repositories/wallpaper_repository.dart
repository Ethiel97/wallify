import 'package:wallinice/features/wallpapers/wallpapers.dart';

abstract class WallpaperRepository {
  Future<List<Wallpaper>> getCuratedWallpapers({
    int page = 1,
    int perPage = 20,
  });

  Future<List<Wallpaper>> searchWallpapers({
    required String query,
    int page = 1,
    int perPage = 20,
    String? color,
  });

  Future<List<Wallpaper>> getWallpapersByColor({
    required String color,
    int page = 1,
    int perPage = 20,
  });

  Future<Wallpaper> getWallpaperById(String id);

  /// Downloads a wallpaper image to device storage
  Future<String> downloadWallpaper({
    required Wallpaper wallpaper,
    void Function(double progress)? onProgress,
  });

  /// Shares a wallpaper with options to include image or just the link
  Future<void> shareWallpaper({
    required Wallpaper wallpaper,
    bool includeImage = true,
    String? customMessage,
  });
}
