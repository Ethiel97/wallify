import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String? id;
  final String? username;

  final String? email;

  final bool? confirmed;

  final bool? blocked;

  final String? createdAt;
  final String? updatedAt;
  final String? provider;

  User({
    this.id,
    this.username,
    this.email,
    this.provider,
    this.confirmed,
    this.createdAt,
    this.updatedAt,
    this.blocked,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
