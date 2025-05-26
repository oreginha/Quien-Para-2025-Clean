// lib/domain/services/matching_service.dart

import 'package:flutter/foundation.dart';

/// Servicio para implementar el algoritmo de matching entre usuarios y planes
///
/// Este servicio proporciona métodos para calcular la compatibilidad entre
/// usuarios y planes basándose en diferentes criterios como intereses,
/// ubicación y disponibilidad.
class MatchingService {
  /// Calcula la puntuación de compatibilidad entre un usuario y un plan
  ///
  /// Retorna un valor entre 0.0 y 1.0, donde 1.0 es la máxima compatibilidad
  ///
  /// Parámetros:
  /// - userInterests: Lista de intereses del usuario
  /// - userLocation: Ubicación del usuario
  /// - planCategory: Categoría del plan
  /// - planDescription: Descripción del plan
  /// - planLocation: Ubicación del plan
  /// - planDate: Fecha del plan (opcional)
  double calculateMatchScore({
    required List<String> userInterests,
    required String userLocation,
    required String planCategory,
    required String planDescription,
    required String planLocation,
    DateTime? planDate,
  }) {
    try {
      // Puntuación basada en intereses (40% del total)
      final double interestsScore = _calculateInterestsScore(
        userInterests: userInterests,
        planCategory: planCategory,
        planDescription: planDescription,
      );

      // Puntuación basada en ubicación (40% del total)
      final double locationScore = _calculateLocationScore(
        userLocation: userLocation,
        planLocation: planLocation,
      );

      // Puntuación basada en disponibilidad (20% del total)
      final double availabilityScore = _calculateAvailabilityScore(
        planDate: planDate,
      );

      // Combinación ponderada de las puntuaciones
      final double finalScore =
          (interestsScore * 0.4) +
          (locationScore * 0.4) +
          (availabilityScore * 0.2);

      return finalScore;
    } catch (e) {
      if (kDebugMode) {
        print('Error al calcular puntuación de matching: $e');
      }
      return 0.3; // Valor predeterminado en caso de error
    }
  }

  /// Calcula la puntuación basada en intereses
  double _calculateInterestsScore({
    required List<String> userInterests,
    required String planCategory,
    required String planDescription,
  }) {
    if (userInterests.isEmpty) {
      return 0.3; // Puntuación baja para usuarios sin intereses
    }

    // Verificar coincidencia directa con la categoría
    final bool hasCategoryMatch = userInterests.any(
      (String interest) => interest.toLowerCase() == planCategory.toLowerCase(),
    );

    if (hasCategoryMatch) {
      return 0.8; // Alta coincidencia si hay un interés directo con la categoría
    }

    // Categorías relacionadas para mejorar el matching
    final Map<String, List<String>> relatedCategories = <String, List<String>>{
      'social': <String>[
        'amigos',
        'fiesta',
        'reunión',
        'comunicación',
        'networking',
      ],
      'deporte': <String>[
        'ejercicio',
        'fitness',
        'atletismo',
        'competición',
        'entrenamiento',
      ],
      'cultura': <String>[
        'arte',
        'museos',
        'teatro',
        'literatura',
        'música',
        'cine',
      ],
      'gastronomía': <String>[
        'comida',
        'cocina',
        'restaurantes',
        'bebidas',
        'gourmet',
      ],
      'naturaleza': <String>[
        'aire libre',
        'aventura',
        'senderismo',
        'camping',
        'playa',
      ],
      'educación': <String>[
        'aprendizaje',
        'cursos',
        'talleres',
        'idiomas',
        'conferencias',
      ],
    };

    // Verificar categorías relacionadas
    final List<String> relatedToCategory =
        relatedCategories[planCategory.toLowerCase()] ?? <String>[];

    // Contador de coincidencias en intereses relacionados
    int relatedMatches = 0;

    for (final String interest in userInterests) {
      // Verificar si el interés aparece en la descripción del plan
      if (planDescription.toLowerCase().contains(interest.toLowerCase())) {
        return 0.7; // Buena coincidencia si el interés aparece en la descripción
      }

      // Verificar coincidencias con categorías relacionadas
      for (final String related in relatedToCategory) {
        if (interest.toLowerCase().contains(related) ||
            related.contains(interest.toLowerCase())) {
          relatedMatches++;
          break; // Salir del bucle interno una vez que se encuentra una coincidencia
        }
      }
    }

    if (relatedMatches > 0) {
      // Calcular puntuación basada en el número de coincidencias relacionadas
      return 0.4 + (relatedMatches / userInterests.length) * 0.3;
    }

    return 0.3; // Puntuación baja si no hay coincidencias
  }

  /// Calcula la puntuación basada en ubicación
  double _calculateLocationScore({
    required String userLocation,
    required String planLocation,
  }) {
    if (userLocation.isEmpty || planLocation.isEmpty) {
      return 0.5; // Puntuación neutra si falta información de ubicación
    }

    // Coincidencia exacta de ubicación
    if (userLocation.toLowerCase() == planLocation.toLowerCase()) {
      return 1.0; // Máxima puntuación para ubicación exacta
    }

    // Verificar si la ubicación del usuario contiene la del plan o viceversa
    if (userLocation.toLowerCase().contains(planLocation.toLowerCase()) ||
        planLocation.toLowerCase().contains(userLocation.toLowerCase())) {
      return 0.8; // Alta puntuación para ubicaciones relacionadas
    }

    // Implementación futura: usar distancia geográfica para calcular puntuación
    // Por ahora, retornar puntuación baja para ubicaciones diferentes
    return 0.2;
  }

  /// Calcula la puntuación basada en disponibilidad
  double _calculateAvailabilityScore({DateTime? planDate}) {
    if (planDate == null) {
      return 0.5; // Puntuación neutra si no hay fecha
    }

    final DateTime now = DateTime.now();
    final Duration difference = planDate.difference(now);

    // Si el plan ya pasó, puntuación mínima
    if (difference.isNegative) {
      return 0.0;
    }

    // Planes en los próximos 3 días tienen alta prioridad
    if (difference.inDays <= 3) {
      return 1.0;
    }

    // Planes en la próxima semana tienen buena prioridad
    if (difference.inDays <= 7) {
      return 0.8;
    }

    // Planes en las próximas 2 semanas tienen prioridad media
    if (difference.inDays <= 14) {
      return 0.6;
    }

    // Planes más lejanos tienen menor prioridad
    return 0.4;
  }

  /// Filtra una lista de planes según criterios de compatibilidad mínima
  List<Map<String, dynamic>> filterCompatiblePlans({
    required List<Map<String, dynamic>> plans,
    required List<String> userInterests,
    required String userLocation,
    double minimumScore = 0.4,
  }) {
    final List<Map<String, dynamic>> compatiblePlans = <Map<String, dynamic>>[];

    for (final Map<String, dynamic> plan in plans) {
      final double score = calculateMatchScore(
        userInterests: userInterests,
        userLocation: userLocation,
        planCategory: plan['category'] as String? ?? '',
        planDescription: plan['description'] as String? ?? '',
        planLocation: plan['location'] as String? ?? '',
        planDate: plan['date'] != null
            ? DateTime.parse(plan['date'] as String)
            : null,
      );

      if (score >= minimumScore) {
        compatiblePlans.add(<String, dynamic>{...plan, 'matchScore': score});
      }
    }

    // Ordenar por puntuación de mayor a menor
    compatiblePlans.sort(
      (Map<String, dynamic> a, Map<String, dynamic> b) =>
          (b['matchScore'] as double).compareTo(a['matchScore'] as double),
    );

    return compatiblePlans;
  }
}
