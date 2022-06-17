import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static double kBorderRadius = 20;
  static int kDuration = 300;
  static String appName = "Wallify";
  static int perPageResults = 15;
  static String? pexelsApiKey = dotenv.env['PEXELS_API_KEY'];
  static String? pexelsApiHost = dotenv.env['PEXELS_API_HOST'];
  static String? wallhavenApiKey = dotenv.env['WALLHAVEN_API_KEY'];
  static String? wallhavenApiHost = dotenv.env['WALLHAVEN_API_HOST'];
}
