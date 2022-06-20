import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  final String? id;
  final String? name;
  final String? alias;
  final String? categoryId;
  final String? category;

  Tag({
    this.id,
    this.name,
    this.alias,
    this.categoryId,
    this.category,
  });

  factory Tag.fromJson(Map<String, dynamic> json) =>
      _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
