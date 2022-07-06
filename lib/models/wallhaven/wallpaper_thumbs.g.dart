// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_thumbs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WallPaperThumbsAdapter extends TypeAdapter<WallPaperThumbs> {
  @override
  final int typeId = 2;

  @override
  WallPaperThumbs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WallPaperThumbs(
      large: fields[0] as String,
      original: fields[1] as String,
      small: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WallPaperThumbs obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.large)
      ..writeByte(1)
      ..write(obj.original)
      ..writeByte(2)
      ..write(obj.small);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallPaperThumbsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallPaperThumbs _$WallPaperThumbsFromJson(Map<String, dynamic> json) =>
    WallPaperThumbs(
      large: json['large'] as String,
      original: json['original'] as String,
      small: json['small'] as String,
    );

Map<String, dynamic> _$WallPaperThumbsToJson(WallPaperThumbs instance) =>
    <String, dynamic>{
      'large': instance.large,
      'original': instance.original,
      'small': instance.small,
    };
