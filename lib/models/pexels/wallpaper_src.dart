import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallpaper_src.g.dart';

@HiveType(typeId: 4)
@JsonSerializable()
class WallPaperSrc {
  @HiveField(0)
  final String original;

  @HiveField(1)
  final String tiny;

  @HiveField(2)
  final String large;

  @HiveField(3)
  final String large2x;

  @HiveField(4)
  final String medium;

  @HiveField(5)
  final String small;

  @HiveField(6)
  final String portrait;

  @HiveField(7)
  final String landscape;

  WallPaperSrc(
    this.original,
    this.tiny,
    this.landscape,
    this.portrait,
    this.large,
    this.large2x,
    this.medium,
    this.small,
  );

  factory WallPaperSrc.fromJson(Map<String, dynamic> json) =>
      _$WallPaperSrcFromJson(json);

  Map<String, dynamic> toJson() => _$WallPaperSrcToJson(this);
}
