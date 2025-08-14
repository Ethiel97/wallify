import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

abstract class ShareService {
  /// Shares a wallpaper with options to include image or just the link
  Future<void> shareWallpaper({
    required Wallpaper wallpaper,
    bool includeImage = true,
    String? customMessage,
  });

  /// Shares just the wallpaper link with metadata
  Future<void> shareWallpaperLink({
    required Wallpaper wallpaper,
    String? customMessage,
  });

  /// Shares the wallpaper image file
  Future<void> shareWallpaperImage({
    required Wallpaper wallpaper,
    String? customMessage,
  });
}

@LazySingleton(as: ShareService)
class ShareServiceImpl implements ShareService {
  ShareServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> shareWallpaper({
    required Wallpaper wallpaper,
    bool includeImage = true,
    String? customMessage,
  }) async {
    if (includeImage) {
      await shareWallpaperImage(
        wallpaper: wallpaper,
        customMessage: customMessage,
      );
    } else {
      await shareWallpaperLink(
        wallpaper: wallpaper,
        customMessage: customMessage,
      );
    }
  }

  @override
  Future<void> shareWallpaperLink({
    required Wallpaper wallpaper,
    String? customMessage,
  }) async {
    try {
      final message = customMessage ?? _buildDefaultMessage(wallpaper);

      await Share.share(
        message,
        subject: 'Check out this amazing wallpaper!',
      );
    } catch (e) {
      throw Exception('Failed to share wallpaper link: $e');
    }
  }

  @override
  Future<void> shareWallpaperImage({
    required Wallpaper wallpaper,
    String? customMessage,
  }) async {
    try {
      // Download the image to a temporary file first
      final tempFile = await _downloadImageToTemp(wallpaper);

      final message = customMessage ?? _buildDefaultMessage(wallpaper);

      // Share the image file with the message
      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text: message,
        subject: 'Check out this amazing wallpaper!',
      );

      // Clean up the temporary file after sharing
      await _cleanupTempFile(tempFile);
    } catch (e) {
      throw Exception('Failed to share wallpaper image: $e');
    }
  }

  /// Downloads the wallpaper image to a temporary file for sharing
  Future<File> _downloadImageToTemp(Wallpaper wallpaper) async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();

      // Create a unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'wallpaper_share_${wallpaper.id}_$timestamp.jpg';
      final tempFile = File('${tempDir.path}/$fileName');

      // Download the image
      await _dio.download(
        wallpaper.url,
        tempFile.path,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(minutes: 3),
          sendTimeout: const Duration(minutes: 3),
        ),
      );

      return tempFile;
    } catch (e) {
      throw Exception('Failed to download image for sharing: $e');
    }
  }

  /// Builds a default share message for the wallpaper
  String _buildDefaultMessage(Wallpaper wallpaper) {
    final buffer = StringBuffer();

    buffer.writeln('🖼️ Amazing wallpaper by ${wallpaper.photographer}');

    if (wallpaper.width != null && wallpaper.height != null) {
      buffer.writeln('📏 ${wallpaper.width}x${wallpaper.height} resolution');
    }

    buffer.writeln();
    buffer.writeln('📱 Get more wallpapers with Wallinice app!');
    buffer.writeln('🔗 ${wallpaper.url}');

    return buffer.toString();
  }

  /// Cleans up temporary files after sharing
  Future<void> _cleanupTempFile(File tempFile) async {
    try {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (e) {
      // Log error but don't throw - cleanup failure shouldn't break sharing
      print('Warning: Failed to cleanup temp file: $e');
    }
  }
}
