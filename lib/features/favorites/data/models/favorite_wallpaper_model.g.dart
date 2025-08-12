// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_wallpaper_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteWallpaperModelAdapter
    extends TypeAdapter<FavoriteWallpaperModel> {
  @override
  final int typeId = 1;

  @override
  FavoriteWallpaperModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteWallpaperModel(
      id: fields[0] as String,
      url: fields[1] as String,
      photographer: fields[2] as String,
      photographerUrl: fields[3] as String,
      src: fields[4] as WallpaperSrcModel,
      savedAt: fields[18] as DateTime,
      alt: fields[5] as String,
      avgColor: fields[6] as String?,
      width: fields[7] as int?,
      height: fields[8] as int?,
      liked: fields[9] as bool,
      views: fields[10] as int?,
      favorites: fields[11] as int?,
      category: fields[12] as String?,
      resolution: fields[13] as String?,
      fileSize: fields[14] as int?,
      tags: (fields[15] as List).cast<String>(),
      source: fields[16] as String,
      dominantColors: (fields[17] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteWallpaperModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(18)
      ..write(obj.savedAt)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.photographer)
      ..writeByte(3)
      ..write(obj.photographerUrl)
      ..writeByte(4)
      ..write(obj.src)
      ..writeByte(5)
      ..write(obj.alt)
      ..writeByte(6)
      ..write(obj.avgColor)
      ..writeByte(7)
      ..write(obj.width)
      ..writeByte(8)
      ..write(obj.height)
      ..writeByte(9)
      ..write(obj.liked)
      ..writeByte(10)
      ..write(obj.views)
      ..writeByte(11)
      ..write(obj.favorites)
      ..writeByte(12)
      ..write(obj.category)
      ..writeByte(13)
      ..write(obj.resolution)
      ..writeByte(14)
      ..write(obj.fileSize)
      ..writeByte(15)
      ..write(obj.tags)
      ..writeByte(16)
      ..write(obj.source)
      ..writeByte(17)
      ..write(obj.dominantColors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteWallpaperModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteWallpaperModel _$FavoriteWallpaperModelFromJson(
        Map<String, dynamic> json) =>
    FavoriteWallpaperModel(
      id: json['id'] as String,
      url: json['url'] as String,
      photographer: json['photographer'] as String,
      photographerUrl: json['photographerUrl'] as String,
      src: WallpaperSrcModel.fromJson(json['src'] as Map<String, dynamic>),
      savedAt: DateTime.parse(json['savedAt'] as String),
      alt: json['alt'] as String? ?? '',
      avgColor: json['avgColor'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      liked: json['liked'] as bool? ?? false,
      views: (json['views'] as num?)?.toInt(),
      favorites: (json['favorites'] as num?)?.toInt(),
      category: json['category'] as String?,
      resolution: json['resolution'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      source: json['source'] as String? ?? 'pexels',
      dominantColors: (json['dominantColors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FavoriteWallpaperModelToJson(
        FavoriteWallpaperModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'photographer': instance.photographer,
      'photographerUrl': instance.photographerUrl,
      'src': instance.src,
      'alt': instance.alt,
      'avgColor': instance.avgColor,
      'width': instance.width,
      'height': instance.height,
      'liked': instance.liked,
      'views': instance.views,
      'favorites': instance.favorites,
      'category': instance.category,
      'resolution': instance.resolution,
      'fileSize': instance.fileSize,
      'tags': instance.tags,
      'source': instance.source,
      'dominantColors': instance.dominantColors,
      'savedAt': instance.savedAt.toIso8601String(),
    };
