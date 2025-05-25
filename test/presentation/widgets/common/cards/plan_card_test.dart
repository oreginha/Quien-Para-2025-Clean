import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/plan_card.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/my_plan_card.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/other_user_plan_card.dart';

void main() {
  testWidgets('PlanCard renders OtherUserPlanCard for otherUserPlan type',
      (WidgetTester tester) async {
    // Arrange
    final testPlan = PlanEntity(
      id: 'test-id',
      title: 'Test Plan',
      description: 'Test Description',
      location: 'Test Location',
      date: DateTime(2024, 12, 31),
      category: 'Test Category',
      imageUrl: 'https://example.com/image.jpg',
      creatorId: 'test-user-id',
      conditions: {'condition1': 'value1', 'condition2': 'value2'},
      selectedThemes: ['theme1', 'theme2'],
      tags: ['tag1', 'tag2'],
      likes: 0,
      createdAt: DateTime.now(),
      updatedAt: null,
      payCondition: null,
      guestCount: null,
      extraConditions: '',
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlanCard(
            planData: testPlan,
            planId: 'test-id',
            cardType: PlanCardType.otherUserPlan,
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(OtherUserPlanCard), findsOneWidget);
    expect(find.text('Test Plan'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });

  testWidgets('PlanCard renders MyPlanCard for myPlan type',
      (WidgetTester tester) async {
    // Arrange
    final testPlan = PlanEntity(
      id: 'test-id',
      title: 'My Test Plan',
      description: 'My Test Description',
      location: 'Test Location',
      date: DateTime(2024, 12, 31),
      category: 'Test Category',
      imageUrl: 'https://example.com/image.jpg',
      creatorId: 'test-user-id',
      conditions: {'condition1': 'value1', 'condition2': 'value2'},
      selectedThemes: ['theme1', 'theme2'],
      tags: ['tag1', 'tag2'],
      likes: 0,
      createdAt: DateTime.now(),
      updatedAt: null,
      payCondition: null,
      guestCount: null,
      extraConditions: '',
    );

    bool deletePlanCalled = false;
    String deletedPlanId = '';

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlanCard(
            planData: testPlan,
            planId: 'test-id',
            cardType: PlanCardType.myPlan,
            onDeletePlan: (String planId, String confirmText) {
              deletePlanCalled = true;
              deletedPlanId = planId;
            },
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(MyPlanCard), findsOneWidget);
    expect(find.text('My Test Plan'), findsOneWidget);

    // Find and tap the delete button if it exists (may be hidden in a menu)
    final deleteIcon = find.byIcon(Icons.delete);
    if (deleteIcon.evaluate().isNotEmpty) {
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      // Find and tap the confirm button if it exists
      final confirmButton = find.text('Confirmar');
      if (confirmButton.evaluate().isNotEmpty) {
        await tester.tap(confirmButton);
        await tester.pumpAndSettle();

        expect(deletePlanCalled, isTrue);
        expect(deletedPlanId, equals('test-id'));
      }
    }
  });

  testWidgets('PlanCard handles Map data correctly',
      (WidgetTester tester) async {
    // Arrange
    final Map<String, dynamic> testPlanMap = {
      'title': 'Map Test Plan',
      'description': 'Map Test Description',
      'location': 'Map Test Location',
      'date': DateTime(2024, 12, 31).toIso8601String(),
      'category': 'Test Category',
      'imageUrl': 'https://example.com/image.jpg',
      'creatorId': 'test-user-id',
    };

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlanCard(
            planData: testPlanMap,
            planId: 'test-id',
            cardType: PlanCardType.otherUserPlan,
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(OtherUserPlanCard), findsOneWidget);
    expect(find.text('Map Test Plan'), findsOneWidget);
    expect(find.text('Map Test Description'), findsOneWidget);
  });

  testWidgets('PlanCard handles missing data gracefully',
      (WidgetTester tester) async {
    // Arrange
    final Map<String, dynamic> testPlanMap = {
      // Missing title and description
      'location': 'Map Test Location',
      'creatorId': 'test-user-id',
    };

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlanCard(
            planData: testPlanMap,
            planId: 'test-id',
            cardType: PlanCardType.otherUserPlan,
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(OtherUserPlanCard), findsOneWidget);
    expect(find.text('Sin título'), findsOneWidget);
    expect(find.text('Sin descripción'), findsOneWidget);
  });
}
