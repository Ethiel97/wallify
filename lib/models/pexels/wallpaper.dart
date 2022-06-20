import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/pexels/wallpaper_src.dart';

part 'wallpaper.g.dart';

@JsonSerializable()
class WallPaper {
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

  final WallPaperSrc src;

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
  });

  WallPaper copyWith({
    int? id,
    int? width,
    int? height,
    String? url,
    String? photographer,
    String? photographerUrl,
    WallPaperSrc? wallpaperSrc,
    int? photographerId,
    String? avgColor,
  }) =>
      WallPaper(
        id: id ?? this.id,
        width: width ?? this.width,
        height: height ?? this.height,
        src: wallpaperSrc ?? this.src,
        url: url ?? this.url,
        photographer: photographer ?? this.photographer,
        photographerUrl: photographerUrl ?? this.photographerUrl,
        photographerId: photographerId ?? this.photographerId,
        avgColor: avgColor ?? this.avgColor,
      );

  factory WallPaper.fromJson(Map<String, dynamic> json) =>
      _$WallPaperFromJson(json);

  Map<String, dynamic> toJson() => _$WallPaperToJson(this);
}
