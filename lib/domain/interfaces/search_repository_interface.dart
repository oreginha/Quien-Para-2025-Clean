// lib/domain/repositories/search_repository_interface.dart
import '../entities/plan/plan_with_creator_entity.dart';

abstract class SearchRepository {
  /// Searches for plans by keywords in title, description, and category
  ///
  /// [query] - The search query
  /// [limit] - Maximum number of results to return
  /// [lastDocumentId] - ID of the last document for pagination
  /// [filters] - Optional map of filters to apply (category, dateRange, etc.)
  Stream<List<PlanWithCreatorEntity>> searchPlans({
    required String query,
    int limit = 10,
    String? lastDocumentId,
    Map<String, dynamic>? filters,
  });

  /// Gets recent search queries for a user
  ///
  /// [userId] - The user ID
  /// [limit] - Maximum number of recent searches to return
  Future<List<String>> getRecentSearches({
    required String userId,
    int limit = 5,
  });

  /// Saves a search query to the user's recent searches
  ///
  /// [userId] - The user ID
  /// [query] - The search query to save
  Future<void> saveSearchQuery({required String userId, required String query});

  /// Clears the user's recent searches
  ///
  /// [userId] - The user ID
  Future<void> clearRecentSearches({required String userId});
}
