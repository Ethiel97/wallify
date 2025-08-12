import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class DownloadService {
  /// Downloads an image from the given URL and saves it to the device
  Future<String> downloadImage({
    required String imageUrl,
    required String fileName,
    void Function(double progress)? onProgress,
  });

  /// Checks if storage permission is granted
  Future<bool> hasStoragePermission();

  /// Requests storage permission
  Future<bool> requestStoragePermission();
}

@LazySingleton(as: DownloadService)
class DownloadServiceImpl implements DownloadService {
  DownloadServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<String> downloadImage({
    required String imageUrl,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    try {
      // Check and request permissions
      final hasPermission = await hasStoragePermission();
      if (!hasPermission) {
        final granted = await requestStoragePermission();
        if (!granted) {
          throw Exception('Storage permission denied');
        }
      }

      // Get download directory
      final downloadDir = await _getDownloadDirectory();
      final filePath = '${downloadDir.path}/$fileName';

      // Download the image
      final response = await _dio.download(
        imageUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0 && onProgress != null) {
            final progress = received / total;
            onProgress(progress);
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 5),
        ),
      );

      if (response.statusCode == 200) {
        return filePath;
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }

  @override
  Future<bool> hasStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 11+ (API 30+), we don't need WRITE_EXTERNAL_STORAGE
      // for app-specific directories
      if (await Permission.storage.isGranted ||
          await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      // For older Android versions
      return Permission.storage.isGranted;
    } else if (Platform.isIOS) {
      // iOS doesn't require explicit storage permission for Photos library
      // access but we need to check photos permission for saving to gallery
      return Permission.photos.isGranted;
    }

    return true; // For other platforms, assume permission is granted
  }

  @override
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Request appropriate permission based on Android version
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }

      return Permission.storage.request().isGranted;
    } else if (Platform.isIOS) {
      return Permission.photos.request().isGranted;
    }

    return true; // For other platforms, assume permission is granted
  }

  /// Gets the appropriate download directory based on platform
  Future<Directory> _getDownloadDirectory() async {
    /*if (Platform.isAndroid) {
      // Try to get external storage directory first
      try {
        final directory = Directory('/storage/emulated/0/Download/Wallinice');
        if (!directory.existsSync()) {
          await directory.create(recursive: true);
        }
        return directory;
      } catch (e) {
        // Fallback to app-specific external directory
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final downloadDir = Directory('${directory.path}/Downloads');
          if (!downloadDir.existsSync()) {
            await downloadDir.create(recursive: true);
          }
          return downloadDir;
        }
      }
    }*/

    // Fallback for iOS and when Android external storage is not available
    final directory = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${directory.path}/wallinice/Downloads');
    if (!downloadDir.existsSync()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }
}
