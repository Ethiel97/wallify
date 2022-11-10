import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/wallhaven/tag.dart';

import 'wallpaper_thumbs.dart';

part 'wallpaper_wh.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class WallPaper {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? url;

  @HiveField(2)
  @JsonKey(name: 'short_url')
  final String? shortUrl;

  @HiveField(3)
  final int? views;

  @HiveField(4)
  final int? favorites;

  @HiveField(5)
  final String? category;

  @HiveField(6)
  @JsonKey(name: 'dimension_x')
  final int? dimensionX;

  @HiveField(7)
  @JsonKey(name: 'dimension_y')
  final int? dimensionY;

  @HiveField(8)
  final String? resolution;

  @HiveField(9)
  @JsonKey(name: 'file_size')
  final int? fileSize;

  @HiveField(10)
  final List<String>? colors;

  @HiveField(11)
  final String? ratio;

  @HiveField(12)
  final String? path;

  @HiveField(13)
  final WallPaperThumbs? thumbs;

  @HiveField(14)
  final List<Tag>? tags;

  @HiveField(15)
  final bool? saved;

  WallPaper(
      {this.id,
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
      this.saved});

  factory WallPaper.fromJson(Map<String, dynamic> json) =>
      _$WallPaperFromJson(json);

  Map<String, dynamic> toJson() => _$WallPaperToJson(this);

  WallPaper copyWith({
    String? id,
    String? shortUrl,
    int? views,
    int? favorites,
    int? dimensionX,
    int? dimensionY,
    int? fileSize,
    String? category,
    String? resolution,
    String? ratio,
    String? path,
    List<Tag>? tags,
    WallPaperThumbs? thumbs,
    bool? saved,
  }) =>
      WallPaper(
        id: id ?? this.id,
        shortUrl: shortUrl ?? this.shortUrl,
        views: views ?? this.views,
        favorites: favorites ?? this.favorites,
        dimensionX: dimensionX ?? this.dimensionX,
        dimensionY: dimensionY ?? this.dimensionY,
        fileSize: fileSize ?? this.fileSize,
        category: category ?? this.category,
        resolution: resolution ?? this.resolution,
        ratio: ratio ?? this.ratio,
        path: path ?? this.path,
        tags: tags ?? this.tags,
        thumbs: thumbs ?? this.thumbs,
        saved: this.saved,
      );
}
