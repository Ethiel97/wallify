import 'package:json_annotation/json_annotation.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

part 'pexels_wallpaper_model.g.dart';

@JsonSerializable()
class PexelsWallpaperModel {
  const PexelsWallpaperModel({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.src,
    required this.liked,
    required this.alt,
  });

  factory PexelsWallpaperModel.fromJson(Map<String, dynamic> json) =>
      _$PexelsWallpaperModelFromJson(json);

  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  @JsonKey(name: 'photographer_url')
  final String photographerUrl;
  @JsonKey(name: 'photographer_id')
  final int photographerId;
  @JsonKey(name: 'avg_color')
  final String avgColor;
  final PexelsSrcModel src;
  final bool liked;
  final String alt;

  Map<String, dynamic> toJson() => _$PexelsWallpaperModelToJson(this);

  Wallpaper toEntity() {
    return Wallpaper(
      id: id.toString(),
      url: src.large,
      photographer: photographer,
      photographerUrl: photographerUrl,
      src: src.toEntity(),
      alt: alt,
      avgColor: avgColor,
      width: width,
      height: height,
      liked: liked,
    );
  }
}

@JsonSerializable()
class PexelsSrcModel {
  const PexelsSrcModel({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory PexelsSrcModel.fromJson(Map<String, dynamic> json) =>
      _$PexelsSrcModelFromJson(json);

  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  Map<String, dynamic> toJson() => _$PexelsSrcModelToJson(this);

  WallpaperSrc toEntity() {
    return WallpaperSrc(
      original: original,
      large2x: large2x,
      large: large,
      medium: medium,
      small: small,
      portrait: portrait,
      landscape: landscape,
      tiny: tiny,
    );
  }
}

@JsonSerializable()
class PexelsResponse {
  const PexelsResponse({
    required this.photos,
    required this.totalResults,
    required this.page,
    required this.perPage,
    required this.nextPage,
  });

  factory PexelsResponse.fromJson(Map<String, dynamic> json) =>
      _$PexelsResponseFromJson(json);

  final List<PexelsWallpaperModel> photos;
  @JsonKey(name: 'total_results')
  final int totalResults;
  final int page;
  @JsonKey(name: 'per_page')
  final int perPage;
  @JsonKey(name: 'next_page')
  final String? nextPage;

  Map<String, dynamic> toJson() => _$PexelsResponseToJson(this);
}
