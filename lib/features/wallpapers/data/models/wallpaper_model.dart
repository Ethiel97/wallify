import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

part 'wallpaper_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class WallpaperModel extends HiveObject with EquatableMixin {
  WallpaperModel({
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
    this.tags = const [],
    this.source = 'pexels',
    this.dominantColors = const [],
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) =>
      _$WallpaperModelFromJson(json);

  factory WallpaperModel.fromEntity(Wallpaper wallpaper) {
    return WallpaperModel(
      id: wallpaper.id,
      url: wallpaper.url,
      photographer: wallpaper.photographer,
      photographerUrl: wallpaper.photographerUrl,
      src: WallpaperSrcModel.fromEntity(wallpaper.src),
      alt: wallpaper.alt,
      avgColor: wallpaper.avgColor,
      width: wallpaper.width,
      height: wallpaper.height,
      liked: wallpaper.liked,
      views: wallpaper.views,
      favorites: wallpaper.favorites,
      category: wallpaper.category,
      resolution: wallpaper.resolution,
      fileSize: wallpaper.fileSize,
      tags: wallpaper.tags ?? [],
      source: wallpaper.source,
      dominantColors: wallpaper.dominantColors,
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String photographer;

  @HiveField(3)
  final String photographerUrl;

  @HiveField(4)
  final WallpaperSrcModel src;

  @HiveField(5)
  final String alt;

  @HiveField(6)
  final String? avgColor;

  @HiveField(7)
  final int? width;

  @HiveField(8)
  final int? height;

  @HiveField(9)
  final bool liked;

  @HiveField(10)
  final int? views;

  @HiveField(11)
  final int? favorites;

  @HiveField(12)
  final String? category;

  @HiveField(13)
  final String? resolution;

  @HiveField(14)
  final int? fileSize;

  @HiveField(15)
  final List<String> tags;

  @HiveField(16)
  final String source;

  @HiveField(17)
  final List<String> dominantColors;

  Map<String, dynamic> toJson() => _$WallpaperModelToJson(this);

  Wallpaper toEntity() {
    return Wallpaper(
      id: id,
      url: url,
      photographer: photographer,
      photographerUrl: photographerUrl,
      src: src.toEntity(),
      alt: alt,
      avgColor: avgColor,
      width: width,
      height: height,
      liked: liked,
      views: views,
      favorites: favorites,
      category: category,
      resolution: resolution,
      fileSize: fileSize,
      tags: tags,
      source: source,
      dominantColors: dominantColors,
    );
  }

  @override
  List<Object?> get props => [
        id,
        url,
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
        dominantColors,
      ];
}

@HiveType(typeId: 2)
@JsonSerializable()
class WallpaperSrcModel extends Equatable {
  const WallpaperSrcModel({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory WallpaperSrcModel.fromJson(Map<String, dynamic> json) =>
      _$WallpaperSrcModelFromJson(json);

  factory WallpaperSrcModel.fromEntity(WallpaperSrc src) {
    return WallpaperSrcModel(
      original: src.original,
      large2x: src.large2x,
      large: src.large,
      medium: src.medium,
      small: src.small,
      portrait: src.portrait,
      landscape: src.landscape,
      tiny: src.tiny,
    );
  }

  @HiveField(0)
  final String original;

  @HiveField(1)
  final String large2x;

  @HiveField(2)
  final String large;

  @HiveField(3)
  final String medium;

  @HiveField(4)
  final String small;

  @HiveField(5)
  final String portrait;

  @HiveField(6)
  final String landscape;

  @HiveField(7)
  final String tiny;

  Map<String, dynamic> toJson() => _$WallpaperSrcModelToJson(this);

  WallpaperSrc toEntity() {
    return WallpaperSrc(
      original: original,
      large2x: large2x,
      large: large,
      medium: medium,
      small: small,
      portrait: portrait,
      landscape: landscape,
      tiny: tiny,
    );
  }

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
