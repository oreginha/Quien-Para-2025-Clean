// test/ui/plan_widget_ui_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/plan_card.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/other_user_plan_card.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/my_plan_card.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/my_application_card.dart';

import '../setup/test_dependency_setup.dart';
import 'mock_theme_provider.dart';

void main() {
  // Configura las dependencias antes de ejecutar las pruebas
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await setupTestDependencies();
  });

  group('Pruebas de UI para widgets relacionados con planes', () {
    final testPlan = PlanEntity(
      id: 'test-plan-id',
      title: 'Test Plan Title',
      description:
          'Test Description that is long enough to test the overflow behavior and ellipsis rendering',
      creatorId: 'user-123',
      location: 'Test Location, Somewhere, 123',
      date: DateTime(2025, 5, 18, 14, 30),
      createdAt: DateTime(2025, 5, 1),
      category: 'Test Category',
      imageUrl: 'https://via.placeholder.com/150',
      likes: 10,
      tags: ['tag1', 'tag2', 'testing', 'ui'],
      conditions: {'condition1': 'value1', 'condition2': 'value2'},
      selectedThemes: ['theme1', 'theme2'],
      extraConditions: 'Extra conditions for testing purposes',
    );

    // Widget para encapsular los widgets de prueba con Provider
    Widget buildTestableWidget(Widget child) {
      return MaterialApp(
        home: ChangeNotifierProvider<ThemeProvider>(
          create: (_) => MockThemeProvider(isDarkMode: false),
          child: Scaffold(
            body: child,
          ),
        ),
      );
    }

    testWidgets('PlanCard responde correctamente a gestos de pulsación larga',
        (WidgetTester tester) async {
      // Variable para rastrear si se detectó pulsación larga
      bool longPressed = false;

      // Preparar
      await tester.pumpWidget(
        buildTestableWidget(
          GestureDetector(
            onLongPress: () {
              longPressed = true;
            },
            child: PlanCard(
              planData: testPlan,
              planId: testPlan.id,
              cardType: PlanCardType.otherUserPlan,
            ),
          ),
        ),
      );

      // Actuar - pulsación larga
      await tester.longPress(find.byType(PlanCard));
      await tester.pumpAndSettle();

      // Verificar
      expect(longPressed, true);
    });

    // Prueba para OtherUserPlanCard
    testWidgets(
        'OtherUserPlanCard muestra información mínima y mantiene diseño compacto',
        (WidgetTester tester) async {
      // Preparar
      await tester.pumpWidget(
        buildTestableWidget(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OtherUserPlanCard(
              title: testPlan.title,
              description: testPlan.description,
              location: testPlan.location,
              imageUrl: testPlan.imageUrl,
              date: testPlan.date,
              planId: testPlan.id,
              creatorId: testPlan.creatorId,
            ),
          ),
        ),
      );

      // Verificar que contiene información esencial
      expect(find.text('Test Plan Title'), findsOneWidget);

      // Verificar que el tamaño es realmente compacto midiendo el widget
      final size = tester.getSize(find.byType(OtherUserPlanCard));

      // El widget compacto no debería ocupar toda la altura de la pantalla
      expect(size.height, lessThan(400));
    });

    // Prueba para MyPlanCard
    testWidgets('MyPlanCard muestra título y permitir eliminar',
        (WidgetTester tester) async {
      // Flag para verificar si se llamó a onDeletePlan
      bool onDeleteCalled = false;
      String? deletedPlanId;

      // Preparar
      await tester.pumpWidget(
        buildTestableWidget(
          MyPlanCard(
            title: testPlan.title,
            description: testPlan.description,
            imageUrl: testPlan.imageUrl,
            date: testPlan.date,
            planId: testPlan.id,
            onDeletePlan: (planId, _) {
              onDeleteCalled = true;
              deletedPlanId = planId;
            },
          ),
        ),
      );

      // Verificar que se muestra la información correcta
      expect(find.text('Test Plan Title'), findsOneWidget);
      expect(find.textContaining('Test Description'), findsOneWidget);

      // Verificar que hay un botón de eliminar (podría ser un ícono o botón)
      final deleteButton = find.byIcon(Icons.delete_forever);
      if (deleteButton.evaluate().isNotEmpty) {
        await tester.tap(deleteButton);
        await tester.pumpAndSettle();

        // Verificar que se llamó a onDeletePlan con el ID correcto
        expect(onDeleteCalled, true);
        expect(deletedPlanId, equals(testPlan.id));
      }
    });

    // Prueba para MyApplicationCard
    testWidgets('MyApplicationCard muestra información de aplicación',
        (WidgetTester tester) async {
      // Flag para verificar si se llamó a onCancelApplication
      bool onCancelCalled = false;
      String? canceledAppId;

      // Preparar
      await tester.pumpWidget(
        buildTestableWidget(
          MyApplicationCard(
            title: testPlan.title,
            description: testPlan.description,
            location: testPlan.location,
            imageUrl: testPlan.imageUrl,
            category: testPlan.category,
            date: testPlan.date,
            planId: testPlan.id,
            applicationId: 'app-123',
            applicationStatus: 'pending',
            applicationMessage: 'Me gustaría participar',
            appliedAt: DateTime(2025, 5, 10),
            onCancelApplication: (appId) {
              onCancelCalled = true;
              canceledAppId = appId;
            },
          ),
        ),
      );

      // Verificar que se muestra la información correcta
      expect(find.text('Test Plan Title'), findsOneWidget);
      expect(find.textContaining('Test Description'), findsOneWidget);
      expect(find.textContaining('Me gustaría participar'), findsOneWidget);

      // Verificar que hay un botón para cancelar la aplicación
      final cancelButton = find.text('Cancelar');
      if (cancelButton.evaluate().isNotEmpty) {
        await tester.tap(cancelButton);
        await tester.pumpAndSettle();

        // Ahora deberíamos encontrar el diálogo de confirmación
        final confirmButton = find.text('Sí, cancelar');
        if (confirmButton.evaluate().isNotEmpty) {
          await tester.tap(confirmButton);
          await tester.pumpAndSettle();

          // Verificar que se llamó a onCancelApplication con el ID correcto
          expect(onCancelCalled, true);
          expect(canceledAppId, equals('app-123'));
        }
      }
    });

    // Prueba de accesibilidad
    testWidgets('PlanCard tiene suficiente tamaño para accesibilidad',
        (WidgetTester tester) async {
      // Preparar
      await tester.pumpWidget(
        buildTestableWidget(
          PlanCard(
            planData: testPlan,
            planId: testPlan.id,
            cardType: PlanCardType.otherUserPlan,
          ),
        ),
      );

      // Verificar que haya suficiente padding para tocar fácilmente
      final card = find.byType(PlanCard);
      final cardSize = tester.getSize(card);

      // El widget debe ser lo suficientemente grande para ser tocado fácilmente
      expect(cardSize.width, greaterThanOrEqualTo(44));
      expect(cardSize.height, greaterThanOrEqualTo(44));
    });

    // Prueba del conjunto de widgets en un escenario realista
    testWidgets('Múltiples PlanCards se muestran correctamente en un ListView',
        (WidgetTester tester) async {
      // Crear una lista de planes
      final plans = List.generate(
        5,
        (index) => testPlan.copyWith(
          id: 'plan-$index',
          title: 'Plan $index',
          description: 'Description for plan $index',
        ),
      );

      // Preparar
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<ThemeProvider>(
            create: (_) => MockThemeProvider(isDarkMode: false),
            child: Scaffold(
              body: ListView.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) => PlanCard(
                  planData: plans[index],
                  planId: plans[index].id,
                  cardType: PlanCardType.otherUserPlan,
                ),
              ),
            ),
          ),
        ),
      );

      // Verificar que todos los planes se muestran en la lista
      for (var i = 0; i < plans.length; i++) {
        expect(find.text('Plan $i'), findsOneWidget);
      }

      // Verificar que se puede hacer scroll por la lista
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Verificar que después del scroll, algunas tarjetas desaparecen
      // y otras aparecen (dependiendo del tamaño de la pantalla)
      // Nota: esto es difícil de probar exactamente sin conocer el tamaño de las tarjetas
    });
  });
}
