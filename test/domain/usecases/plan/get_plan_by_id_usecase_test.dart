import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:quien_para/data/repositories/plan/plan_repository_impl.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/usecases/plan/get_plan_by_id_usecase.dart';
import 'package:quien_para/domain/failures/app_failures.dart';

import 'get_plan_by_id_usecase_test.mocks.dart';

// Crear archivo de anotaciones para mockito
@GenerateMocks([PlanRepository])
void main() {
  late GetPlanByIdUseCase getPlanByIdUseCase;
  late MockPlanRepository mockPlanRepository;

  setUp(() {
    mockPlanRepository = MockPlanRepository();
    getPlanByIdUseCase =
        GetPlanByIdUseCase(mockPlanRepository as PlanRepositoryImpl);
  });

  final testPlanId = 'test-plan-id';
  final testPlan = PlanEntity(
    id: testPlanId,
    creatorId: 'test-user-id',
    title: 'Test Plan',
    description: 'Test Description',
    location: 'Test Location',
    date: DateTime(2024, 12, 31),
    category: 'Test Category',
    imageUrl: 'https://example.com/image.jpg',
    conditions: {'condition1': 'value1', 'condition2': 'value2'},
    selectedThemes: ['theme1', 'theme2'],
    tags: ['tag1', 'tag2'], // Campo requerido que faltaba
    likes: 0, // Campo requerido con valor por defecto
    createdAt: DateTime.now(), // Timestamp opcional
    updatedAt: null, // Timestamp opcional
    payCondition: null, // Campo opcional
    guestCount: null, // Campo opcional
    extraConditions: '', // Campo adicional requerido
  );

  group('GetPlanByIdUseCase', () {
    test('should get plan by id from repository', () async {
      // Configurar el mock para devolver el plan de prueba envuelto en Either.Right
      when(mockPlanRepository.getById(testPlanId))
          .thenAnswer((_) async => Right(testPlan));

      // Ejecutar el caso de uso
      final result = await getPlanByIdUseCase.execute(testPlanId);

      // Verificar que el método del repositorio fue llamado con el ID correcto
      verify(mockPlanRepository.getById(testPlanId));

      // Verificar que el resultado es el plan esperado usando fold
      result.fold(
        (failure) => fail('Should not return failure'),
        (plan) {
          expect(plan, equals(testPlan));
          expect(plan?.id, equals(testPlanId));
          expect(plan?.title, equals('Test Plan'));
        },
      );
    });

    test('should throw exception when repository returns null', () async {
      // Configurar el mock para devolver null envuelto en Either.Right
      when(mockPlanRepository.getById(testPlanId))
          .thenAnswer((_) async => Right(null));

      // Ejecutar el caso de uso
      final result = await getPlanByIdUseCase.execute(testPlanId);

      // Verificar que el método del repositorio fue llamado con el ID correcto
      verify(mockPlanRepository.getById(testPlanId));

      // Verificar que el resultado es null
      result.fold(
        (failure) => fail('Should not return failure'),
        (plan) => expect(plan, isNull),
      );
    });

    test('should throw exception when repository throws an error', () async {
      // Configurar el mock para devolver un error envuelto en Either.Left
      when(mockPlanRepository.getById(testPlanId)).thenAnswer((_) async =>
          Left(NetworkFailure(message: 'Server error occurred', code: '')));

      // Ejecutar el caso de uso
      final result = await getPlanByIdUseCase.execute(testPlanId);

      // Verificar que el método del repositorio fue llamado con el ID correcto
      verify(mockPlanRepository.getById(testPlanId));

      // Verificar que el resultado es un error
      result.fold(
        (failure) => expect(failure, isA<AppFailure>()),
        (plan) => fail('Should return failure'),
      );
    });
  });
}
