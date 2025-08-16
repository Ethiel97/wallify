/// Abstract interface for secure storage operations
///
/// This abstraction allows for easy testing and swapping of secure storage implementations
/// Designed for storing sensitive data like tokens, credentials, and user secrets
abstract class SecureStorageService {
  /// Initialize the secure storage service
  Future<void> initialize();

  /// Check if the secure storage service is initialized
  bool get isInitialized;

  /// Store a string value with a key securely
  Future<void> write({required String key, required String value});

  /// Read a string value by key from secure storage
  Future<String?> read({required String key});

  /// Read all keys and values from secure storage
  Future<Map<String, String>> readAll();

  /// Check if a key exists in secure storage
  Future<bool> containsKey(String key);

  /// Delete a value by key from secure storage
  Future<void> delete({required String key});

  /// Delete all values from secure storage
  Future<void> deleteAll();

  /// Get all keys from secure storage
  Future<Set<String>> getAllKeys();

  /// Dispose resources
  Future<void> dispose();
}
