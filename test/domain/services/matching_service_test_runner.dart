// test/domain/services/matching_service_test_runner.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/domain/services/matching_service.dart';
import 'package:quien_para/domain/services/matching_service_test.dart';

void main() {
  group('MatchingService Tests', () {
    final MatchingService matchingService = MatchingService();
    final MatchingServiceTest tester = MatchingServiceTest();

    test('Intereses - Coincidencia directa con categoría', () {
      final double score = matchingService.calculateMatchScore(
        userInterests: <String>['deporte', 'música', 'cine'],
        userLocation: 'Madrid',
        planCategory: 'deporte',
        planDescription: 'Partido de fútbol en el parque',
        planLocation: 'Madrid',
      );

      expect(score, greaterThan(0.7));
    });

    test('Intereses - Coincidencia con descripción', () {
      final double score = matchingService.calculateMatchScore(
        userInterests: <String>['música', 'conciertos', 'rock'],
        userLocation: 'Barcelona',
        planCategory: 'cultura',
        planDescription: 'Concierto de rock en vivo',
        planLocation: 'Barcelona',
      );

      expect(score, greaterThan(0.6));
    });

    test('Ubicación - Coincidencia exacta', () {
      final double score = matchingService.calculateMatchScore(
        userInterests: <String>['cine'],
        userLocation: 'Madrid',
        planCategory: 'cultura',
        planDescription: 'Estreno de película',
        planLocation: 'Madrid',
      );

      expect(score, greaterThan(0.7));
    });

    test('Ubicación - Sin coincidencia', () {
      final double score = matchingService.calculateMatchScore(
        userInterests: <String>['cine'],
        userLocation: 'Barcelona',
        planCategory: 'cultura',
        planDescription: 'Estreno de película',
        planLocation: 'Madrid',
      );

      expect(score, lessThan(0.5));
    });

    test('Disponibilidad - Plan próximo', () {
      final DateTime now = DateTime.now();
      final double score = matchingService.calculateMatchScore(
        userInterests: <String>['cine'],
        userLocation: 'Madrid',
        planCategory: 'cultura',
        planDescription: 'Estreno de película',
        planLocation: 'Madrid',
        planDate: now.add(const Duration(days: 2)),
      );

      expect(score, greaterThan(0.7));
    });

    test('Combinado - Coincidencia perfecta', () {
      final DateTime now = DateTime.now();
      final double score = matchingService.calculateMatchScore(
        userInterests: <String>['deporte', 'fútbol', 'ejercicio'],
        userLocation: 'Madrid',
        planCategory: 'deporte',
        planDescription: 'Partido de fútbol amistoso',
        planLocation: 'Madrid',
        planDate: now.add(const Duration(days: 2)),
      );

      expect(score, greaterThan(0.8));
    });

    test('Filtrado de planes compatibles', () {
      final DateTime now = DateTime.now();
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
      ];

      final List<Map<String, dynamic>> result = matchingService
          .filterCompatiblePlans(
            plans: testPlans,
            userInterests: <String>['deporte', 'fútbol'],
            userLocation: 'Madrid',
            minimumScore: 0.4,
          );

      expect(result, isNotEmpty);
      expect(result[0]['id'], equals('1'));
      expect(result[0]['matchScore'], greaterThan(0.7));
    });

    // Ejecutar todas las pruebas manuales (opcional)
    test('Ejecutar todas las pruebas manuales', () {
      tester.runAllTests();
      // No hay assertions aquí, solo se ejecutan las pruebas manuales
      expect(true, isTrue); // Dummy assertion
    });
  });
}
