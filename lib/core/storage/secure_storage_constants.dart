/// Constants for secure storage keys
///
/// This class contains all the keys used for storing sensitive data
/// in the secure storage service
class SecureStorageConstants {
  SecureStorageConstants._();

  // Authentication related keys
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String user = 'user';
  static const String userEmail = 'user_email';
  static const String isFirstLaunch = 'is_first_launch';

  // User preferences (sensitive)
  static const String biometricEnabled = 'biometric_enabled';
  static const String autoSyncEnabled = 'auto_sync_enabled';

  // API credentials
  static const String apiKey = 'api_key';
  static const String apiSecret = 'api_secret';

  // Device specific
  static const String deviceId = 'device_id';
  static const String installationId = 'installation_id';
}
