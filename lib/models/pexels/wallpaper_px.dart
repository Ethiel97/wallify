import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'wallpaper_src.dart';

part 'wallpaper_px.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class WallPaper {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int width;

  @HiveField(2)
  final int height;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final String photographer;

  @HiveField(5)
  @JsonKey(name: 'photographer_url')
  final String photographerUrl;

  @HiveField(6)
  @JsonKey(name: 'photographer_id')
  final int photographerId;

  @HiveField(7)
  @JsonKey(name: 'avg_color')
  final String avgColor;

  @HiveField(8)
  final WallPaperSrc src;

  @HiveField(9)
  final bool? saved;

  WallPaper({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.src,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.saved,
  });

  WallPaper copyWith(
          {int? id,
          int? width,
          int? height,
          String? url,
          String? photographer,
          String? photographerUrl,
          WallPaperSrc? wallpaperSrc,
          int? photographerId,
          String? avgColor,
          bool? saved}) =>
      WallPaper(
        id: id ?? this.id,
        width: width ?? this.width,
        height: height ?? this.height,
        src: wallpaperSrc ?? src,
        url: url ?? this.url,
        photographer: photographer ?? this.photographer,
        photographerUrl: photographerUrl ?? this.photographerUrl,
        photographerId: photographerId ?? this.photographerId,
        avgColor: avgColor ?? this.avgColor,
        saved: saved ?? this.saved,
      );

  factory WallPaper.fromJson(Map<String, dynamic> json) =>
      _$WallPaperFromJson(json);

  Map<String, dynamic> toJson() => _$WallPaperToJson(this);
}
