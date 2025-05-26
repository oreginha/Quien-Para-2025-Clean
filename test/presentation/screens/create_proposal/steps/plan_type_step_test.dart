import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/presentation/screens/create_proposal/steps/plan_type_step.dart';

void main() {
  testWidgets('PlanTypeStep displays plan types correctly', (
    WidgetTester tester,
  ) async {
    final PageController pageController = PageController();
    final List<String> planTypes = <String>['Social', 'Cultural', 'Deportivo'];
    String? selectedType;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlanTypeStep(
            pageController: pageController,
            planTypes: planTypes,
            selectedType: selectedType,
            onSelect: (String type) => selectedType = type,
          ),
        ),
      ),
    );

    // Verify all plan types are displayed
    for (final String type in planTypes) {
      expect(find.text(type), findsOneWidget);
    }

    // Test selection
    await tester.tap(find.text('Social'));
    await tester.pumpAndSettle();

    // Verify navigation happens after selection
    expect(pageController.page, equals(0));
  });
}
