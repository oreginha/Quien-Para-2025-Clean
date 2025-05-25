// ignore_for_file: always_specify_types

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/usecases/plan/create_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/get_other_users_plans_usecase.dart';
import 'package:quien_para/domain/usecases/plan/get_plan_by_id_usecase.dart';
import 'package:quien_para/domain/usecases/plan/save_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/update_plan_usecase.dart';
import 'package:quien_para/presentation/bloc/plan/plan_bloc.dart';
import 'package:quien_para/presentation/bloc/plan/plan_event.dart';
import 'package:quien_para/presentation/bloc/plan/plan_state.dart';
import '../../../helpers/test_helpers.mocks.dart';

class MockGetPlanByIdUseCase extends Mock implements GetPlanByIdUseCase {}

class MockCreatePlanUseCase extends Mock implements CreatePlanUseCase {}

class MockUpdatePlanUseCase extends Mock implements UpdatePlanUseCase {}

class MockSavePlanUseCase extends Mock implements SavePlanUseCase {}

class MockGetOtherUserPlansUseCase extends Mock
    implements GetOtherUserPlansUseCase {}

void main() {
  late PlanBloc planBloc;
  late MockPlanRepository mockPlanRepository;
  late MockGetPlanByIdUseCase mockGetPlanByIdUseCase;
  late MockCreatePlanUseCase mockCreatePlanUseCase;
  late MockUpdatePlanUseCase mockUpdatePlanUseCase;
  late MockSavePlanUseCase mockSavePlanUseCase;
  late MockGetOtherUserPlansUseCase mockGetOtherUserPlansUseCase;

  setUp(() {
    mockPlanRepository = MockPlanRepository();
    mockGetPlanByIdUseCase = MockGetPlanByIdUseCase();
    mockCreatePlanUseCase = MockCreatePlanUseCase();
    mockUpdatePlanUseCase = MockUpdatePlanUseCase();
    mockSavePlanUseCase = MockSavePlanUseCase();
    mockGetOtherUserPlansUseCase = MockGetOtherUserPlansUseCase();

    planBloc = PlanBloc(
      planRepository: mockPlanRepository,
      getPlanByIdUseCase: mockGetPlanByIdUseCase,
      createPlanUseCase: mockCreatePlanUseCase,
      updatePlanUseCase: mockUpdatePlanUseCase,
      savePlanUseCase: mockSavePlanUseCase,
      //otherUsersPlansUseCase: mockGetOtherUserPlansUseCase,
    );
  });

  tearDown(() {
    planBloc.close();
  });

  group('PlanBloc - Creación de planes', () {
    test('estado inicial debería ser PlanInitial', () {
      expect(planBloc.state, const PlanState.initial());
    });

    test('debería emitir PlanLoaded cuando se agrega CreatePlanEvent',
        () async {
      // Configurar el mock para devolver un plan exitosamente
      final testPlan = PlanEntity.empty().copyWith(
        id: 'test_id',
        title: '',
        description: '',
        location: '',
        category: '',
        creatorId: 'test_creator_id',
      );

      when(mockCreatePlanUseCase.execute(PlanEntity(
        id: '',
        title: '',
        description: '',
        location: '',
        category: '',
        tags: [],
        imageUrl: '',
        creatorId: 'test_creator_id',
        conditions: {},
        selectedThemes: [],
        extraConditions: '',
        likes: 0,
      ))).thenAnswer((_) async => Right(testPlan));

      final expectedStates = [
        isA<PlanLoaded>().having(
          (state) => state.plan,
          'plan',
          equals(testPlan),
        ),
      ];

      expectLater(planBloc.stream, emitsInOrder(expectedStates));

      planBloc.add(
          const PlanEvent.create(creatorId: 'test_creator_id', planData: {}));
    });

    test(
        'debería actualizar el campo del plan cuando se agrega UpdatePlanFieldEvent',
        () {
      const testTitle = 'Test Plan';
      final expectedStates = [
        isA<PlanLoaded>(),
        isA<PlanLoaded>().having(
          (state) => state.plan.title,
          'plan title',
          equals(testTitle),
        ),
      ];

      expectLater(planBloc.stream, emitsInOrder(expectedStates));

      when(mockCreatePlanUseCase.execute(PlanEntity.empty())).thenAnswer(
          (_) async => Right(PlanEntity.empty().copyWith(id: 'test_id')));
      planBloc.add(const PlanEvent.create());
      planBloc
          .add(const PlanEvent.updateField(field: 'title', value: testTitle));
    });

    test('debería actualizar múltiples campos del plan correctamente', () {
      const testTitle = 'Test Plan';
      const testDescription = 'Test Description';
      const testLocation = 'Test Location';

      when(mockCreatePlanUseCase.execute(PlanEntity.empty())).thenAnswer(
          (_) async => Right(PlanEntity.empty().copyWith(id: 'test_id')));
      planBloc.add(const PlanEvent.create());

      // Esperar a que se cree el plan
      expectLater(
        planBloc.stream,
        emits(isA<PlanLoaded>().having(
          (state) => state.plan.id,
          'plan id',
          isNotEmpty,
        )),
      );

      // Actualizar título
      planBloc
          .add(const PlanEvent.updateField(field: 'title', value: testTitle));

      // Verificar que el título se actualizó
      expectLater(
        planBloc.stream,
        emits(isA<PlanLoaded>().having(
          (state) => state.plan.title,
          'plan title',
          equals(testTitle),
        )),
      );

      // Actualizar descripción
      planBloc.add(const PlanEvent.updateField(
          field: 'description', value: testDescription));

      // Verificar que la descripción se actualizó
      expectLater(
        planBloc.stream,
        emits(isA<PlanLoaded>().having(
          (state) => state.plan.description,
          'plan description',
          equals(testDescription),
        )),
      );

      // Actualizar ubicación
      planBloc.add(
          const PlanEvent.updateField(field: 'location', value: testLocation));

      // Verificar que la ubicación se actualizó
      expectLater(
        planBloc.stream,
        emits(isA<PlanLoaded>().having(
          (state) => state.plan.location,
          'plan location',
          equals(testLocation),
        )),
      );
    });

    /*  test('debería emitir PlanSaved cuando SavePlanEvent es exitoso', () async {
      when(mockCreatePlanUseCase.execute(any))
          .thenAnswer((_) async => Right(PlanEntity(
                id: 'test_id',
                title: 'Test Plan',
                description: 'Test Description',
                location: 'Test Location',
                conditions: const <String, String>{},
                selectedThemes: const <String>[],
                category: 'Test Category',
              ));

      final expectedStates = [
        isA<PlanLoaded>(),
        isA<PlanSaving>(),
        isA<PlanSaved>(),
      ];

      expectLater(planBloc.stream, emitsInOrder(expectedStates));

      when(mockCreatePlanUseCase.execute(any)).thenAnswer(
          (_) async => Right(PlanEntity.empty().copyWith(id: 'test_id')));
      planBloc.add(const PlanEvent.create());
      planBloc.add(const PlanEvent.save());
    });
  });*/

    group('PlanBloc - Edición de planes', () {
      test('debería cargar un plan existente correctamente', () {
        final testPlanData = {
          'id': 'test_id',
          'title': 'Test Plan',
          'description': 'Test Description',
          'location': 'Test Location',
          'category': 'Test Category',
          'conditions': {'condition1': 'value1'},
          'selectedThemes': ['theme1', 'theme2'],
          'creatorId': 'test_creator_id',
        };

        final expectedStates = [
          isA<PlanLoaded>().having(
            (state) => state.plan.id,
            'plan id',
            equals('test_id'),
          ),
        ];

        expectLater(planBloc.stream, emitsInOrder(expectedStates));

        planBloc.add(PlanEvent.loadExistingPlan(planData: testPlanData));
      });

      test('debería actualizar condiciones correctamente', () {
        final testConditions = {'condition1': 'value1', 'condition2': 'value2'};

        when(mockCreatePlanUseCase.execute(PlanEntity.empty())).thenAnswer(
            (_) async => Right(PlanEntity.empty().copyWith(id: 'test_id')));
        planBloc.add(const PlanEvent.create());

        // Esperar a que se cree el plan
        expectLater(
          planBloc.stream,
          emits(isA<PlanLoaded>()),
        );

        // Actualizar condiciones
        planBloc.add(PlanEvent.updateSelectedOptions(testConditions));

        // Verificar que las condiciones se actualizaron
        expectLater(
          planBloc.stream,
          emits(isA<PlanLoaded>().having(
            (state) => state.plan.conditions,
            'plan conditions',
            equals(testConditions),
          )),
        );
      });

      test('debería actualizar temas seleccionados correctamente', () {
        final testThemes = ['theme1', 'theme2', 'theme3'];

        when(mockCreatePlanUseCase.execute(PlanEntity.empty())).thenAnswer(
            (_) async => Right(PlanEntity.empty().copyWith(id: 'test_id')));
        planBloc.add(const PlanEvent.create());

        // Esperar a que se cree el plan
        expectLater(
          planBloc.stream,
          emits(isA<PlanLoaded>()),
        );

        // Actualizar temas
        planBloc.add(PlanEvent.updateSelectedThemes(testThemes));

        // Verificar que los temas se actualizaron
        expectLater(
          planBloc.stream,
          emits(isA<PlanLoaded>().having(
            (state) => state.plan.selectedThemes,
            'plan themes',
            equals(testThemes),
          )),
        );
      });

      test('debería actualizar condiciones adicionales correctamente', () {
        const testExtraConditions =
            'Estas son condiciones adicionales de prueba';

        when(mockCreatePlanUseCase.execute(PlanEntity.empty())).thenAnswer(
            (_) async => Right(PlanEntity.empty().copyWith(id: 'test_id')));
        planBloc.add(const PlanEvent.create());

        // Esperar a que se cree el plan
        expectLater(
          planBloc.stream,
          emits(isA<PlanLoaded>()),
        );

        // Actualizar condiciones adicionales
        planBloc
            .add(const PlanEvent.updateExtraConditions(testExtraConditions));

        // Verificar que las condiciones adicionales se actualizaron
        expectLater(
          planBloc.stream,
          emits(isA<PlanLoaded>().having(
            (state) => state.plan.extraConditions,
            'plan extra conditions',
            equals(testExtraConditions),
          )),
        );
      });

      test('debería limpiar el plan correctamente', () {
        when(mockCreatePlanUseCase.execute(PlanEntity.empty())).thenAnswer(
            (_) async => Right(PlanEntity.empty().copyWith(id: 'test_id')));
        planBloc.add(const PlanEvent.create());

        // Actualizar algunos campos
        planBloc.add(
            const PlanEvent.updateField(field: 'title', value: 'Test Title'));
        planBloc.add(const PlanEvent.updateField(
            field: 'description', value: 'Test Description'));

        // Limpiar el plan
        planBloc.add(const PlanEvent.clear());

        // Verificar que se creó un nuevo plan con campos vacíos
        expectLater(
          planBloc.stream,
          emits(isA<PlanLoaded>().having(
            (state) => state.plan.title,
            'plan title',
            isEmpty,
          )),
        );
      });
    });
  });
}
