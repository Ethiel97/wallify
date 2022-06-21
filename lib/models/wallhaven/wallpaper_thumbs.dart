import 'package:json_annotation/json_annotation.dart';

part 'wallpaper_thumbs.g.dart';

@JsonSerializable()
class WallPaperThumbs {
  final String large;

  final String original;

  final String small;

  WallPaperThumbs({
    required this.large,
    required this.original,
    required this.small,
  });

  factory WallPaperThumbs.fromJson(Map<String, dynamic> json) =>
      _$WallPaperThumbsFromJson(json);

  Map<String, dynamic> toJson() => _$WallPaperThumbsToJson(this);
}
