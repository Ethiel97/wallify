import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();
const firstLaunch = 'FIRST_LAUNCH';
class SecureStorageService {
  static Future<void> saveItem({required String key, required String data}) async {
    await storage.write(key: key, value: data);

  }

  static Future<String?> readItem<T>({required String key}) async {
    final item = await storage.read(key: key);
    if (item == null) {
      return null;
      // throw "Unable to find item with the key : $key";
    }
    return item;
  }

  static Future<String?> readItemNullable<T>({required String key}) async {
    return await storage.read(key: key);
  }

  static Future<void> remove<T>({required String key}) async {
    await storage.delete(key: key);
    return;
  }
}
