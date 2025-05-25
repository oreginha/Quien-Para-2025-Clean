import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:quien_para/data/repositories/plan/plan_repository_impl.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/usecases/plan/load_suggested_plan_usecase.dart';

// Generar mocks
@GenerateMocks([PlanRepository])
import 'load_suggested_plan_usecase_test.mocks.dart';

void main() {
  late LoadSuggestedPlanUseCase loadSuggestedPlanUseCase;
  late MockPlanRepository mockPlanRepository;

  setUp(() {
    mockPlanRepository = MockPlanRepository();
    loadSuggestedPlanUseCase =
        LoadSuggestedPlanUseCase(mockPlanRepository as PlanRepositoryImpl);
  });

  final testCreatorId = 'test-creator-id';
  final testTimestamp = Timestamp.fromDate(DateTime(2024, 12, 31));
  final testSuggestedData = {
    'id': 'suggestion-id',
    'title': 'Suggested Plan',
    'description': 'Suggested Description',
    'location': 'Suggested Location',
    'date': testTimestamp,
    'category': 'Suggested Category',
    'imageUrl': 'https://example.com/suggested-image.jpg',
    'conditions': {'condition1': 'value1', 'condition2': 'value2'},
    'selectedThemes': ['theme1', 'theme2'],
  };

  group('LoadSuggestedPlanUseCase', () {
    test('should create PlanEntity from suggested data', () async {
      // Ejecutar el caso de uso
      final result = await loadSuggestedPlanUseCase.execute(
        creatorId: testCreatorId,
        suggestedData: testSuggestedData,
      );

      // Verificar que el resultado es un PlanEntity con los datos esperados
      expect(result, isA<PlanEntity>());
      expect(result.creatorId, equals(testCreatorId));
      expect(result.id, equals('suggestion-id'));
      expect(result.title, equals('Suggested Plan'));
      expect(result.description, equals('Suggested Description'));
      expect(result.location, equals('Suggested Location'));
      expect(result.date, equals(testTimestamp.toDate()));
      expect(result.category, equals('Suggested Category'));
      expect(
          result.imageUrl, equals('https://example.com/suggested-image.jpg'));
      expect(result.conditions,
          equals({'condition1': 'value1', 'condition2': 'value2'}));
      expect(result.selectedThemes, equals(['theme1', 'theme2']));
    });

    test('should handle missing fields in suggested data', () async {
      // Datos incompletos
      final incompleteData = {
        'title': 'Only Title',
      };

      // Ejecutar el caso de uso
      final result = await loadSuggestedPlanUseCase.execute(
        creatorId: testCreatorId,
        suggestedData: incompleteData,
      );

      // Verificar que los campos faltantes tienen valores por defecto
      expect(result, isA<PlanEntity>());
      expect(result.creatorId, equals(testCreatorId));
      expect(result.id, equals(''));
      expect(result.title, equals('Only Title'));
      expect(result.description, equals(''));
      expect(result.location, equals(''));
      expect(result.date, isNull);
      expect(result.category, equals(''));
      expect(result.imageUrl, equals(''));
      expect(result.conditions, equals({}));
      expect(result.selectedThemes, equals([]));
    });

    test('should handle errors during conversion', () {
      // Datos malformados (fecha con formato incorrecto)
      final malformedData = {
        'date': 'not-a-timestamp',
      };

      // Verificar que se lanza una excepción
      expect(
        () => loadSuggestedPlanUseCase.execute(
          creatorId: testCreatorId,
          suggestedData: malformedData,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
