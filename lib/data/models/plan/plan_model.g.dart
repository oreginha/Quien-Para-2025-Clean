// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlanModelImpl _$$PlanModelImplFromJson(Map<String, dynamic> json) =>
    _$PlanModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      creatorId: json['creatorId'] as String,
      date: DateTime.parse(json['date'] as String),
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      category: json['category'] as String? ?? '',
      location: json['location'] as String? ?? '',
      conditions:
          (json['conditions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      selectedThemes:
          (json['selectedThemes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] as String?,
      esVisible: json['esVisible'] as bool? ?? true,
    );

Map<String, dynamic> _$$PlanModelImplToJson(_$PlanModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'creatorId': instance.creatorId,
      'date': instance.date.toIso8601String(),
      'likes': instance.likes,
      'category': instance.category,
      'location': instance.location,
      'conditions': instance.conditions,
      'selectedThemes': instance.selectedThemes,
      'createdAt': instance.createdAt,
      'esVisible': instance.esVisible,
    };
