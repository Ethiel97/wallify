import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const double kBorderRadius = 20;
  static const int kDuration = 200;
  static const String appName = "Wallinice";
  static const int perPageResults = 20;
  static String? pexelsApiKey = dotenv.env['PEXELS_API_KEY'];
  static String? pexelsApiHost = dotenv.env['PEXELS_API_HOST'];
  static String? wallhavenApiKey = dotenv.env['WALLHAVEN_API_KEY'];
  static String? wallhavenApiHost = dotenv.env['WALLHAVEN_API_HOST'];

  static List<String> tags = {
    'Cars',
    'Minimalism',
    'Food',
    'Fitness',
    'Portrait',
    'Fashion',
    'Animals',
    'People',
    'Buildings',
    'Mountains',
    'Music',
    'Nature',
    'Science',
    'Comics',
    'Travel',
    'Transport',
    'Kids',
    'Games',
    'Fruits',
    'Patterns',
    'Robots',
    'Ninja',
    'Sports',
    'Graphic',
    'Wedding',
    'Flowers',
    'Abstract',
    'Manga',
    'Technology',
    'Basketball',
    'Football'
  }.toList()
    ..shuffle();
}

enum WallPaperProvider {
  pexels,
  wallhaven;

  String get description => name;
}
