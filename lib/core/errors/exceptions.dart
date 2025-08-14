class ServerException implements Exception {
  const ServerException([this.message]);

  final String? message;

  @override
  String toString() {
    return 'ServerException -> $message';
  }
}

class NetworkException implements Exception {
  const NetworkException([this.message]);

  final String? message;

  @override
  String toString() {
    return 'NetworkException -> $message';
  }
}

class CacheException implements Exception {
  const CacheException([this.message]);

  final String? message;

  @override
  String toString() {
    return 'CacheException -> $message';
  }
}

class AuthException implements Exception {
  const AuthException([this.message]);

  final String? message;

  @override
  String toString() {
    return 'AuthException -> $message';
  }
}
