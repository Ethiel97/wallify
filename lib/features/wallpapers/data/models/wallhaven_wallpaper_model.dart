import 'package:json_annotation/json_annotation.dart';
import 'package:wallinice/features/wallpapers/wallpapers.dart';

part 'wallhaven_wallpaper_model.g.dart';

@JsonSerializable()
class WallhavenWallpaperModel {
  const WallhavenWallpaperModel({
    required this.id,
    required this.url,
    this.shortUrl,
    this.views,
    this.favorites,
    this.category,
    this.dimensionX,
    this.dimensionY,
    this.resolution,
    this.fileSize,
    this.colors,
    this.ratio,
    this.path,
    this.thumbs,
    this.tags,
  });

  factory WallhavenWallpaperModel.fromJson(Map<String, dynamic> json) =>
      _$WallhavenWallpaperModelFromJson(json);

  final String id;
  final String url;
  @JsonKey(name: 'short_url')
  final String? shortUrl;
  final int? views;
  final int? favorites;
  final String? category;
  @JsonKey(name: 'dimension_x')
  final int? dimensionX;
  @JsonKey(name: 'dimension_y')
  final int? dimensionY;
  final String? resolution;
  @JsonKey(name: 'file_size')
  final int? fileSize;
  final List<String>? colors;
  final String? ratio;
  final String? path;
  final WallhavenThumbsModel? thumbs;
  final List<WallhavenTagModel>? tags;

  Map<String, dynamic> toJson() => _$WallhavenWallpaperModelToJson(this);

  Wallpaper toEntity() {
    return Wallpaper(
      id: id,
      url: path ?? url,
      photographer: 'Unknown',
      // Wallhaven doesn't have photographer concept
      photographerUrl: '',
      src: WallpaperSrc(
        original: path ?? url,
        large2x: thumbs?.large ?? url,
        large: thumbs?.large ?? url,
        medium: thumbs?.small ?? url,
        small: thumbs?.small ?? url,
        portrait: thumbs?.small ?? url,
        landscape: thumbs?.large ?? url,
        tiny: thumbs?.small ?? url,
      ),
      alt: 'Wallpaper $id',
      dominantColors: (colors ?? []).map((color) => '#$color').toList(),
      avgColor: (colors?.isNotEmpty ?? false) ? '#${colors!.first}' : '#000000',
      width: dimensionX ?? 0,
      height: dimensionY ?? 0,
      views: views,
      favorites: favorites,
      category: category,
      resolution: resolution,
      fileSize: fileSize,
      tags: tags?.map((tag) => tag.name ?? '').toList(),
      source: 'wallhaven',
    );
  }
}

@JsonSerializable()
class WallhavenThumbsModel {
  const WallhavenThumbsModel({
    required this.large,
    required this.original,
    required this.small,
  });

  factory WallhavenThumbsModel.fromJson(Map<String, dynamic> json) =>
      _$WallhavenThumbsModelFromJson(json);

  final String large;
  final String original;
  final String small;

  Map<String, dynamic> toJson() => _$WallhavenThumbsModelToJson(this);
}

@JsonSerializable()
class WallhavenTagModel {
  const WallhavenTagModel({
    this.id,
    this.name,
    this.alias,
    this.categoryId,
    this.category,
  });

  factory WallhavenTagModel.fromJson(Map<String, dynamic> json) =>
      _$WallhavenTagModelFromJson(json);

  final String? id;
  final String? name;
  final String? alias;
  @JsonKey(name: 'category_id')
  final String? categoryId;
  final String? category;

  Map<String, dynamic> toJson() => _$WallhavenTagModelToJson(this);
}

@JsonSerializable()
class WallhavenResponse {
  const WallhavenResponse({
    required this.data,
    required this.meta,
  });

  factory WallhavenResponse.fromJson(Map<String, dynamic> json) =>
      _$WallhavenResponseFromJson(json);

  final List<WallhavenWallpaperModel> data;
  final WallhavenMetaModel meta;

  Map<String, dynamic> toJson() => _$WallhavenResponseToJson(this);
}

@JsonSerializable()
class WallhavenMetaModel {
  const WallhavenMetaModel({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory WallhavenMetaModel.fromJson(Map<String, dynamic> json) =>
      _$WallhavenMetaModelFromJson(json);

  @JsonKey(name: 'current_page')
  final int? currentPage;
  @JsonKey(name: 'last_page')
  final int? lastPage;
  @JsonKey(name: 'per_page')
  final String? perPage;
  final int? total;

  Map<String, dynamic> toJson() => _$WallhavenMetaModelToJson(this);
}
