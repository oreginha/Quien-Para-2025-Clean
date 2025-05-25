// lib/services/implementations/firebase_storage.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/interfaces/storage_interface.dart';

class FirebaseMetricsStorage implements StorageInterface {
  final FirebaseFirestore _firestore;

  FirebaseMetricsStorage(this._firestore);

  @override
  Future<void> saveMetric(final String city, final bool wasEnabled) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('cityMetrics').doc(city);
      await docRef.set(<String, dynamic>{
        'totalAttempts': FieldValue.increment(1),
        'successfulSelections': FieldValue.increment(wasEnabled ? 1 : 0),
        'rejectedSelections': FieldValue.increment(wasEnabled ? 0 : 1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving to Firebase: $e');
      }
    }
  }

  @override
  Future<Map<String, int>> getMetrics(final String city) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firestore.collection('cityMetrics').doc(city).get();

      if (!docSnapshot.exists) {
        return <String, int>{};
      }

      final Map<String, dynamic> data = docSnapshot.data()!;
      return <String, int>{
        'totalAttempts': data['totalAttempts'] as int? ?? 0,
        'successfulSelections': data['successfulSelections'] as int? ?? 0,
        'rejectedSelections': data['rejectedSelections'] as int? ?? 0,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting metrics from Firebase: $e');
      }
      return <String, int>{};
    }
  }
}
