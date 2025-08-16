import 'dart:convert';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:wallinice/core/errors/errors.dart';
import 'package:wallinice/core/storage/storage.dart';
import 'package:wallinice/features/auth/auth.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);

  Future<String?> getToken();

  Future<void> saveUser(UserModel user);

  Future<UserModel?> getUser();

  Future<void> clearAuthData();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._secureStorage);

  final SecureStorageService _secureStorage;

  @override
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(
        key: SecureStorageConstants.authToken,
        value: token,
      );
    } catch (e) {
      throw CacheException('Failed to save token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: SecureStorageConstants.authToken);
    } catch (e) {
      throw CacheException('Failed to get token: $e');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _secureStorage.write(
        key: SecureStorageConstants.user,
        value: userJson,
      );
    } catch (e) {
      throw CacheException('Failed to save user: $e');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userJson = await _secureStorage.read(
        key: SecureStorageConstants.user,
      );
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get user: $e');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await _secureStorage.delete(key: SecureStorageConstants.authToken);
      await _secureStorage.delete(key: SecureStorageConstants.user);
    } catch (e, stackTrace) {
      log(
        'Error clearing auth data: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'AuthLocalDataSourceImpl.clearAuthData',
      );
      throw CacheException('Failed to clear auth data: $e');
    }
  }
}
