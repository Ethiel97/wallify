import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:wallinice/core/storage/storage.dart';

@injectable
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final SecureStorageService _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Get the JWT token from secure storage
      final token = await _secureStorage.read(
        key: SecureStorageConstants.authToken,
      );

      // Add Authorization header if token exists
      if (token != null && token.isNotEmpty) {
        //add token if url contains koyeb

        if (options.path.contains('koyeb')) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }

      // Continue with the request
      handler.next(options);
    } catch (e) {
      // If token retrieval fails, continue without authorization header
      // Log the error in production apps
      handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - token might be expired
    if (err.response?.statusCode == 401) {
      // You might want to trigger a token refresh or logout here
      // For now, just pass through the error
      // _handleUnauthorized();
    }

    handler.next(err);
  }

  Future<void> _handleUnauthorized() async {
    // Optional: Clear expired token
    try {
      await _secureStorage.delete(key: SecureStorageConstants.authToken);
    } catch (e) {
      // Ignore errors when clearing token
    }

    // You could emit an event here to trigger logout in your app
    // Example: EventBus.instance.fire(UnauthorizedEvent());
  }
}
