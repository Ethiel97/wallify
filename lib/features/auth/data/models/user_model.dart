import 'package:json_annotation/json_annotation.dart';
import 'package:wallinice/features/auth/auth.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    super.id,
    super.username,
    super.email,
    super.provider,
    super.confirmed,
    super.createdAt,
    super.updatedAt,
    super.blocked,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      provider: user.provider,
      confirmed: user.confirmed,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      blocked: user.blocked,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() {
    return User(
      id: id,
      username: username,
      email: email,
      provider: provider,
      confirmed: confirmed,
      createdAt: createdAt,
      updatedAt: updatedAt,
      blocked: blocked,
    );
  }
}
