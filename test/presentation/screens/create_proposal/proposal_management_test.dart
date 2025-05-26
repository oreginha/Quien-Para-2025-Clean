// ignore_for_file: always_specify_types, unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import '../../../helpers/test_helpers.mocks.dart';

// Mock para simular la navegación
class MockNavigator extends Mock {
  void push(String route, {Object? extra});
  void pop();
}

/*
void main() {
  late PlanBloc planBloc;
  late MockPlanRepositoryImpl mockPlanRepository;
  late MockNavigator mockNavigator;

  setUp(() {
    mockPlanRepository = MockPlanRepositoryImpl();
    planBloc = PlanBloc(planRepository: mockPlanRepository);
    mockNavigator = MockNavigator();
  });

  tearDown(() {
    planBloc.close();
  });

  group('Gestión de propuestas - Edición', () {
    testWidgets(
        'debería cargar correctamente una propuesta existente para editar',
        (WidgetTester tester) async {
      // Datos de un plan existente
      final existingPlanData = {
        'id': 'existing_plan_id',
        'title': 'Plan Existente',
        'description': 'Descripción del plan existente',
        'location': 'Ubicación existente',
        'category': 'Categoría existente',
        'conditions': {'condicion1': 'valor1'},
        'selectedThemes': ['tema1', 'tema2'],
        'creatorId': 'user_id_test',
      };

      // Cargar el plan existente en el bloc
      planBloc.add(PlanEvent.loadExistingPlan(planData: existingPlanData));
      await tester.pumpAndSettle();

      // Verificar que el plan se cargó correctamente
      expect(
        planBloc.state,
        isA<PlanLoaded>().having(
          (state) => state.plan.id,
          'plan id',
          equals('existing_plan_id'),
        ),
      );

      expect(
        planBloc.state,
        isA<PlanLoaded>().having(
          (state) => state.plan.title,
          'plan title',
          equals('Plan Existente'),
        ),
      );
    });

    test('debería actualizar correctamente un plan existente', () {
      // Datos de un plan existente
      final existingPlanData = {
        'id': 'existing_plan_id',
        'title': 'Plan Existente',
        'description': 'Descripción del plan existente',
        'location': 'Ubicación existente',
        'category': 'Categoría existente',
        'conditions': {'condicion1': 'valor1'},
        'selectedThemes': ['tema1', 'tema2'],
        'creatorId': 'user_id_test',
      };

      // Configurar el mock para que tenga éxito al actualizar
      when(mockPlanRepository.updatePlan(any))
          .thenAnswer((_) async => PlanEntity(
                id: 'existing_plan_id',
                title: 'Plan Actualizado',
                description: 'Descripción actualizada',
                location: 'Ubicación actualizada',
                category: 'Categoría actualizada',
              ));

      // Cargar el plan existente
      planBloc.add(PlanEvent.loadExistingPlan(planData: existingPlanData));

      // Actualizar campos
      planBloc.add(const PlanEvent.updateField(
          field: 'title', value: 'Plan Actualizado'));
      planBloc.add(const PlanEvent.updateField(
          field: 'description', value: 'Descripción actualizada'));
      planBloc.add(const PlanEvent.updateField(
          field: 'location', value: 'Ubicación actualizada'));
      planBloc.add(const PlanEvent.updateField(
          field: 'category', value: 'Categoría actualizada'));

      // Guardar el plan actualizado
      planBloc.add(const PlanEvent.save());

      // Verificar que se emite un estado de guardado
      expectLater(
        planBloc.stream,
        emitsThrough(isA<PlanSaved>()),
      );
    });
  });

  group('Gestión de propuestas - Eliminación', () {
    test('debería eliminar correctamente un plan existente', () {
      // Configurar el mock para que tenga éxito al eliminar
      when(mockPlanRepository.deletePlan('existing_plan_id'))
          .thenAnswer((_) async => true);

      // Datos de un plan existente
      final existingPlanData = {
        'id': 'existing_plan_id',
        'title': 'Plan a Eliminar',
        'description': 'Descripción del plan a eliminar',
        'location': 'Ubicación del plan',
        'creatorId': 'user_id_test',
      };

      // Cargar el plan existente
      planBloc.add(PlanEvent.loadExistingPlan(planData: existingPlanData));

      // Verificar que el plan se cargó correctamente
      expectLater(
        planBloc.stream,
        emits(isA<PlanLoaded>().having(
          (state) => state.plan.id,
          'plan id',
          equals('existing_plan_id'),
        )),
      );

      // Eliminar el plan (esto dependerá de cómo se implemente la eliminación)
      // Por ejemplo, podría ser un evento específico como DeletePlanEvent
      // O podría ser una llamada directa al repositorio
      // Este es un ejemplo conceptual
      mockPlanRepository.deletePlan('existing_plan_id');

      // Verificar que se llamó al método de eliminación
      verify(mockPlanRepository.deletePlan('existing_plan_id')).called(1);
    });
  });

  group('Gestión de propuestas - Visualización', () {
    test('debería cargar correctamente los detalles de un plan', () {
      // Datos de un plan existente
      final existingPlanData = {
        'id': 'existing_plan_id',
        'title': 'Plan para Visualizar',
        'description': 'Descripción detallada del plan',
        'location': 'Ubicación del plan',
        'category': 'Categoría del plan',
        'conditions': {'condicion1': 'valor1', 'condicion2': 'valor2'},
        'selectedThemes': ['tema1', 'tema2', 'tema3'],
        'creatorId': 'user_id_test',
        'imageUrl': 'https://example.com/image.jpg',
        'date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      };

      // Cargar el plan existente
      planBloc.add(PlanEvent.loadExistingPlan(planData: existingPlanData));

      // Verificar que todos los campos se cargaron correctamente
      expectLater(
        planBloc.stream,
        emits(isA<PlanLoaded>()
            .having(
              (state) => state.plan.title,
              'plan title',
              equals('Plan para Visualizar'),
            )
            .having(
              (state) => state.plan.description,
              'plan description',
              equals('Descripción detallada del plan'),
            )
            .having(
              (state) => state.plan.location,
              'plan location',
              equals('Ubicación del plan'),
            )
            .having(
              (state) => state.plan.category,
              'plan category',
              equals('Categoría del plan'),
            )
            .having(
              (state) => state.plan.conditions.length,
              'conditions count',
              equals(2),
            )
            .having(
              (state) => state.plan.selectedThemes.length,
              'themes count',
              equals(3),
            )),
      );
    });
  });
}*/
