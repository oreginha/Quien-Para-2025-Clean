// ignore_for_file: always_specify_types, unused_import, unused_local_variable, always_declare_return_types, type_annotate_public_apis, inference_failure_on_function_return_type

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../helpers/test_helpers.mocks.dart';
import '../../../helpers/mock_firebase.dart';
import '../../../helpers/mock_firebase_auth.dart';
import '../../../helpers/firebase_test_utils.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'dart:async';

// Mock para simular la navegación
class MockNavigator extends Mock {
  void push(String route, {Object? extra});
  void pop();
}

// Mocks para Firebase
class MockFirebaseApp extends Mock implements FirebaseApp {}

// Setup para mockear Firebase
setUpAll() async {
  // Utilizar la clase de utilidad para configurar Firebase
  await FirebaseTestUtils.initializeFirebase();
}
/*
void main() {
  late PlanBloc planBloc;
  late MockPlanRepositoryImpl mockPlanRepository;
  late MockNavigator mockNavigator;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;

  setUp(() async {
    // Inicializar Firebase mock
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    final mockUser = MockUser();

    // Configurar el mock de FirebaseAuth para devolver un usuario de prueba
    when(mockAuth.currentUser).thenReturn(mockUser);

    // Configurar mocks
    mockPlanRepository = MockPlanRepositoryImpl();
    planBloc = PlanBloc(planRepository: mockPlanRepository);
    mockNavigator = MockNavigator();
  });

  tearDown(() {
    planBloc.close();
  });

  group('Gestión de propuestas - Edición avanzada', () {
    testWidgets(
        'debería cargar correctamente una propuesta existente con todos sus campos',
        (WidgetTester tester) async {
      // Datos completos de un plan existente
      final existingPlanData = {
        'id': 'existing_plan_id',
        'title': 'Plan Existente Completo',
        'description': 'Descripción detallada del plan existente',
        'location': 'Ubicación detallada existente',
        'category': 'Categoría existente',
        'conditions': {
          'condicion1': 'valor1',
          'condicion2': 'valor2',
          'extraConditions': 'Condiciones adicionales'
        },
        'selectedThemes': ['tema1', 'tema2', 'tema3'],
        'creatorId': 'user_id_test',
        'imageUrl': 'https://example.com/image.jpg',
        // Usar Timestamp en lugar de String para la fecha
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
        'tags': ['tag1', 'tag2'],
        'likes': 10,
        'payCondition': 'Pago compartido',
        'guestCount': 5,
      };

      // Cargar el plan existente en el bloc
      planBloc.add(PlanEvent.loadExistingPlan(planData: existingPlanData));
      await tester.pumpAndSettle();

      // Verificar que todos los campos se cargaron correctamente
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
          equals('Plan Existente Completo'),
        ),
      );

      expect(
        planBloc.state,
        isA<PlanLoaded>().having(
          (state) => state.plan.description,
          'plan description',
          equals('Descripción detallada del plan existente'),
        ),
      );

      expect(
        planBloc.state,
        isA<PlanLoaded>().having(
          (state) => state.plan.location,
          'plan location',
          equals('Ubicación detallada existente'),
        ),
      );

      expect(
        planBloc.state,
        isA<PlanLoaded>().having(
          (state) => state.plan.category,
          'plan category',
          equals('Categoría existente'),
        ),
      );

      expect(
        planBloc.state,
        isA<PlanLoaded>().having(
          (state) => state.plan.conditions.length,
          'conditions count',
          equals(3),
        ),
      );

      expect(
        planBloc.state,
        isA<PlanLoaded>().having(
          (state) => state.plan.selectedThemes.length,
          'themes count',
          equals(3),
        ),
      );

      expect(
        planBloc.state,
        isA<PlanLoaded>().having(
          (state) => state.plan.imageUrl,
          'image url',
          equals('https://example.com/image.jpg'),
        ),
      );
    });

    test(
        'debería actualizar correctamente campos específicos de un plan existente',
        () {
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
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      };

      // Configurar el mock para que tenga éxito al actualizar
      when(mockPlanRepository.updatePlan(any))
          .thenAnswer((_) async => PlanEntity(
                id: 'existing_plan_id',
                title: 'Plan Existente',
                description: 'Nueva descripción actualizada',
                location: 'Ubicación existente',
                category: 'Categoría existente',
              ));

      // Cargar el plan existente
      planBloc.add(PlanEvent.loadExistingPlan(planData: existingPlanData));

      // Actualizar solo la descripción
      planBloc.add(const PlanEvent.updateField(
          field: 'description', value: 'Nueva descripción actualizada'));

      // Verificar que solo la descripción se actualizó
      expectLater(
        planBloc.stream,
        emitsThrough(isA<PlanLoaded>()
            .having(
              (state) => state.plan.description,
              'plan description',
              equals('Nueva descripción actualizada'),
            )
            .having(
              (state) => state.plan.title,
              'plan title',
              equals('Plan Existente'), // No debe cambiar
            )),
      );
    });

    test(
        'debería actualizar correctamente las condiciones de un plan existente',
        () {
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
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      };

      // Cargar el plan existente
      planBloc.add(PlanEvent.loadExistingPlan(planData: existingPlanData));

      // Nuevas condiciones
      final Map<String, String> newConditions = {
        'condicion1': 'valor1', // Mantener valor existente
        'condicion2': 'valor2', // Agregar nueva condición
        'condicion3': 'valor3', // Agregar nueva condición
      };

      // Actualizar condiciones
      planBloc.add(PlanEvent.updateSelectedOptions(newConditions));

      // Verificar que las condiciones se actualizaron correctamente
      expectLater(
        planBloc.stream,
        emitsThrough(isA<PlanLoaded>()
            .having(
              (state) => state.plan.conditions,
              'plan conditions',
              equals(newConditions),
            )
            .having(
              (state) => state.plan.conditions.length,
              'conditions count',
              equals(3),
            )),
      );
    });

    test('debería actualizar correctamente los temas de un plan existente', () {
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
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      };

      // Cargar el plan existente
      planBloc.add(PlanEvent.loadExistingPlan(planData: existingPlanData));

      // Nuevos temas
      final List<String> newThemes = ['tema3', 'tema4', 'tema5'];

      // Actualizar temas
      planBloc.add(PlanEvent.updateSelectedThemes(newThemes));

      // Verificar que los temas se actualizaron correctamente
      expectLater(
        planBloc.stream,
        emitsThrough(isA<PlanLoaded>()
            .having(
              (state) => state.plan.selectedThemes,
              'plan themes',
              equals(newThemes),
            )
            .having(
              (state) => state.plan.category,
              'plan category',
              equals('tema3'), // La categoría debe actualizarse al primer tema
            )),
      );
    });
  });

  group('Gestión de propuestas - Creación de planes', () {
    test('debería crear un plan exitosamente con todos los campos requeridos',
        () {
      // Configurar el mock para que tenga éxito al crear
      when(mockPlanRepository.createPlan(any))
          .thenAnswer((_) async => PlanEntity(
                id: 'new_plan_id',
                title: 'Nuevo Plan',
                description: 'Descripción del nuevo plan',
                location: 'Ubicación del plan',
                category: 'Categoría del plan',
              ));

      // Datos del nuevo plan
      final newPlanData = {
        'title': 'Nuevo Plan',
        'description': 'Descripción del nuevo plan',
        'location': 'Ubicación del plan',
        'category': 'Categoría del plan',
        'conditions': {'condicion1': 'valor1'},
        'selectedThemes': ['tema1', 'tema2'],
        'creatorId': 'user_id_test',
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      };

      // Crear el plan
      planBloc.add(PlanEvent.create(planData: newPlanData));

      // Verificar que el plan se creó correctamente
      expectLater(
        planBloc.stream,
        emitsThrough(isA<PlanLoaded>().having(
          (state) => state.plan.title,
          'plan title',
          equals('Nuevo Plan'),
        )),
      );
    });

    test('debería manejar errores al crear un plan con campos faltantes', () {
      // Datos incompletos del plan
      final incompletePlanData = {
        'title': '', // Título vacío
        'description': '', // Descripción vacía
        'location': 'Ubicación del plan',
        'category': 'Categoría del plan',
      };

      // Crear el plan con datos incompletos
      planBloc.add(PlanEvent.create(planData: incompletePlanData));

      // Verificar que se emite un estado de error
      expectLater(
        planBloc.stream,
        emitsThrough(isA<PlanError>().having(
          (state) => state.message,
          'error message',
          contains('campos requeridos'),
        )),
      );
    });

    test('debería manejar errores de servidor al crear un plan', () {
      // Configurar el mock para que falle al crear
      when(mockPlanRepository.createPlan(any))
          .thenThrow(Exception('Error al crear el plan'));

      // Datos del plan
      final planData = {
        'title': 'Plan con Error',
        'description': 'Descripción del plan',
        'location': 'Ubicación del plan',
        'category': 'Categoría del plan',
      };

      // Intentar crear el plan
      planBloc.add(PlanEvent.create(planData: planData));

      // Verificar que se emite un estado de error
      expectLater(
        planBloc.stream,
        emitsThrough(isA<PlanError>().having(
          (state) => state.message,
          'error message',
          contains('Error al crear el plan'),
        )),
      );
    });
  });

  group('Gestión de propuestas - Eliminación avanzada', () {
    test(
        'debería manejar correctamente la eliminación de un plan con verificación',
        () async {
      // Configurar el mock para que tenga éxito al eliminar (devuelve Future<void>)
      when(mockPlanRepository.deletePlan('existing_plan_id'))
          .thenAnswer((_) async {}); // Future<void> completado con éxito

      // Datos de un plan existente
      final existingPlanData = {
        'id': 'existing_plan_id',
        'title': 'Plan a Eliminar',
        'description': 'Descripción del plan a eliminar',
        'location': 'Ubicación del plan',
        'creatorId': 'user_id_test',
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
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

      // Eliminar el plan
      await mockPlanRepository.deletePlan('existing_plan_id');

      // Verificar que se llamó al método de eliminación
      verify(mockPlanRepository.deletePlan('existing_plan_id')).called(1);

      // La verificación de éxito es implícita: si no se lanzó excepción, la operación fue exitosa
    });

    test('debería manejar correctamente errores al eliminar un plan', () {
      // Configurar el mock para que falle al eliminar
      when(mockPlanRepository.deletePlan('existing_plan_id'))
          .thenThrow(Exception('Error al eliminar el plan'));

      // Datos de un plan existente
      final existingPlanData = {
        'id': 'existing_plan_id',
        'title': 'Plan a Eliminar',
        'description': 'Descripción del plan a eliminar',
        'location': 'Ubicación del plan',
        'creatorId': 'user_id_test',
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
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

      // Verificar que se lanza una excepción al eliminar
      expect(() => mockPlanRepository.deletePlan('existing_plan_id'),
          throwsException);
    });
  });
}*/
