// lib/presentation/bloc/search/search_event.dart
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

// Evento para inicializar la pantalla de búsqueda y cargar búsquedas recientes
class InitializeSearch extends SearchEvent {
  const InitializeSearch();

  @override
  List<Object?> get props => [];
}

// Evento cuando el usuario escribe en el campo de búsqueda (con debounce)
class QueryChanged extends SearchEvent {
  final String query;

  const QueryChanged({required this.query});

  @override
  List<Object?> get props => [query];
}

// Evento cuando el usuario envía la búsqueda
class SubmitSearch extends SearchEvent {
  final String query;

  const SubmitSearch({required this.query});

  @override
  List<Object?> get props => [query];
}

// Evento para cargar más resultados de búsqueda (paginación)
class LoadMoreResults extends SearchEvent {
  const LoadMoreResults();

  @override
  List<Object?> get props => [];
}

// Evento para limpiar consulta de búsqueda
class ClearSearch extends SearchEvent {
  const ClearSearch();

  @override
  List<Object?> get props => [];
}

// Evento para limpiar todas las búsquedas recientes
class ClearRecentSearches extends SearchEvent {
  const ClearRecentSearches();

  @override
  List<Object?> get props => [];
}

// Evento cuando el usuario selecciona una búsqueda reciente
class SelectRecentSearch extends SearchEvent {
  final String query;

  const SelectRecentSearch({required this.query});

  @override
  List<Object?> get props => [query];
}

// ---- NUEVOS EVENTOS DE FILTROS ----

// Evento para aplicar filtro de ubicación
class ApplyLocationFilter extends SearchEvent {
  final double latitude;
  final double longitude;
  final double radiusKm;

  const ApplyLocationFilter({
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
  });

  @override
  List<Object?> get props => [latitude, longitude, radiusKm];
}

// Evento para aplicar filtro de fecha
class ApplyDateFilter extends SearchEvent {
  final DateTime startDate;
  final DateTime endDate;

  const ApplyDateFilter({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

// Evento para aplicar filtro de categoría
class ApplyCategoryFilter extends SearchEvent {
  final String category;

  const ApplyCategoryFilter({required this.category});

  @override
  List<Object?> get props => [category];
}

// Evento para limpiar todos los filtros
class ClearFilters extends SearchEvent {
  const ClearFilters();

  @override
  List<Object?> get props => [];
}

// Evento para aplicar múltiples filtros a la vez
class ApplyMultipleFilters extends SearchEvent {
  final String? query;
  final String? category;
  final double? latitude;
  final double? longitude;
  final double? radiusKm;
  final DateTime? startDate;
  final DateTime? endDate;

  const ApplyMultipleFilters({
    this.query,
    this.category,
    this.latitude,
    this.longitude,
    this.radiusKm,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
    query,
    category,
    latitude,
    longitude,
    radiusKm,
    startDate,
    endDate,
  ];
}

// Evento para filtros rápidos (hoy, esta semana, etc.)
class ApplyQuickDateFilter extends SearchEvent {
  final QuickDateFilter filter;

  const ApplyQuickDateFilter({required this.filter});

  @override
  List<Object?> get props => [filter];
}

// Enum para filtros rápidos de fecha
enum QuickDateFilter { today, thisWeek, thisMonth, weekend }
