import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const double kBorderRadius = 20;
  static const int kDuration = 300;
  static const String appName = "Wallinice";
  static const int perPageResults = 20;
  static String? pexelsApiKey = dotenv.env['PEXELS_API_KEY'];
  static String? pexelsApiHost = dotenv.env['PEXELS_API_HOST'];
  static String? wallhavenApiKey = dotenv.env['WALLHAVEN_API_KEY'];
  static String? wallhavenApiHost = dotenv.env['WALLHAVEN_API_HOST'];

  static List<String>  pexelsTags = ['Cars', 'People', 'Buildings','Mountains'];
}

enum WallPaperProvider {
  pexels,
  wallhaven,
}
