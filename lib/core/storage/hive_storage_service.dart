import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:wallinice/core/storage/storage.dart';
import 'package:wallinice/features/favorites/data/models/favorite_wallpaper_model.dart';
import 'package:wallinice/features/wallpapers/data/models/wallpaper_model.dart';

@LazySingleton(as: StorageService)
class HiveStorageService implements StorageService {
  static const String _appDocumentDir = 'nice_wall';
  bool _isInitialized = false;
  final Map<String, StreamController<List<dynamic>>> _streamControllers = {};

  @override
  bool get isInitialized => _isInitialized;

  @override
  @PostConstruct()
  Future<void> initialize() async {
    if (_isInitialized) return;

     await Hive.initFlutter(_appDocumentDir);

    // Register adapters only once
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WallpaperModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FavoriteWallpaperModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(WallpaperSrcModelAdapter());
    }

    _isInitialized = true;
  }

  @override
  Future<void> clearAllData() async {
    if (!_isInitialized) {
      throw StateError('Storage service not initialized');
    }

    // Close all boxes and stream controllers
    for (final controller in _streamControllers.values) {
      await controller.close();
    }
    _streamControllers.clear();

    await Hive.close();
    await Hive.deleteFromDisk();

    _isInitialized = false;
    await initialize();
  }

  @override
  Future<void> put<T>(String collection, String key, T value) async {
    final box = await _getBox<T>(collection);
    await box.put(key, value);
    _notifyListeners(collection);
  }

  @override
  Future<T?> get<T>(String collection, String key) async {
    final box = await _getBox<T>(collection);
    final value = box.get(key);
    return value as T?;
  }

  @override
  Future<List<T>> getAll<T>(String collection) async {
    final box = await _getBox<T>(collection);
    return box.values.cast<T>().toList();
  }

  @override
  Future<void> delete(String collection, String key) async {
    final box = await _getBox<dynamic>(collection);
    await box.delete(key);
    _notifyListeners(collection);
  }

  @override
  Future<void> clear(String collection) async {
    final box = await _getBox<dynamic>(collection);
    await box.clear();
    _notifyListeners(collection);
  }

  @override
  Future<bool> containsKey(String collection, String key) async {
    final box = await _getBox<dynamic>(collection);
    return box.containsKey(key);
  }

  @override
  Future<int> count(String collection) async {
    final box = await _getBox<dynamic>(collection);
    return box.length;
  }

  @override
  Stream<List<T>> watch<T>(String collection) async* {
    // Ensure box is opened and listening
    await _getBox<T>(collection);

    if (!_streamControllers.containsKey(collection)) {
      _streamControllers[collection] =
          StreamController<List<dynamic>>.broadcast();
    }

    // Emit current values first
    yield await getAll<T>(collection);

    // Then emit updates
    yield* _streamControllers[collection]!.stream.cast<List<T>>();
  }

  /// Get a specific box, ensuring it's opened
  /// Always use Box<dynamic> to avoid type conflicts
  Future<Box<dynamic>> _getBox<T>(String boxName) async {
    if (!_isInitialized) {
      throw StateError('Storage service not initialized');
    }

    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<dynamic>(boxName);
    }

    final box = await Hive.openBox<dynamic>(boxName);

    // Set up listener for this box if not already done
    if (!_streamControllers.containsKey(boxName)) {
      _streamControllers[boxName] = StreamController<List<dynamic>>.broadcast();
      box.watch().listen((event) {
        _notifyListeners(boxName);
      });
    }

    return box;
  }

  void _notifyListeners(String collection) {
    if (_streamControllers.containsKey(collection)) {
      // Get current values and notify
      _getBox<dynamic>(collection).then((box) {
        _streamControllers[collection]!.add(box.values.toList());
      });
    }
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    for (final controller in _streamControllers.values) {
      await controller.close();
    }
    _streamControllers.clear();

    await Hive.close();
    _isInitialized = false;
  }
}
