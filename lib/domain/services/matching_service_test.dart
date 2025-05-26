// lib/domain/services/matching_service_test.dart

import 'package:flutter/foundation.dart';

import 'matching_service.dart';

/// Clase para probar el servicio de matching
///
/// Esta clase contiene métodos para verificar que el algoritmo de matching
/// funcione correctamente con diferentes escenarios y criterios.
class MatchingServiceTest {
  final MatchingService _matchingService = MatchingService();

  /// Ejecuta todas las pruebas del servicio de matching
  void runAllTests() {
    testInterestsMatching();
    testLocationMatching();
    testAvailabilityMatching();
    testCombinedMatching();
    testFilterCompatiblePlans();
  }

  /// Prueba el matching basado en intereses
  void testInterestsMatching() {
    if (kDebugMode) {
      print('\n=== Prueba de matching por intereses ===');
    }

    // Caso 1: Coincidencia directa con la categoría
    final double score1 = _matchingService.calculateMatchScore(
      userInterests: <String>['deporte', 'música', 'cine'],
      userLocation: 'Madrid',
      planCategory: 'deporte',
      planDescription: 'Partido de fútbol en el parque',
      planLocation: 'Madrid',
    );

    if (kDebugMode) {
      print('Coincidencia directa con categoría: $score1');
    }
    assert(
      score1 > 0.7,
      'La puntuación debería ser alta para coincidencia directa',
    );

    // Caso 2: Coincidencia con la descripción
    final double score2 = _matchingService.calculateMatchScore(
      userInterests: <String>['música', 'conciertos', 'rock'],
      userLocation: 'Barcelona',
      planCategory: 'cultura',
      planDescription: 'Concierto de rock en vivo',
      planLocation: 'Barcelona',
    );

    if (kDebugMode) {
      print('Coincidencia con descripción: $score2');
    }
    assert(
      score2 > 0.6,
      'La puntuación debería ser alta si el interés aparece en la descripción',
    );

    // Caso 3: Coincidencia con categoría relacionada
    final double score3 = _matchingService.calculateMatchScore(
      userInterests: <String>['senderismo', 'montaña', 'fotografía'],
      userLocation: 'Granada',
      planCategory: 'naturaleza',
      planDescription: 'Excursión por la sierra',
      planLocation: 'Granada',
    );

    if (kDebugMode) {
      print('Coincidencia con categoría relacionada: $score3');
    }
    assert(
      score3 > 0.5,
      'La puntuación debería ser media-alta para categorías relacionadas',
    );

    // Caso 4: Sin coincidencias
    final double score4 = _matchingService.calculateMatchScore(
      userInterests: <String>['tecnología', 'programación', 'videojuegos'],
      userLocation: 'Valencia',
      planCategory: 'gastronomía',
      planDescription: 'Cata de vinos en bodega',
      planLocation: 'Valencia',
    );

    if (kDebugMode) {
      print('Sin coincidencias de intereses: $score4');
    }
    assert(
      score4 < 0.5,
      'La puntuación debería ser baja sin coincidencias de intereses',
    );
  }

  /// Prueba el matching basado en ubicación
  void testLocationMatching() {
    if (kDebugMode) {
      print('\n=== Prueba de matching por ubicación ===');
    }

    // Caso 1: Ubicación exacta
    final double score1 = _matchingService.calculateMatchScore(
      userInterests: <String>['cine'],
      userLocation: 'Madrid',
      planCategory: 'cultura',
      planDescription: 'Estreno de película',
      planLocation: 'Madrid',
    );

    if (kDebugMode) {
      print('Ubicación exacta: $score1');
    }
    assert(
      score1 > 0.7,
      'La puntuación debería ser alta para ubicación exacta',
    );

    // Caso 2: Ubicación relacionada
    final double score2 = _matchingService.calculateMatchScore(
      userInterests: <String>['cine'],
      userLocation: 'Madrid Centro',
      planCategory: 'cultura',
      planDescription: 'Estreno de película',
      planLocation: 'Madrid',
    );

    if (kDebugMode) {
      print('Ubicación relacionada: $score2');
    }
    assert(
      score2 > 0.6,
      'La puntuación debería ser alta para ubicación relacionada',
    );

    // Caso 3: Ubicación diferente
    final double score3 = _matchingService.calculateMatchScore(
      userInterests: <String>['cine'],
      userLocation: 'Barcelona',
      planCategory: 'cultura',
      planDescription: 'Estreno de película',
      planLocation: 'Madrid',
    );

    if (kDebugMode) {
      print('Ubicación diferente: $score3');
    }
    assert(
      score3 < 0.5,
      'La puntuación debería ser baja para ubicación diferente',
    );
  }

  /// Prueba el matching basado en disponibilidad
  void testAvailabilityMatching() {
    if (kDebugMode) {
      print('\n=== Prueba de matching por disponibilidad ===');
    }

    final DateTime now = DateTime.now();

    // Caso 1: Plan en los próximos 3 días
    final double score1 = _matchingService.calculateMatchScore(
      userInterests: <String>['cine'],
      userLocation: 'Madrid',
      planCategory: 'cultura',
      planDescription: 'Estreno de película',
      planLocation: 'Madrid',
      planDate: now.add(const Duration(days: 2)),
    );

    if (kDebugMode) {
      print('Plan en próximos 3 días: $score1');
    }
    assert(score1 > 0.7, 'La puntuación debería ser alta para planes próximos');

    // Caso 2: Plan en la próxima semana
    final double score2 = _matchingService.calculateMatchScore(
      userInterests: <String>['cine'],
      userLocation: 'Madrid',
      planCategory: 'cultura',
      planDescription: 'Estreno de película',
      planLocation: 'Madrid',
      planDate: now.add(const Duration(days: 6)),
    );

    if (kDebugMode) {
      print('Plan en próxima semana: $score2');
    }
    assert(
      score2 > 0.6,
      'La puntuación debería ser media-alta para planes en la próxima semana',
    );

    // Caso 3: Plan en fecha lejana
    final double score3 = _matchingService.calculateMatchScore(
      userInterests: <String>['cine'],
      userLocation: 'Madrid',
      planCategory: 'cultura',
      planDescription: 'Estreno de película',
      planLocation: 'Madrid',
      planDate: now.add(const Duration(days: 30)),
    );

    if (kDebugMode) {
      print('Plan en fecha lejana: $score3');
    }
    assert(
      score3 < 0.6,
      'La puntuación debería ser media-baja para planes lejanos',
    );
  }

  /// Prueba el matching combinado (intereses, ubicación y disponibilidad)
  void testCombinedMatching() {
    if (kDebugMode) {
      print('\n=== Prueba de matching combinado ===');
    }

    final DateTime now = DateTime.now();

    // Caso 1: Coincidencia perfecta
    final double score1 = _matchingService.calculateMatchScore(
      userInterests: <String>['deporte', 'fútbol', 'ejercicio'],
      userLocation: 'Madrid',
      planCategory: 'deporte',
      planDescription: 'Partido de fútbol amistoso',
      planLocation: 'Madrid',
      planDate: now.add(const Duration(days: 2)),
    );

    if (kDebugMode) {
      print('Coincidencia perfecta: $score1');
    }
    assert(
      score1 > 0.8,
      'La puntuación debería ser muy alta para coincidencia perfecta',
    );

    // Caso 2: Coincidencia media
    final double score2 = _matchingService.calculateMatchScore(
      userInterests: <String>['deporte', 'natación', 'ejercicio'],
      userLocation: 'Madrid',
      planCategory: 'deporte',
      planDescription: 'Partido de fútbol amistoso',
      planLocation: 'Madrid Centro',
      planDate: now.add(const Duration(days: 10)),
    );

    if (kDebugMode) {
      print('Coincidencia media: $score2');
    }
    assert(
      score2 > 0.5 && score2 < 0.8,
      'La puntuación debería ser media para coincidencia parcial',
    );

    // Caso 3: Coincidencia baja
    final double score3 = _matchingService.calculateMatchScore(
      userInterests: <String>['música', 'arte', 'teatro'],
      userLocation: 'Barcelona',
      planCategory: 'deporte',
      planDescription: 'Partido de fútbol amistoso',
      planLocation: 'Madrid',
      planDate: now.add(const Duration(days: 30)),
    );

    if (kDebugMode) {
      print('Coincidencia baja: $score3');
    }
    assert(
      score3 < 0.5,
      'La puntuación debería ser baja para poca coincidencia',
    );
  }

  /// Prueba el filtrado de planes compatibles
  void testFilterCompatiblePlans() {
    if (kDebugMode) {
      print('\n=== Prueba de filtrado de planes compatibles ===');
    }

    final DateTime now = DateTime.now();

    // Lista de planes de prueba
    final List<Map<String, dynamic>> testPlans = <Map<String, dynamic>>[
      <String, dynamic>{
        'id': '1',
        'title': 'Partido de fútbol',
        'description': 'Partido amistoso en el parque',
        'category': 'deporte',
        'location': 'Madrid',
        'date': now.add(const Duration(days: 2)).toIso8601String(),
      },
      <String, dynamic>{
        'id': '2',
        'title': 'Concierto de rock',
        'description': 'Banda local en directo',
        'category': 'música',
        'location': 'Barcelona',
        'date': now.add(const Duration(days: 5)).toIso8601String(),
      },
      <String, dynamic>{
        'id': '3',
        'title': 'Exposición de arte',
        'description': 'Arte contemporáneo',
        'category': 'cultura',
        'location': 'Madrid',
        'date': now.add(const Duration(days: 10)).toIso8601String(),
      },
      <String, dynamic>{
        'id': '4',
        'title': 'Cena gourmet',
        'description': 'Degustación de platos internacionales',
        'category': 'gastronomía',
        'location': 'Valencia',
        'date': now.add(const Duration(days: 15)).toIso8601String(),
      },
      <String, dynamic>{
        'id': '5',
        'title': 'Senderismo',
        'description': 'Ruta por la montaña',
        'category': 'naturaleza',
        'location': 'Granada',
        'date': now.add(const Duration(days: 8)).toIso8601String(),
      },
    ];

    // Caso 1: Usuario interesado en deporte en Madrid
    final List<Map<String, dynamic>> result1 = _matchingService
        .filterCompatiblePlans(
          plans: testPlans,
          userInterests: <String>['deporte', 'fútbol', 'ejercicio'],
          userLocation: 'Madrid',
          minimumScore: 0.4,
        );

    if (kDebugMode) {
      print(
        'Planes compatibles para usuario deportista en Madrid: ${result1.length}',
      );
    }
    for (final Map<String, dynamic> plan in result1) {
      if (kDebugMode) {
        print('- ${plan['title']} (Score: ${plan['matchScore']})');
      }
    }
    assert(result1.isNotEmpty, 'Debería haber al menos un plan compatible');
    assert(
      result1[0]['id'] == '1',
      'El primer plan debería ser el partido de fútbol',
    );

    // Caso 2: Usuario interesado en cultura en Madrid
    final List<Map<String, dynamic>> result2 = _matchingService
        .filterCompatiblePlans(
          plans: testPlans,
          userInterests: <String>['arte', 'museos', 'exposiciones'],
          userLocation: 'Madrid',
          minimumScore: 0.4,
        );

    if (kDebugMode) {
      print(
        '\nPlanes compatibles para usuario cultural en Madrid: ${result2.length}',
      );
    }
    for (final Map<String, dynamic> plan in result2) {
      if (kDebugMode) {
        print('- ${plan['title']} (Score: ${plan['matchScore']})');
      }
    }
    assert(result2.isNotEmpty, 'Debería haber al menos un plan compatible');

    // Caso 3: Usuario sin intereses específicos
    final List<Map<String, dynamic>> result3 = _matchingService
        .filterCompatiblePlans(
          plans: testPlans,
          userInterests: <String>[],
          userLocation: 'Madrid',
          minimumScore: 0.3, // Umbral más bajo para usuarios sin intereses
        );

    if (kDebugMode) {
      print(
        '\nPlanes compatibles para usuario sin intereses en Madrid: ${result3.length}',
      );
    }
    for (final Map<String, dynamic> plan in result3) {
      if (kDebugMode) {
        print('- ${plan['title']} (Score: ${plan['matchScore']})');
      }
    }
    assert(
      result3.isNotEmpty,
      'Debería haber planes compatibles basados solo en ubicación',
    );
  }
}
