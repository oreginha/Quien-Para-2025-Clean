// libcore/blocs/search_filters/search_filters_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filters_state.freezed.dart';

@freezed
abstract class SearchFiltersState with _$SearchFiltersState {
  const factory SearchFiltersState({
    @Default('') final String searchQuery,
    @Default('') final String selectedCategory,
    @Default(<String>[]) final List<String> selectedTags,
    @Default(0.0) final double distanceValue,
    @Default(0.0) final double minDistance,
    @Default(100.0) final double maxDistance,
    @Default(<String, bool>{}) final Map<String, bool> conditions,
    @Default(<String, bool>{}) final Map<String, bool> additionalServices,
    @Default(false) final bool isLoading,
    final String? errorMessage,
  }) = _SearchFiltersState;

  factory SearchFiltersState.initial() => const SearchFiltersState(
    searchQuery: '',
    selectedCategory: '',
    selectedTags: <String>[],
    distanceValue: 18.0,
    minDistance: 0.0,
    maxDistance: 100.0,
    conditions: <String, bool>{
      'Free transfer': false,
      'No check': false,
      'Last minute': false,
      'Pick me up': false,
      'Non-stop': false,
      'SOSI/SJ': false,
      'Lunch': false,
      'Delivery': false,
      '24/7 reception': false,
    },
    additionalServices: <String, bool>{
      'Free service check-in': false,
      'Flexible refund policy': false,
      'Cancellation protection': false,
    },
    isLoading: false,
  );
}
