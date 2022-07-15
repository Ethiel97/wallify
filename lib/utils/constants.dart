import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:tinycolor2/tinycolor2.dart';

class Constants {
  static const double kBorderRadius = 15;
  static const int kDuration = 130;
  static const String appName = "Wallinice";
  static const int perPageResults = 32;
  static String? pexelsApiKey = dotenv.env['PEXELS_API_KEY'];
  static String? pexelsApiHost = dotenv.env['PEXELS_API_HOST'];
  static String? wallhavenApiKey = dotenv.env['WALLHAVEN_API_KEY'];
  static String? wallhavenApiHost = dotenv.env['WALLHAVEN_API_HOST'];
  static const String randomWallpaperTopic = "RANDOM_WALLPAPER";

  static String? customApiUrl = dotenv.env['CUSTOM_API_URL'];

  static const String savedWhWallpapersBox = 'whWallpapers';
  static const String savedPxWallpapersBox = 'pxWallpapers';

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
    'Landscape',
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

  static List<Color> colors = {
    const Color(0xff660000),
    const Color(0xff990000),
    const Color(0xffcc0000),
    const Color(0xffcc3333),
    const Color(0xffea4c88),
    const Color(0xff993399),
    const Color(0xff333399),
    const Color(0xff0066cc),
    const Color(0xff0099cc),
    const Color(0xff66cccc),
    const Color(0xff77cc33),
    const Color(0xff669900),
    const Color(0xff336600),
    const Color(0xff666600),
    const Color(0xff999900),
    const Color(0xffcccc33),
    const Color(0xffffcc33),
    const Color(0xffff9900),
    const Color(0xffff6600),
    const Color(0xffcc6633),
    const Color(0xff996633),
    const Color(0xff663300),
    const Color(0xff000000),
    const Color(0xff999999),
    const Color(0xffcccccc),
    const Color(0xffffffff),
    const Color(0xff424153),
  }.toList()
    ..shuffle();
}

enum WallPaperProvider {
  pexels,
  wallhaven;

  String get description => name;
}
