// lib/data/repositories/search_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/entities/plan/plan_with_creator_entity.dart';
import 'package:quien_para/domain/interfaces/search_repository_interface.dart';

class SearchRepositoryImpl implements SearchRepository {
  final FirebaseFirestore _firestore;

  SearchRepositoryImpl(this._firestore);

  @override
  Stream<List<PlanWithCreatorEntity>> searchPlans({
    required String query,
    int limit = 10,
    String? lastDocumentId,
    Map<String, dynamic>? filters,
  }) async* {
    // Normalize query for case-insensitive search
    final String normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      yield [];
      return;
    }

    // Start with base query on plans collection
    Query plansQuery = _firestore.collection('plans');

    // Apply keyword search (title, description, category)
    plansQuery =
        plansQuery.where('searchKeywords', arrayContains: normalizedQuery);

    // Apply filters if provided
    if (filters != null) {
      // Category filter
      if (filters['category'] != null) {
        plansQuery =
            plansQuery.where('category', isEqualTo: filters['category']);
      }

      // Date range filter
      if (filters['startDate'] != null && filters['endDate'] != null) {
        plansQuery = plansQuery
            .where('date', isGreaterThanOrEqualTo: filters['startDate'])
            .where('date', isLessThanOrEqualTo: filters['endDate']);
      }

      // Other filters as needed
    }

    // Apply pagination
    if (lastDocumentId != null && lastDocumentId.isNotEmpty) {
      final lastDoc =
          await _firestore.collection('plans').doc(lastDocumentId).get();
      if (lastDoc.exists) {
        plansQuery = plansQuery.startAfterDocument(lastDoc);
      }
    }

    // Apply limit and order by creation date (newest first)
    plansQuery = plansQuery.orderBy('createdAt', descending: true).limit(limit);

    // Listen to the query snapshots
    await for (final snapshot in plansQuery.snapshots()) {
      yield await _processQuerySnapshot(snapshot);
    }
  }

  // Helper method to process query snapshots
  Future<List<PlanWithCreatorEntity>> _processQuerySnapshot(
      QuerySnapshot snapshot) async {
    final List<PlanWithCreatorEntity> results = [];

    for (final doc in snapshot.docs) {
      final Map<String, dynamic>? planData =
          doc.data() as Map<String, dynamic>?;
      if (planData == null) continue;

      final String? creatorId = planData['creatorId'] as String?;

      if (creatorId == null) continue;

      // Get creator user info
      final creatorDoc =
          await _firestore.collection('users').doc(creatorId).get();

      if (creatorDoc.exists && creatorDoc.data() != null) {
        final creator = creatorDoc.data()!;

        // Create PlanEntity first
        final planEntity = PlanEntity(
          id: doc.id,
          title: planData['title'] as String? ?? 'Sin título',
          description: planData['description'] as String? ?? 'Sin descripción',
          category: planData['category'] as String? ?? 'Sin categoría',
          creatorId: creatorId,
          // Add other required fields with null safety
          createdAt: planData['createdAt'] != null
              ? (planData['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
          location: '',
          tags: [],
          likes: 0,
          extraConditions: '', imageUrl: '', conditions: {}, selectedThemes: [],
        );

        // Now create PlanWithCreatorEntity with the plan and creator data
        results.add(PlanWithCreatorEntity(
          plan: planEntity,
          creatorData: {
            'name': creator['displayName'] != null
                ? creator['displayName'] as String
                : 'Usuario',
            'photoUrl': creator['photoURL'] as String?,
            'username': creator['username'] as String?,
          },
        ));
      }
    }

    return results;
  }

  @override
  Future<List<String>> getRecentSearches({
    required String userId,
    int limit = 5,
  }) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('recent_searches')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          return data['query'] as String? ?? '';
        })
        .where((query) => query.isNotEmpty)
        .toList();
  }

  @override
  Future<void> saveSearchQuery({
    required String userId,
    required String query,
  }) async {
    // Normalize query
    final String normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return;
    }

    // Reference to user's recent searches
    final recentSearchRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('recent_searches');

    // Check if this query already exists
    final existingQuerySnapshot = await recentSearchRef
        .where('query', isEqualTo: normalizedQuery)
        .limit(1)
        .get();

    // If exists, just update timestamp
    if (existingQuerySnapshot.docs.isNotEmpty) {
      await recentSearchRef
          .doc(existingQuerySnapshot.docs.first.id)
          .update({'timestamp': FieldValue.serverTimestamp()});
    } else {
      // Add new search query
      await recentSearchRef.add({
        'query': normalizedQuery,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Check count and delete oldest if over limit
      final allQueries =
          await recentSearchRef.orderBy('timestamp', descending: true).get();

      if (allQueries.docs.length > 10) {
        // Keep max 10 recent searches
        final oldestQueries = allQueries.docs.sublist(10);

        for (final doc in oldestQueries) {
          await recentSearchRef.doc(doc.id).delete();
        }
      }
    }
  }

  @override
  Future<void> clearRecentSearches({
    required String userId,
  }) async {
    final batch = _firestore.batch();
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('recent_searches')
        .get();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
