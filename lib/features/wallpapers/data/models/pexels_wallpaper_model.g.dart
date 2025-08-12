// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pexels_wallpaper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PexelsWallpaperModel _$PexelsWallpaperModelFromJson(
        Map<String, dynamic> json) =>
    PexelsWallpaperModel(
      id: (json['id'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      url: json['url'] as String,
      photographer: json['photographer'] as String,
      photographerUrl: json['photographer_url'] as String,
      photographerId: (json['photographer_id'] as num).toInt(),
      avgColor: json['avg_color'] as String,
      src: PexelsSrcModel.fromJson(json['src'] as Map<String, dynamic>),
      liked: json['liked'] as bool,
      alt: json['alt'] as String,
    );

Map<String, dynamic> _$PexelsWallpaperModelToJson(
        PexelsWallpaperModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'width': instance.width,
      'height': instance.height,
      'url': instance.url,
      'photographer': instance.photographer,
      'photographer_url': instance.photographerUrl,
      'photographer_id': instance.photographerId,
      'avg_color': instance.avgColor,
      'src': instance.src,
      'liked': instance.liked,
      'alt': instance.alt,
    };

PexelsSrcModel _$PexelsSrcModelFromJson(Map<String, dynamic> json) =>
    PexelsSrcModel(
      original: json['original'] as String,
      large2x: json['large2x'] as String,
      large: json['large'] as String,
      medium: json['medium'] as String,
      small: json['small'] as String,
      portrait: json['portrait'] as String,
      landscape: json['landscape'] as String,
      tiny: json['tiny'] as String,
    );

Map<String, dynamic> _$PexelsSrcModelToJson(PexelsSrcModel instance) =>
    <String, dynamic>{
      'original': instance.original,
      'large2x': instance.large2x,
      'large': instance.large,
      'medium': instance.medium,
      'small': instance.small,
      'portrait': instance.portrait,
      'landscape': instance.landscape,
      'tiny': instance.tiny,
    };

PexelsResponse _$PexelsResponseFromJson(Map<String, dynamic> json) =>
    PexelsResponse(
      photos: (json['photos'] as List<dynamic>)
          .map((e) => PexelsWallpaperModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResults: (json['total_results'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      nextPage: json['next_page'] as String?,
    );

Map<String, dynamic> _$PexelsResponseToJson(PexelsResponse instance) =>
    <String, dynamic>{
      'photos': instance.photos,
      'total_results': instance.totalResults,
      'page': instance.page,
      'per_page': instance.perPage,
      'next_page': instance.nextPage,
    };
