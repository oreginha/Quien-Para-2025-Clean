// lib/domain/models/search_filters_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filters_model.freezed.dart';
part 'search_filters_model.g.dart';

@freezed
class SearchFiltersModel with _$SearchFiltersModel {
  factory SearchFiltersModel({
    required final double distanceValue,
    required final double minDistance,
    required final double maxDistance,
    required final Map<String, bool> conditions,
    required final Map<String, bool> additionalServices,
  }) = _SearchFiltersModel;

  factory SearchFiltersModel.fromJson(final Map<String, dynamic> json) =>
      _$SearchFiltersModelFromJson(json);
}
