// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filters_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchFiltersModelImpl _$$SearchFiltersModelImplFromJson(
  Map<String, dynamic> json,
) =>
    _$SearchFiltersModelImpl(
      distanceValue: (json['distanceValue'] as num).toDouble(),
      minDistance: (json['minDistance'] as num).toDouble(),
      maxDistance: (json['maxDistance'] as num).toDouble(),
      conditions: Map<String, bool>.from(json['conditions'] as Map),
      additionalServices:
          Map<String, bool>.from(json['additionalServices'] as Map),
    );

Map<String, dynamic> _$$SearchFiltersModelImplToJson(
  _$SearchFiltersModelImpl instance,
) =>
    <String, dynamic>{
      'distanceValue': instance.distanceValue,
      'minDistance': instance.minDistance,
      'maxDistance': instance.maxDistance,
      'conditions': instance.conditions,
      'additionalServices': instance.additionalServices,
    };
