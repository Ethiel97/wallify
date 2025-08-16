import '../storage/secure_storage_constants.dart';
import '../storage/secure_storage_service.dart';

/// Extension methods for common network operations
extension NetworkExtensions on Object {
  /// Helper method to manually add auth token to headers if needed
  static Future<Map<String, String>> getAuthHeaders(
    SecureStorageService secureStorage, {
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?additionalHeaders,
    };

    try {
      final token = await secureStorage.read(
        key: SecureStorageConstants.authToken,
      );

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Ignore token retrieval errors
    }

    return headers;
  }
}