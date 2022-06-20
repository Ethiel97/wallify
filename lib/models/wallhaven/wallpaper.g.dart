// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallPaper _$WallPaperFromJson(Map<String, dynamic> json) => WallPaper(
      id: json['id'] as String?,
      url: json['url'] as String?,
      shortUrl: json['short_url'] as String?,
      views: json['views'] as String?,
      favourites: json['favourites'] as String?,
      category: json['category'] as String?,
      dimensionX: json['dimension_x'] as String?,
      dimensionY: json['dimension_y'] as String?,
      resolution: json['resolution'] as String?,
      fileSize: json['file_size'] as String?,
      colors: json['colors'] as List<dynamic>?,
      path: json['path'] as String?,
      thumbs: json['thumbs'] as Map<String, dynamic>?,
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
      'favourites': instance.favourites,
      'category': instance.category,
      'dimension_x': instance.dimensionX,
      'dimension_y': instance.dimensionY,
      'resolution': instance.resolution,
      'file_size': instance.fileSize,
      'colors': instance.colors,
      'path': instance.path,
      'thumbs': instance.thumbs,
      'tags': instance.tags,
      'current_page': instance.currentPage,
    };
