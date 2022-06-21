import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/wallhaven/tag.dart';

import 'wallpaper_thumbs.dart';

part 'wallpaper.g.dart';

@JsonSerializable()
class WallPaper {
  final String? id;

  final String? url;

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

  final WallPaperThumbs? thumbs;

  final List<Tag>? tags;

  @JsonKey(name: 'current_page')
  final int? currentPage;

  WallPaper({
    this.id,
    this.url,
    this.shortUrl,
    this.views,
    this.ratio,
    this.favorites,
    this.category,
    this.dimensionX,
    this.dimensionY,
    this.resolution,
    this.fileSize,
    this.colors,
    this.path,
    this.thumbs,
    this.tags,
    this.currentPage,
  });

  factory WallPaper.fromJson(Map<String, dynamic> json) =>
      _$WallPaperFromJson(json);

  Map<String, dynamic> toJson() => _$WallPaperToJson(this);
}
