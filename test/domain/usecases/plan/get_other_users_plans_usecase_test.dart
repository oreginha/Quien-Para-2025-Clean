import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/plan/get_other_users_plans_usecase.dart';
import 'get_other_users_plans_usecase_test.mocks.dart';

// Generar mocks
@GenerateMocks([PlanRepository])
void main() {
  late GetOtherUserPlansUseCase getOtherUserPlansUseCase;
  late MockPlanRepository mockPlanRepository;

  setUp(() {
    mockPlanRepository = MockPlanRepository();
    getOtherUserPlansUseCase = GetOtherUserPlansUseCase(mockPlanRepository);
  });

  final testUserId = 'test-user-id';
  final testLimit = 20;

  final testPlans = [
    PlanEntity(
      id: 'plan-1',
      creatorId: 'other-user-1',
      title: 'Plan 1',
      description: 'Description 1',
      location: 'Location 1',
      date: DateTime(2024, 12, 1),
      category: 'Category 1',
      imageUrl: '',
      conditions: {},
      selectedThemes: [],
      tags: [],
      likes: 0,
      extraConditions: '',
    ),
    PlanEntity(
      id: 'plan-2',
      creatorId: 'other-user-2',
      title: 'Plan 2',
      description: 'Description 2',
      location: 'Location 2',
      date: DateTime(2024, 12, 2),
      category: 'Category 2',
      imageUrl: '',
      conditions: {},
      selectedThemes: [],
      tags: [],
      likes: 0,
      extraConditions: '',
    ),
  ];

  group('GetOtherUserPlansUseCase', () {
    test('should get stream of plans from other users from repository', () {
      // Configurar el mock para devolver un stream de planes
      when(mockPlanRepository.getOtherUserPlansStream(
        currentUserId: testUserId,
        limit: testLimit,
      )).thenAnswer((_) => Stream.value(Right(testPlans)));

      // Ejecutar el caso de uso
      final result = getOtherUserPlansUseCase.execute(
        currentUserId: testUserId,
        limit: testLimit,
      );

      // Verificar que el método del repositorio fue llamado con los parámetros correctos
      verify(mockPlanRepository.getOtherUserPlansStream(
        currentUserId: testUserId,
        limit: testLimit,
      ));

      // Verificar que el resultado es un stream que emite Either con los planes esperados
      expect(result, emits(Right(testPlans)));
    });

    test('should handle errors and return empty stream', () {
      // Configurar el mock para lanzar una excepción
      when(mockPlanRepository.getOtherUserPlansStream(
        currentUserId: testUserId,
        limit: testLimit,
      )).thenThrow(Exception('Repository error'));

      // Ejecutar el caso de uso
      final result = getOtherUserPlansUseCase.execute(
        currentUserId: testUserId,
        limit: testLimit,
      );

      // Verificar que el resultado es un stream que emite una lista vacía
      expect(result, emits([]));
    });

    test('should refresh plans using repository method', () async {
      // Configurar el mock para el método refreshOtherUserPlans
      when(mockPlanRepository.refreshOtherUserPlans(
              currentUserId: testUserId, limit: testLimit))
          .thenAnswer((_) async => Right(unit));

      // Ejecutar el método refreshPlans del caso de uso
      await getOtherUserPlansUseCase.refreshPlans(testUserId);

      // Verificar que el método del repositorio fue llamado con el ID de usuario correcto
      verify(mockPlanRepository.refreshOtherUserPlans(
          currentUserId: testUserId, limit: testLimit));
    });

    test('should rethrow exception when refresh fails', () async {
      // Configurar el mock para lanzar una excepción
      when(mockPlanRepository.refreshOtherUserPlans(
              currentUserId: testUserId, limit: testLimit))
          .thenThrow(Exception('Refresh error'));

      // Verificar que se lanza la misma excepción
      expect(
        () => getOtherUserPlansUseCase.refreshPlans(testUserId),
        throwsA(isA<Exception>()),
      );

      // Verificar que el método del repositorio fue llamado con el ID de usuario correcto
      verify(mockPlanRepository.refreshOtherUserPlans(
          currentUserId: testUserId, limit: testLimit));
    });
  });
}
