import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:wallinice/core/network/auth_interceptor.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(AuthInterceptor authInterceptor) {
    final dio = Dio()
      ..options = BaseOptions(
        validateStatus: (status) {
          return status != null && (status >= 200 && status < 401);
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

    dio.interceptors.addAll([
      authInterceptor, // Add auth interceptor first
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ),
    ]);

    return dio;
  }
}
