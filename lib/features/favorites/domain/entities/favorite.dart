import 'package:equatable/equatable.dart';

class Favorite extends Equatable {
  const Favorite({
    required this.id,
    required this.uid,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String uid; // wallpaper uid/id
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        uid,
        userId,
        createdAt,
        updatedAt,
      ];
}