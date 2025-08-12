import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  const ApiConstants._();

  // Pexels API
  static const String pexelsBaseUrl = 'https://api.pexels.com/v1/';
  static String? pexelsApiKey = dotenv.env['PEXELS_API_KEY'] ?? '';


  static String? pexelsApiHost = dotenv.env['PEXELS_API_HOST'];
  static String? wallhavenApiHost = dotenv.env['WALLHAVEN_API_HOST'];

  // Wallhaven API
  static const String wallhavenBaseUrl = 'https://wallhaven.cc/api/v1/';
  static String? wallhavenApiKey = dotenv.env['WALLHAVEN_API_KEY'] ?? '';

  // Custom Auth API (Strapi backend)
  static  String? customApiUrl = dotenv.env['CUSTOM_API_URL'];

  // Common endpoints
  static const String searchEndpoint = 'search';
  static const String curatedEndpoint = 'curated';

  // Request limits
  static const int defaultPageSize = 20;
  static const int maxPageSize = 80;
}
