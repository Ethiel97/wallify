// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WallPaperAdapter extends TypeAdapter<WallPaper> {
  @override
  final int typeId = 3;

  @override
  WallPaper read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WallPaper(
      id: fields[0] as int,
      width: fields[1] as int,
      height: fields[2] as int,
      url: fields[3] as String,
      src: fields[8] as WallPaperSrc,
      photographer: fields[4] as String,
      photographerUrl: fields[5] as String,
      photographerId: fields[6] as int,
      avgColor: fields[7] as String,
      saved: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WallPaper obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.photographer)
      ..writeByte(5)
      ..write(obj.photographerUrl)
      ..writeByte(6)
      ..write(obj.photographerId)
      ..writeByte(7)
      ..write(obj.avgColor)
      ..writeByte(8)
      ..write(obj.src)
      ..writeByte(9)
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
      id: json['id'] as int,
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String,
      src: WallPaperSrc.fromJson(json['src'] as Map<String, dynamic>),
      photographer: json['photographer'] as String,
      photographerUrl: json['photographer_url'] as String,
      photographerId: json['photographer_id'] as int,
      avgColor: json['avg_color'] as String,
      saved: json['saved'] as bool,
    );

Map<String, dynamic> _$WallPaperToJson(WallPaper instance) => <String, dynamic>{
      'id': instance.id,
      'width': instance.width,
      'height': instance.height,
      'url': instance.url,
      'photographer': instance.photographer,
      'photographer_url': instance.photographerUrl,
      'photographer_id': instance.photographerId,
      'avg_color': instance.avgColor,
      'src': instance.src,
      'saved': instance.saved,
    };
