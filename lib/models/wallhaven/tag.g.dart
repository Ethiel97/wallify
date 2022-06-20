// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      id: json['id'] as String?,
      name: json['name'] as String?,
      alias: json['alias'] as String?,
      categoryId: json['categoryId'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'alias': instance.alias,
      'categoryId': instance.categoryId,
      'category': instance.category,
    };
