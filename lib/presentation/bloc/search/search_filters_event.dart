// libcore/blocs/search_filters/search_filters_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filters_event.freezed.dart';

@freezed
abstract class SearchFiltersEvent with _$SearchFiltersEvent {
  // Eventos para manejar la búsqueda
  const factory SearchFiltersEvent.updateSearchQuery(final String query) =
      _UpdateSearchQuery;
  const factory SearchFiltersEvent.updateCategoryFilter(final String category) =
      _UpdateCategoryFilter;
  const factory SearchFiltersEvent.updateTagFilter(
      final String tag, final bool selected) = _UpdateTagFilter;
  const factory SearchFiltersEvent.clearFilters() = _ClearFilters;

  // Eventos para manejar cambios en la distancia
  const factory SearchFiltersEvent.distanceChanged(final double value) =
      _DistanceChanged;

  // Eventos para manejar cambios en las condiciones
  const factory SearchFiltersEvent.conditionToggled(
      final String condition, final bool value) = _ConditionToggled;

  // Eventos para manejar cambios en los servicios adicionales
  const factory SearchFiltersEvent.additionalServiceToggled(
      final String service, final bool value) = _AdditionalServiceToggled;

  // Eventos para acciones de botones
  const factory SearchFiltersEvent.resetFilters() = _ResetFilters;
  const factory SearchFiltersEvent.applyFilters() = _ApplyFilters;
  const factory SearchFiltersEvent.saveFilters() = _SaveFilters;

  // Eventos para cargar filtros guardados previamente
  const factory SearchFiltersEvent.loadSavedFilters() = _LoadSavedFilters;
}
