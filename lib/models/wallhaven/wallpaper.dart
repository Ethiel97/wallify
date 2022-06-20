import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/wallhaven/tag.dart';

part 'wallpaper.g.dart';

@JsonSerializable()
class WallPaper {
  final String? id;

  final String? url;

  @JsonKey(name: 'short_url')
  final String? shortUrl;

  final String? views;

  final String? favourites;

  final String? category;

  @JsonKey(name: 'dimension_x')
  final String? dimensionX;

  @JsonKey(name: 'dimension_y')
  final String? dimensionY;

  final String? resolution;

  @JsonKey(name: 'file_size')
  final String? fileSize;

  final List? colors;

  final String? path;

  final Map? thumbs;

  final List<Tag>? tags;

  @JsonKey(name: 'current_page')
  final int? currentPage;

  WallPaper({
    this.id,
    this.url,
    this.shortUrl,
    this.views,
    this.favourites,
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
