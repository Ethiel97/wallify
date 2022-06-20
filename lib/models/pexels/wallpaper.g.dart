// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper.dart';

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
    };
