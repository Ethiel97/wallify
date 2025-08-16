import 'package:json_annotation/json_annotation.dart';
import 'package:wallinice/features/favorites/favorites.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel extends Favorite {
  const FavoriteModel({
    required super.id,
    required super.uid,
    required super.userId,
    super.createdAt,
    super.updatedAt,
  });

  // Handle nested data structure from API response
  factory FavoriteModel.fromApiResponse(Map<String, dynamic> json) {
    final data = json['attributes'] as Map<String, dynamic>? ?? json;

    return FavoriteModel(
      id: json['id']?.toString() ?? '',
      uid: data['uid']?.toString() ?? '',
      userId: data['userId']?.toString() ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : null,
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'] as String)
          : null,
    );
  }

  factory FavoriteModel.fromEntity(Favorite favorite) {
    return FavoriteModel(
      id: favorite.id,
      uid: favorite.uid,
      userId: favorite.userId,
      createdAt: favorite.createdAt,
      updatedAt: favorite.updatedAt,
    );
  }

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);

  Favorite toEntity() {
    return Favorite(
      id: id,
      uid: uid,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
