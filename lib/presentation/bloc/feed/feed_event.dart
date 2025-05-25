// libcore/blocs/feed/feed_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_event.freezed.dart';

@freezed
class FeedEvent with _$FeedEvent {
  const FeedEvent._();

  // Cargar planes iniciales
  const factory FeedEvent.fetchPlans() = FetchPlans;

  // Recargar planes (pull to refresh)
  const factory FeedEvent.refreshPlans() = RefreshPlans;

  // Cargar más planes (paginación)
  const factory FeedEvent.loadMorePlans() = LoadMorePlans;

  // Filtrar planes por categoría
  const factory FeedEvent.filterPlansByCategory(final String category) =
      FilterPlansByCategory;

  // Limpiar filtros
  const factory FeedEvent.clearFilters() = ClearFilters;

  // Like a un plan
  const factory FeedEvent.likePlan(final String planId) = LikePlan;

  // Unlike a un plan
  const factory FeedEvent.unlikePlan(final String planId) = UnlikePlan;

  // Crear un nuevo plan
  const factory FeedEvent.createPlan({
    required final String title,
    required final String description,
    required final String imageUrl,
    required final String category,
    required final String location,
    final DateTime? date,
    required final Map<String, String> conditions,
    required final List<String> selectedThemes,
  }) = CreatePlan;

  // Eliminar un plan
  const factory FeedEvent.deletePlan(final String planId) = DeletePlan;
}
