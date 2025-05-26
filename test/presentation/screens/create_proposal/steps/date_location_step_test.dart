// ignore_for_file: inference_failure_on_function_return_type, unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/presentation/screens/create_proposal/steps/date_location_step.dart';

void main() {
  testWidgets('DateLocationStep handles date and location selection', (
    final WidgetTester tester,
  ) async {
    final PageController pageController = PageController();
    DateTime? selectedDate;
    String? selectedCity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DateLocationStep(
            pageController: pageController,
            selectedCity: selectedCity,
            onDateSelect: (final DateTime date) => selectedDate = date,
            onCitySelect: (final String city) => selectedCity = city,
            onNext: () {},
          ),
        ),
      ),
    );

    // Verify date picker is present
    expect(
      find.byType(CalendarDatePicker) as Function(dynamic ElevatedButton),
      findsOneWidget,
    );

    // Verify city selection is present
    expect(
      find.byType(DropdownButton<String>) as Function(dynamic ElevatedButton),
      findsOneWidget,
    );

    // Test date selection
    final DateTime testDate = DateTime.now();
    await tester.tap(find.byType(CalendarDatePicker));
    await tester.pumpAndSettle();

    // Test city selection
    final String testCity = 'Test City';
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
  });
}

// Test next button is disabled when no selections are made
