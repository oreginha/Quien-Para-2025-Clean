// lib/core/services/plan_api_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

/// Servicio para interactuar con el API de planes
class PlanApiService {
  final FirebaseFirestore _firestore;

  PlanApiService([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Obtiene un plan por su ID
  Future<DocumentSnapshot> getById(String id) async {
    return await _firestore.collection('plans').doc(id).get();
  }

  /// Crea un nuevo plan
  Future<DocumentReference> createPlan(Map<String, dynamic> planData) async {
    return await _firestore.collection('plans').add(planData);
  }

  /// Actualiza un plan existente
  Future<void> updatePlan(String id, Map<String, dynamic> updates) async {
    await _firestore.collection('plans').doc(id).update(updates);
  }

  /// Elimina un plan
  Future<void> deletePlan(String id) async {
    await _firestore.collection('plans').doc(id).delete();
  }

  /// Obtiene una lista de planes con paginación
  Future<QuerySnapshot> getPlans({
    int limit = 10,
    DocumentSnapshot? startAfter,
    String? userId,
  }) async {
    Query query = _firestore
        .collection('plans')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (userId != null) {
      query = query.where('createdBy', isEqualTo: userId);
    }

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    return await query.get();
  }
}
