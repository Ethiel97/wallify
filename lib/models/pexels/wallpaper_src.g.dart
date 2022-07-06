// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_src.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WallPaperSrcAdapter extends TypeAdapter<WallPaperSrc> {
  @override
  final int typeId = 4;

  @override
  WallPaperSrc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WallPaperSrc(
      fields[0] as String,
      fields[1] as String,
      fields[7] as String,
      fields[6] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WallPaperSrc obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.original)
      ..writeByte(1)
      ..write(obj.tiny)
      ..writeByte(2)
      ..write(obj.large)
      ..writeByte(3)
      ..write(obj.large2x)
      ..writeByte(4)
      ..write(obj.medium)
      ..writeByte(5)
      ..write(obj.small)
      ..writeByte(6)
      ..write(obj.portrait)
      ..writeByte(7)
      ..write(obj.landscape);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallPaperSrcAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallPaperSrc _$WallPaperSrcFromJson(Map<String, dynamic> json) => WallPaperSrc(
      json['original'] as String,
      json['tiny'] as String,
      json['landscape'] as String,
      json['portrait'] as String,
      json['large'] as String,
      json['large2x'] as String,
      json['medium'] as String,
      json['small'] as String,
    );

Map<String, dynamic> _$WallPaperSrcToJson(WallPaperSrc instance) =>
    <String, dynamic>{
      'original': instance.original,
      'tiny': instance.tiny,
      'large': instance.large,
      'large2x': instance.large2x,
      'medium': instance.medium,
      'small': instance.small,
      'portrait': instance.portrait,
      'landscape': instance.landscape,
    };
