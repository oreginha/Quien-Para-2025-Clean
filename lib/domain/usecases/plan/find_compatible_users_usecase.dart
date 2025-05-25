// lib/domain/usecases/find_compatible_users_usecase.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/matching_service.dart';

/// Caso de uso para encontrar usuarios compatibles con un plan específico
///
/// Este caso de uso utiliza el servicio de matching para encontrar
/// usuarios que sean compatibles con un plan basándose en sus intereses y ubicación.
class FindCompatibleUsersUseCase {
  final FirebaseFirestore _firestore;
  final MatchingService _matchingService;

  FindCompatibleUsersUseCase(
    this._firestore,
    this._matchingService,
  );

  /// Encuentra usuarios compatibles para un plan específico
  ///
  /// Parámetros:
  /// - planId: ID del plan
  /// - planCategory: Categoría del plan
  /// - planDescription: Descripción del plan
  /// - planLocation: Ubicación del plan
  /// - planDate: Fecha del plan (opcional)
  /// - limit: Número máximo de usuarios a retornar (opcional)
  /// - minimumScore: Puntuación mínima de compatibilidad (opcional)
  Future<List<Map<String, dynamic>>> call({
    required String planId,
    required String planCategory,
    required String planDescription,
    required String planLocation,
    DateTime? planDate,
    int limit = 10,
    double minimumScore = 0.4,
  }) async {
    try {
      // Obtener el plan para excluir al creador
      final DocumentSnapshot<Map<String, dynamic>> planDoc =
          await _firestore.collection('plans').doc(planId).get();

      if (!planDoc.exists) {
        throw Exception('El plan no existe');
      }

      final Map<String, dynamic> planData =
          planDoc.data() as Map<String, dynamic>;
      final String creatorId = planData['creatorId'] as String;

      // Obtener todos los usuarios
      final QuerySnapshot<Map<String, dynamic>> usersQuery =
          await _firestore.collection('users').get();

      // Lista para almacenar usuarios compatibles
      final List<Map<String, dynamic>> compatibleUsers =
          <Map<String, dynamic>>[];

      // Procesar cada usuario
      for (final QueryDocumentSnapshot<Map<String, dynamic>> userDoc
          in usersQuery.docs) {
        final Map<String, dynamic> userData = userDoc.data();
        final String userId = userDoc.id;

        // Excluir al creador del plan
        if (userId == creatorId) continue;

        // Obtener intereses y ubicación del usuario
        final List<String> userInterests = List<String>.from(
            userData['interests'] as List<dynamic>? ?? <String>[]);
        final String userLocation = userData['location'] as String? ?? '';

        // Calcular puntuación de compatibilidad
        final double score = _matchingService.calculateMatchScore(
          userInterests: userInterests,
          userLocation: userLocation,
          planCategory: planCategory,
          planDescription: planDescription,
          planLocation: planLocation,
          planDate: planDate,
        );

        // Añadir usuario si supera la puntuación mínima
        if (score >= minimumScore) {
          compatibleUsers.add(<String, dynamic>{
            'userId': userId,
            'name': userData['name'] as String? ?? 'Usuario',
            'photoUrl': userData['photoUrls'] != null &&
                    (userData['photoUrls'] as List<dynamic>).isNotEmpty
                ? (userData['photoUrls'] as List<dynamic>)[0]
                : null,
            'interests': userInterests,
            'location': userLocation,
            'matchScore': score,
          });
        }
      }

      // Ordenar por puntuación de mayor a menor
      compatibleUsers.sort((Map<String, dynamic> a, Map<String, dynamic> b) =>
          (b['matchScore'] as double).compareTo(a['matchScore'] as double));

      // Limitar el número de resultados
      return compatibleUsers.take(limit).toList();
    } catch (e) {
      throw Exception('Error al buscar usuarios compatibles: $e');
    }
  }
}
