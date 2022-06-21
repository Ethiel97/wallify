// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper.dart';

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
      currentPage: json['current_page'] as int?,
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
      'current_page': instance.currentPage,
    };
