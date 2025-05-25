// lib/services/interfaces/firestore_interface.dart

abstract class FirestoreInterface {
  /// Gets a list of suggested plans based on the provided categories
  Future<List<Map<String, dynamic>>> getSuggestedPlans(List<String> categories);

  /// Searches for plans based on the provided query string
  Future<List<Map<String, dynamic>>> searchPlans(String query);

  /// Gets a reference to a Firestore collection
  Future<List<Map<String, dynamic>>> getCollectionData(
    String collectionPath, {
    Map<String, dynamic>? whereConditions,
    String? orderByField,
    bool descending = false,
  });

  /// Updates a document in a collection
  Future<void> updateDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  );

  /// Gets the current user's ID
  String getCurrentUserId();
}
