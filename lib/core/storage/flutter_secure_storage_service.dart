import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:wallinice/core/storage/storage.dart';

@LazySingleton(as: SecureStorageService)
class FlutterSecureStorageService implements SecureStorageService {
  // Constructor initializes immediately -
  // no async needed for FlutterSecureStorage
  FlutterSecureStorageService() {
    _secureStorage = const FlutterSecureStorage(
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
    _isInitialized = true;
  }

  late final FlutterSecureStorage _secureStorage;
  bool _isInitialized = false;

  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    sharedPreferencesName: 'wallinice_secure_prefs',
    preferencesKeyPrefix: 'wallinice_',
  );

  static const IOSOptions _iosOptions = IOSOptions(
    accountName: 'wallinice_keychain',
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    // Already initialized in constructor, but keep method for interface compliance
  }

  @override
  Future<void> write({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async {
    return _secureStorage.read(key: key);
  }

  @override
  Future<Map<String, String>> readAll() async {
    return _secureStorage.readAll();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _secureStorage.containsKey(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }

  @override
  Future<Set<String>> getAllKeys() async {
    final allData = await _secureStorage.readAll();
    return allData.keys.toSet();
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    // FlutterSecureStorage doesn't require explicit disposal
    _isInitialized = false;
  }

  // Helper methods for common storage patterns

  /// Store JSON data as a string
  Future<void> writeJson({
    required String key,
    required Map<String, dynamic> json,
  }) async {
    final jsonString = jsonEncode(json);
    await write(key: key, value: jsonString);
  }

  /// Read JSON data from storage
  Future<Map<String, dynamic>?> readJson({required String key}) async {
    final jsonString = await read(key: key);
    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      // Invalid JSON, return null
      return null;
    }
  }

  /// Store a boolean value
  Future<void> writeBool({required String key, required bool value}) async {
    await write(key: key, value: value.toString());
  }

  /// Read a boolean value
  Future<bool?> readBool({required String key}) async {
    final value = await read(key: key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  /// Store an integer value
  Future<void> writeInt({required String key, required int value}) async {
    await write(key: key, value: value.toString());
  }

  /// Read an integer value
  Future<int?> readInt({required String key}) async {
    final value = await read(key: key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  /// Store a double value
  Future<void> writeDouble({required String key, required double value}) async {
    await write(key: key, value: value.toString());
  }

  /// Read a double value
  Future<double?> readDouble({required String key}) async {
    final value = await read(key: key);
    if (value == null) return null;
    return double.tryParse(value);
  }
}
