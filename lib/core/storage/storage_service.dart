/// Abstract interface for local storage operations
///
/// This abstraction allows for easy testing and swapping of storage implementations
/// (Hive, SharedPreferences, SQLite, etc.)
abstract class StorageService {
  /// Initialize the storage service
  Future<void> initialize();

  /// Clear all stored data
  Future<void> clearAllData();

  /// Check if the storage service is initialized
  bool get isInitialized;

  /// Store an object with a key in a specific collection/box
  Future<void> put<T>(String collection, String key, T value);

  /// Get an object by key from a specific collection/box
  Future<T?> get<T>(String collection, String key);

  /// Get all objects from a specific collection/box
  Future<List<T>> getAll<T>(String collection);

  /// Remove an object by key from a specific collection/box
  Future<void> delete(String collection, String key);

  /// Clear all objects from a specific collection/box
  Future<void> clear(String collection);

  /// Check if a key exists in a specific collection/box
  Future<bool> containsKey(String collection, String key);

  /// Get count of objects in a specific collection/box
  Future<int> count(String collection);

  /// Watch for changes in a specific collection/box
  Stream<List<T>> watch<T>(String collection);

  /// Dispose resources
  void dispose();
}
