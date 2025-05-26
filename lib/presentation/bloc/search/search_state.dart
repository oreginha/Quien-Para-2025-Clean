// lib/presentation/bloc/search/search_state.dart
import 'package:equatable/equatable.dart';
import 'package:quien_para/domain/entities/plan/plan_with_creator_entity.dart';

enum SearchStatus { initial, loading, success, failure }

// Clase para manejar filtros de búsqueda de manera estructurada
class SearchFilters extends Equatable {
  final bool hasLocationFilter;
  final double? latitude;
  final double? longitude;
  final double? radiusKm;

  final bool hasDateFilter;
  final DateTime? startDate;
  final DateTime? endDate;

  final bool hasCategoryFilter;
  final String? category;

  const SearchFilters({
    this.hasLocationFilter = false,
    this.latitude,
    this.longitude,
    this.radiusKm,
    this.hasDateFilter = false,
    this.startDate,
    this.endDate,
    this.hasCategoryFilter = false,
    this.category,
  });

  SearchFilters copyWith({
    bool? hasLocationFilter,
    double? latitude,
    double? longitude,
    double? radiusKm,
    bool? hasDateFilter,
    DateTime? startDate,
    DateTime? endDate,
    bool? hasCategoryFilter,
    String? category,
  }) {
    return SearchFilters(
      hasLocationFilter: hasLocationFilter ?? this.hasLocationFilter,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusKm: radiusKm ?? this.radiusKm,
      hasDateFilter: hasDateFilter ?? this.hasDateFilter,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      hasCategoryFilter: hasCategoryFilter ?? this.hasCategoryFilter,
      category: category ?? this.category,
    );
  }

  bool get hasAnyFilter =>
      hasLocationFilter || hasDateFilter || hasCategoryFilter;

  int get activeFilterCount {
    int count = 0;
    if (hasLocationFilter) count++;
    if (hasDateFilter) count++;
    if (hasCategoryFilter) count++;
    return count;
  }

  Map<String, dynamic> toMap() {
    return {
      'hasLocationFilter': hasLocationFilter,
      'latitude': latitude,
      'longitude': longitude,
      'radiusKm': radiusKm,
      'hasDateFilter': hasDateFilter,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'hasCategoryFilter': hasCategoryFilter,
      'category': category,
    };
  }

  @override
  List<Object?> get props => [
    hasLocationFilter,
    latitude,
    longitude,
    radiusKm,
    hasDateFilter,
    startDate,
    endDate,
    hasCategoryFilter,
    category,
  ];
}

class SearchState extends Equatable {
  final SearchStatus status;
  final List<PlanWithCreatorEntity> results;
  final List<String> recentSearches;
  final String query;
  final String? error;
  final bool hasReachedMax;
  final SearchFilters activeFilters;

  const SearchState({
    this.status = SearchStatus.initial,
    this.results = const [],
    this.recentSearches = const [],
    this.query = '',
    this.error,
    this.hasReachedMax = false,
    this.activeFilters = const SearchFilters(),
  });

  SearchState copyWith({
    SearchStatus? status,
    List<PlanWithCreatorEntity>? results,
    List<String>? recentSearches,
    String? query,
    String? error,
    bool? hasReachedMax,
    SearchFilters? activeFilters,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      recentSearches: recentSearches ?? this.recentSearches,
      query: query ?? this.query,
      error: error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }

  // Getters útiles para la UI
  bool get isLoading => status == SearchStatus.loading;
  bool get hasError => status == SearchStatus.failure && error != null;
  bool get hasResults => results.isNotEmpty;
  bool get hasActiveFilters => activeFilters.hasAnyFilter;
  bool get showRecentSearches =>
      status == SearchStatus.initial &&
      query.isEmpty &&
      recentSearches.isNotEmpty;

  @override
  List<Object?> get props => [
    status,
    results,
    recentSearches,
    query,
    error,
    hasReachedMax,
    activeFilters,
  ];
}
