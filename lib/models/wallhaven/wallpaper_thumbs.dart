import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallpaper_thumbs.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class WallPaperThumbs {
  @HiveField(0)
  final String large;

  @HiveField(1)
  final String original;

  @HiveField(2)
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
