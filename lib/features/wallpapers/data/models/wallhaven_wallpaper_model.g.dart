// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallhaven_wallpaper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallhavenWallpaperModel _$WallhavenWallpaperModelFromJson(
        Map<String, dynamic> json) =>
    WallhavenWallpaperModel(
      id: json['id'] as String,
      url: json['url'] as String,
      shortUrl: json['short_url'] as String?,
      views: (json['views'] as num?)?.toInt(),
      favorites: (json['favorites'] as num?)?.toInt(),
      category: json['category'] as String?,
      dimensionX: (json['dimension_x'] as num?)?.toInt(),
      dimensionY: (json['dimension_y'] as num?)?.toInt(),
      resolution: json['resolution'] as String?,
      fileSize: (json['file_size'] as num?)?.toInt(),
      colors:
          (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      ratio: json['ratio'] as String?,
      path: json['path'] as String?,
      thumbs: json['thumbs'] == null
          ? null
          : WallhavenThumbsModel.fromJson(
              json['thumbs'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => WallhavenTagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WallhavenWallpaperModelToJson(
        WallhavenWallpaperModel instance) =>
    <String, dynamic>{
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
    };

WallhavenThumbsModel _$WallhavenThumbsModelFromJson(
        Map<String, dynamic> json) =>
    WallhavenThumbsModel(
      large: json['large'] as String,
      original: json['original'] as String,
      small: json['small'] as String,
    );

Map<String, dynamic> _$WallhavenThumbsModelToJson(
        WallhavenThumbsModel instance) =>
    <String, dynamic>{
      'large': instance.large,
      'original': instance.original,
      'small': instance.small,
    };

WallhavenTagModel _$WallhavenTagModelFromJson(Map<String, dynamic> json) =>
    WallhavenTagModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      alias: json['alias'] as String?,
      categoryId: json['category_id'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$WallhavenTagModelToJson(WallhavenTagModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'alias': instance.alias,
      'category_id': instance.categoryId,
      'category': instance.category,
    };

WallhavenResponse _$WallhavenResponseFromJson(Map<String, dynamic> json) =>
    WallhavenResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) =>
              WallhavenWallpaperModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: WallhavenMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WallhavenResponseToJson(WallhavenResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

WallhavenMetaModel _$WallhavenMetaModelFromJson(Map<String, dynamic> json) =>
    WallhavenMetaModel(
      currentPage: (json['current_page'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WallhavenMetaModelToJson(WallhavenMetaModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };
