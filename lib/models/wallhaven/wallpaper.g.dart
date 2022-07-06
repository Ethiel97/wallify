// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WallPaperAdapter extends TypeAdapter<WallPaper> {
  @override
  final int typeId = 1;

  @override
  WallPaper read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WallPaper(
      id: fields[0] as String?,
      url: fields[1] as String?,
      shortUrl: fields[2] as String?,
      views: fields[3] as int?,
      ratio: fields[11] as String?,
      favorites: fields[4] as int?,
      category: fields[5] as String?,
      dimensionX: fields[6] as int?,
      dimensionY: fields[7] as int?,
      resolution: fields[8] as String?,
      fileSize: fields[9] as int?,
      colors: (fields[10] as List?)?.cast<String>(),
      path: fields[12] as String?,
      thumbs: fields[13] as WallPaperThumbs?,
      tags: (fields[14] as List?)?.cast<Tag>(),
      saved: fields[15] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, WallPaper obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.shortUrl)
      ..writeByte(3)
      ..write(obj.views)
      ..writeByte(4)
      ..write(obj.favorites)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.dimensionX)
      ..writeByte(7)
      ..write(obj.dimensionY)
      ..writeByte(8)
      ..write(obj.resolution)
      ..writeByte(9)
      ..write(obj.fileSize)
      ..writeByte(10)
      ..write(obj.colors)
      ..writeByte(11)
      ..write(obj.ratio)
      ..writeByte(12)
      ..write(obj.path)
      ..writeByte(13)
      ..write(obj.thumbs)
      ..writeByte(14)
      ..write(obj.tags)
      ..writeByte(15)
      ..write(obj.saved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallPaperAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallPaper _$WallPaperFromJson(Map<String, dynamic> json) => WallPaper(
      id: json['id'] as String?,
      url: json['url'] as String?,
      shortUrl: json['short_url'] as String?,
      views: json['views'] as int?,
      ratio: json['ratio'] as String?,
      favorites: json['favorites'] as int?,
      category: json['category'] as String?,
      dimensionX: json['dimension_x'] as int?,
      dimensionY: json['dimension_y'] as int?,
      resolution: json['resolution'] as String?,
      fileSize: json['file_size'] as int?,
      colors:
          (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      path: json['path'] as String?,
      thumbs: json['thumbs'] == null
          ? null
          : WallPaperThumbs.fromJson(json['thumbs'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      saved: json['saved'] as bool?,
    );

Map<String, dynamic> _$WallPaperToJson(WallPaper instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'short_url': instance.shortUrl,
      'views': instance.views,
      'favorites': instance.favorites,
      'category': instance.category,
      'dimension_x': instance.dimensionX,
      'dimension_y': instance.dimensionY,
      'resolution': instance.resolution,
      'file_size': instance.fileSize,
      'colors': instance.colors,
      'ratio': instance.ratio,
      'path': instance.path,
      'thumbs': instance.thumbs,
      'tags': instance.tags,
      'saved': instance.saved,
    };
