import 'package:equatable/equatable.dart';

class Wallpaper extends Equatable {
  const Wallpaper({
    required this.id,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.src,
    this.alt = '',
    this.avgColor,
    this.width,
    this.height,
    this.liked = false,
    this.views,
    this.favorites,
    this.category,
    this.resolution,
    this.fileSize,
    this.tags,
    this.source = 'pexels',
    this.dominantColors = const [],
  });

  final String id;
  final String url;
  final String photographer;
  final String photographerUrl;
  final WallpaperSrc src;
  final String alt;
  final String? avgColor;
  final int? width;
  final int? height;
  final bool liked;

  // Additional properties for Wallhaven support
  final int? views;
  final int? favorites;
  final String? category;
  final String? resolution;
  final int? fileSize;
  final List<String>? tags;
  final List<String> dominantColors;
  final String source; // 'pexels' or 'wallhaven'

  Wallpaper copyWith({
    String? id,
    String? url,
    String? photographer,
    String? photographerUrl,
    WallpaperSrc? src,
    String? alt,
    String? avgColor,
    int? width,
    int? height,
    bool? liked,
    int? views,
    int? favorites,
    String? category,
    String? resolution,
    int? fileSize,
    List<String>? tags,
    List<String>? dominantColors,
    String? source,
  }) {
    return Wallpaper(
      id: id ?? this.id,
      url: url ?? this.url,
      photographer: photographer ?? this.photographer,
      photographerUrl: photographerUrl ?? this.photographerUrl,
      src: src ?? this.src,
      alt: alt ?? this.alt,
      avgColor: avgColor ?? this.avgColor,
      width: width ?? this.width,
      height: height ?? this.height,
      liked: liked ?? this.liked,
      views: views ?? this.views,
      favorites: favorites ?? this.favorites,
      category: category ?? this.category,
      resolution: resolution ?? this.resolution,
      fileSize: fileSize ?? this.fileSize,
      tags: tags ?? this.tags,
      dominantColors: dominantColors ?? this.dominantColors,
      source: source ?? this.source,
    );
  }

  @override
  List<Object?> get props => [
        id,
        url,
        dominantColors,
        photographer,
        photographerUrl,
        src,
        alt,
        avgColor,
        width,
        height,
        liked,
        views,
        favorites,
        category,
        resolution,
        fileSize,
        tags,
        source,
      ];
}

class WallpaperSrc extends Equatable {
  const WallpaperSrc({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  @override
  List<Object> get props => [
        original,
        large2x,
        large,
        medium,
        small,
        portrait,
        landscape,
        tiny,
      ];
}
