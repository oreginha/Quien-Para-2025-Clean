// lib/data/datasources/remote/plan_api_service.dart
// ignore_for_file: always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:quien_para/domain/entities/plan/plan_entity.dart';

class PlanApiService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para crear un nuevo plan
  Future<PlanEntity> createPlan(final PlanEntity plan) async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('Usuario no autenticado');

      // Preparar datos del plan
      final Map<String, dynamic> planData = plan.toJson();
      // Asegurarse de que creatorId y esVisible estén correctamente configurados
      planData['creatorId'] = userId;
      planData['esVisible'] = true;
      planData['createdAt'] = FieldValue.serverTimestamp();

      // Crear documento en Firestore
      final DocumentReference<Map<String, dynamic>> docRef =
          await _firestore.collection('plans').add(planData);

      // Obtener el documento creado
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await docRef.get();
      final PlanEntity createdPlan = PlanEntity.fromJson(<String, dynamic>{
        ...docSnapshot.data() as Map<String, dynamic>,
        'id': docRef.id,
      });

      logger.d('Plan creado con éxito: ${docRef.id}');
      return createdPlan;
    } catch (e) {
      logger.e('Error creando plan:', error: e);
      throw Exception('Error al crear plan: $e');
    }
  }

  // Método para obtener planes con filtros
  Future<List<PlanEntity>> getPlans({
    final int limit = 10,
    final String? lastDocumentId,
    final String? category,
  }) async {
    try {
      // Consulta base
      Query query = _firestore.collection('plans');

      // Aplicar filtros
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }

      // Ordenar
      query = query.orderBy('createdAt', descending: true);

      // Paginación
      if (lastDocumentId != null) {
        final DocumentSnapshot<Map<String, dynamic>> lastDocSnapshot =
            await _firestore.collection('plans').doc(lastDocumentId).get();

        if (lastDocSnapshot.exists) {
          query = query.startAfterDocument(lastDocSnapshot);
        }
      }

      // Limitar resultados
      query = query.limit(limit);

      // Ejecutar consulta
      final QuerySnapshot<Object?> querySnapshot = await query.get();

      // Convertir a entidades
      return querySnapshot.docs.map((final QueryDocumentSnapshot<Object?> doc) {
        return PlanEntity.fromJson(<String, dynamic>{
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id,
        });
      }).toList();
    } catch (e) {
      logger.e('Error obteniendo planes:', error: e);
      throw Exception('Error al obtener planes: $e');
    }
  }

  // Método para dar "me gusta" a un plan
  Future<void> matchPlan(final String planId) async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('Usuario no autenticado');

      // Obtener el documento del plan
      final DocumentSnapshot<Map<String, dynamic>> planDoc =
          await _firestore.collection('plans').doc(planId).get();

      if (!planDoc.exists) {
        throw Exception('El plan no existe');
      }

      // Actualizar likes (esto es simplificado, en una implementación real
      // podrías tener una colección de "likes" para manejar esto mejor)
      final int currentLikes = (planDoc.data()!['likes'] as int?) ?? 0;

      await planDoc.reference.update({
        'likes': currentLikes + 1,
      });

      logger.d('Like añadido al plan: $planId');
    } catch (e) {
      logger.e('Error dando like a plan:', error: e);
      throw Exception('Error al dar like al plan: $e');
    }
  }

  // Método para quitar "me gusta" a un plan
  Future<void> unlikePlan(final String planId) async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('Usuario no autenticado');

      // Obtener el documento del plan
      final DocumentSnapshot<Map<String, dynamic>> planDoc =
          await _firestore.collection('plans').doc(planId).get();

      if (!planDoc.exists) {
        throw Exception('El plan no existe');
      }

      // Actualizar likes
      final int currentLikes = (planDoc.data()!['likes'] as int?) ?? 0;
      if (currentLikes > 0) {
        await planDoc.reference.update({
          'likes': currentLikes - 1,
        });
      }

      logger.d('Like removido del plan: $planId');
    } catch (e) {
      logger.e('Error quitando like a plan:', error: e);
      throw Exception('Error al quitar like al plan: $e');
    }
  }

  // Método para eliminar un plan
  Future<void> deletePlan(final String planId) async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('Usuario no autenticado');

      // Verificar que el usuario es el creador (opcional pero recomendado)
      final DocumentSnapshot<Map<String, dynamic>> planDoc =
          await _firestore.collection('plans').doc(planId).get();

      if (!planDoc.exists) {
        throw Exception('El plan no existe');
      }

      if (planDoc.data()!['creatorId'] != userId) {
        throw Exception('No tienes permiso para eliminar este plan');
      }

      // Eliminar el plan
      await _firestore.collection('plans').doc(planId).delete();

      logger.d('Plan eliminado: $planId');
    } catch (e) {
      logger.e('Error eliminando plan:', error: e);
      throw Exception('Error al eliminar plan: $e');
    }
  }
}
