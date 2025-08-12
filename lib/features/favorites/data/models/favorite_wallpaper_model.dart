import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

part 'favorite_wallpaper_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class FavoriteWallpaperModel extends WallpaperModel {
  FavoriteWallpaperModel({
    required super.id,
    required super.url,
    required super.photographer,
    required super.photographerUrl,
    required super.src,
    required this.savedAt,
    super.alt,
    super.avgColor,
    super.width,
    super.height,
    super.liked,
    super.views,
    super.favorites,
    super.category,
    super.resolution,
    super.fileSize,
    super.tags,
    super.source,
    super.dominantColors,
  });

  factory FavoriteWallpaperModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteWallpaperModelFromJson(json);

  factory FavoriteWallpaperModel.fromWallpaper(Wallpaper wallpaper) {
    final baseModel = WallpaperModel.fromEntity(wallpaper);
    return FavoriteWallpaperModel(
      id: baseModel.id,
      url: baseModel.url,
      photographer: baseModel.photographer,
      photographerUrl: baseModel.photographerUrl,
      src: baseModel.src,
      alt: baseModel.alt,
      avgColor: baseModel.avgColor,
      width: baseModel.width,
      height: baseModel.height,
      liked: baseModel.liked,
      views: baseModel.views,
      favorites: baseModel.favorites,
      category: baseModel.category,
      resolution: baseModel.resolution,
      fileSize: baseModel.fileSize,
      tags: baseModel.tags,
      source: baseModel.source,
      dominantColors: baseModel.dominantColors,
      savedAt: DateTime.now(),
    );
  }

  @HiveField(18)
  final DateTime savedAt;

  @override
  Map<String, dynamic> toJson() => _$FavoriteWallpaperModelToJson(this);

  @override
  List<Object?> get props => [...super.props, savedAt];
}
