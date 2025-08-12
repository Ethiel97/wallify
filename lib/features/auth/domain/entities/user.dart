import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.id,
    this.username,
    this.email,
    this.provider,
    this.confirmed,
    this.createdAt,
    this.updatedAt,
    this.blocked,
  });

  final String? id;
  final String? username;
  final String? email;
  final String? provider;
  final bool? confirmed;
  final String? createdAt;
  final String? updatedAt;
  final bool? blocked;

  bool get isAuthenticated => id != null && email != null;

  bool get isConfirmed => confirmed ?? false;

  bool get isBlocked => blocked ?? false;

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? provider,
    bool? confirmed,
    String? createdAt,
    String? updatedAt,
    bool? blocked,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      provider: provider ?? this.provider,
      confirmed: confirmed ?? this.confirmed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      blocked: blocked ?? this.blocked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        provider,
        confirmed,
        createdAt,
        updatedAt,
        blocked,
      ];
}
