// test/integration/component_interaction_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/plan/get_plan_by_id_usecase.dart';
import 'package:quien_para/domain/usecases/plan/save_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/create_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/update_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/get_other_users_plans_usecase.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:quien_para/presentation/bloc/plan/plan_bloc.dart';
import 'package:quien_para/presentation/bloc/plan/plan_state.dart';
import 'package:quien_para/presentation/bloc/plan/plan_event.dart';

import '../data/repositories/enhanced_user_repository_impl_test.dart';
import '../domain/usecases/plan/get_other_users_plans_usecase_test.mocks.dart';

@GenerateMocks([PlanRepository, FirebaseAuth, User])
void main() {
  group('Pruebas de integración de componentes', () {
    late MockPlanRepository mockPlanRepository;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late GetPlanByIdUseCase getPlanByIdUseCase;
    late SavePlanUseCase savePlanUseCase;
    late CreatePlanUseCase createPlanUseCase;
    late UpdatePlanUseCase updatePlanUseCase;
    late GetOtherUserPlansUseCase otherUsersPlansUseCase;
    late PlanBloc planBloc;

    setUp(() {
      mockPlanRepository = MockPlanRepository();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      // Configuración de autenticación
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('user-123');

      // Inicializar casos de uso y bloc
      getPlanByIdUseCase = GetPlanByIdUseCase(mockPlanRepository);
      savePlanUseCase = SavePlanUseCase(mockPlanRepository);
      createPlanUseCase = CreatePlanUseCase(mockPlanRepository);
      updatePlanUseCase = UpdatePlanUseCase(mockPlanRepository);
      otherUsersPlansUseCase = GetOtherUserPlansUseCase(mockPlanRepository);

      // Inicializar blocs con casos de uso reales (no mocks)
      planBloc = PlanBloc(
        planRepository: mockPlanRepository,
        getPlanByIdUseCase: getPlanByIdUseCase,
        savePlanUseCase: savePlanUseCase,
        createPlanUseCase: createPlanUseCase,
        updatePlanUseCase: updatePlanUseCase,
        //otherUsersPlansUseCase: otherUsersPlansUseCase,
      );
    });

    tearDown(() {
      planBloc.close();
    });

    final testPlan = PlanEntity(
      id: 'test-plan-id',
      title: 'Test Plan Title',
      description: 'Test Description',
      creatorId: 'user-123',
      location: 'Test Location',
      date: DateTime(2025, 5, 18),
      createdAt: DateTime(2025, 5, 1),
      category: 'Test Category',
      imageUrl: 'https://via.placeholder.com/150',
      likes: 10,
      tags: ['tag1', 'tag2'],
      conditions: {'condition1': 'value1'},
      selectedThemes: ['theme1'],
      extraConditions: 'Extra conditions',
    );

    test(
        'Flujo completo: GetPlanByIdUseCase utiliza correctamente el repositorio',
        () async {
      // Configurar repositorio para devolver un plan
      when(mockPlanRepository.getById('test-plan-id'))
          .thenAnswer((_) async => Right(testPlan));

      // Ejecutar caso de uso
      final result = await getPlanByIdUseCase.execute('test-plan-id');

      // Verificar que el caso de uso retorna el plan correcto
      expect(result.isRight(), true);
      expect(result.fold((l) => null, (r) => r), testPlan);

      // Verificar que el repositorio fue llamado correctamente
      verify(mockPlanRepository.getById('test-plan-id')).called(1);
    });

    test('Flujo de error: GetPlanByIdUseCase maneja correctamente los fallos',
        () async {
      // Configurar repositorio para devolver un error
      final failure = AppFailure(message: 'Error de servidor', code: '500');
      when(mockPlanRepository.getById('test-plan-id'))
          .thenAnswer((_) async => Left(failure));

      // Ejecutar caso de uso
      final result = await getPlanByIdUseCase.execute('test-plan-id');

      // Verificar que el caso de uso retorna el error correcto
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), failure);
    });

    blocTest<PlanBloc, PlanState>(
      'PlanBloc interactúa correctamente con GetPlanByIdUseCase',
      build: () {
        // Configurar repositorio para devolver un plan
        when(mockPlanRepository.getById('test-plan-id'))
            .thenAnswer((_) async => Right(testPlan));
        return planBloc;
      },
      act: (bloc) => bloc
          .add(PlanEvent.loadExistingPlan(planData: {'id': 'test-plan-id'})),
      expect: () => [
        isA<PlanState>().having((state) => state.runtimeType.toString(),
            'stateType', contains('_Loading')),
        isA<PlanLoaded>()
            .having((state) => state.plan, 'plan', equals(testPlan)),
      ],
      verify: (_) {
        // Verificar que el repositorio fue llamado correctamente
        verify(mockPlanRepository.getById('test-plan-id')).called(1);
      },
    );

    blocTest<PlanBloc, PlanState>(
      'PlanBloc maneja correctamente errores de GetPlanByIdUseCase',
      build: () {
        // Configurar repositorio para devolver un error
        final failure = AppFailure(message: 'Error de servidor', code: '500');
        when(mockPlanRepository.getById('test-plan-id'))
            .thenAnswer((_) async => Left(failure));
        return planBloc;
      },
      act: (bloc) => bloc
          .add(PlanEvent.loadExistingPlan(planData: {'id': 'test-plan-id'})),
      expect: () => [
        isA<PlanState>().having((state) => state.runtimeType.toString(),
            'stateType', contains('_Loading')),
        isA<PlanError>().having(
            (state) => state.message, 'message', contains('Error de servidor')),
      ],
    );

    test('Flujo completo: SavePlanUseCase utiliza correctamente el repositorio',
        () async {
      // Configurar repositorio
      when(mockPlanRepository.update(testPlan))
          .thenAnswer((_) async => Right(testPlan));
      when(mockPlanRepository.getById('test-plan-id'))
          .thenAnswer((_) async => Right(testPlan));

      // Ejecutar caso de uso para un plan existente
      final result = await savePlanUseCase.execute(testPlan);

      // Verificar que el caso de uso retorna correctamente
      expect(result.isRight(), true);

      // Verificar que el repositorio fue llamado correctamente
      verify(mockPlanRepository.update(testPlan)).called(1);
    });

    test(
        'Flujo completo para nuevo plan: SavePlanUseCase utiliza correctamente el repositorio',
        () async {
      // Crear plan sin id (nuevo)
      final newPlan = testPlan.copyWith(id: '');

      // Configurar repositorio
      when(mockPlanRepository.create(newPlan))
          .thenAnswer((_) async => Right(testPlan));

      // Ejecutar caso de uso para un nuevo plan
      final result = await savePlanUseCase.execute(newPlan);

      // Verificar que el caso de uso retorna correctamente
      expect(result.isRight(), true);
      expect(result.fold((l) => null, (r) => r), testPlan);

      // Verificar que el repositorio fue llamado correctamente
      verify(mockPlanRepository.create(newPlan)).called(1);
    });

    blocTest<PlanBloc, PlanState>(
      'PlanBloc salva un plan correctamente utilizando SavePlanUseCase',
      build: () {
        // Configurar repositorio
        when(mockPlanRepository.update(testPlan))
            .thenAnswer((_) async => Right(testPlan));
        when(mockPlanRepository.getById('test-plan-id'))
            .thenAnswer((_) async => Right(testPlan));

        // Pre-cargar el bloc con el plan
        planBloc.emit(PlanState.loaded(plan: testPlan));

        return planBloc;
      },
      act: (bloc) => bloc.add(const PlanEvent.save()),
      expect: () => [
        isA<PlanSaving>(),
        isA<PlanSaved>()
            .having((state) => state.plan, 'plan', equals(testPlan)),
      ],
      verify: (_) {
        // Verificar que el repositorio fue llamado correctamente
        verify(mockPlanRepository.update(testPlan)).called(1);
      },
    );

    // Prueba la interacción entre mútiples casos de uso y el bloc
    blocTest<PlanBloc, PlanState>(
      'PlanBloc interactúa correctamente con múltiples casos de uso',
      build: () {
        // Configurar repositorio
        when(mockPlanRepository.getById('test-plan-id'))
            .thenAnswer((_) async => Right(testPlan));
        when(mockPlanRepository.update(any))
            .thenAnswer((_) async => Right(testPlan));

        return planBloc;
      },
      act: (bloc) async {
        // Cargar un plan existente
        bloc.add(PlanEvent.loadExistingPlan(planData: {'id': 'test-plan-id'}));

        // Esperar a que se cargue
        await Future.delayed(const Duration(milliseconds: 100));

        // Actualizar un campo
        bloc.add(PlanEvent.updateField(field: 'title', value: 'Nuevo título'));

        // Esperar a que se actualice
        await Future.delayed(const Duration(milliseconds: 100));

        // Guardar el plan
        bloc.add(const PlanEvent.save());
      },
      expect: () => [
        isA<PlanState>().having((state) => state.runtimeType.toString(),
            'stateType', contains('_Loading')),
        isA<PlanLoaded>()
            .having((state) => state.plan, 'plan', equals(testPlan)),
        isA<PlanLoaded>()
            .having((state) => state.plan.title, 'plan.title', 'Nuevo título'),
        isA<PlanSaving>(),
        isA<PlanSaved>(),
      ],
      verify: (_) {
        // Verificar que el repositorio fue llamado correctamente
        verify(mockPlanRepository.getById('test-plan-id')).called(1);

        // Capturar el argumento pasado a update
        final captor = verify(mockPlanRepository.update(captureAny))
            .captured
            .first as PlanEntity;
        expect(captor.title, 'Nuevo título');
      },
    );
  });
}
