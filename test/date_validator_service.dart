// test/services/date_validator_service_test.dart
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import 'date_validator_service_test.dart';

void main() {
  group('DateValidatorService', () {
    test('isWorkday should return false for weekends', () {
      final DateTime saturday = DateTime(2024, 2, 17); // Un sábado
      final DateTime sunday = DateTime(2024, 2, 18); // Un domingo

      expect(DateValidatorService.isWorkday(saturday), false);
      expect(DateValidatorService.isWorkday(sunday), false);
    });

    test('isWorkday should return true for regular weekdays', () {
      final DateTime monday = DateTime(2024, 2, 19);
      expect(DateValidatorService.isWorkday(monday), true);
    });

    test('isValidTime should validate city hours correctly', () {
      const TimeOfDay validTime = TimeOfDay(hour: 14, minute: 0);
      const TimeOfDay invalidTime = TimeOfDay(hour: 23, minute: 30);

      expect(
          DateValidatorService.isValidTime(
              'Ciudad Autónoma de Buenos Aires', validTime),
          true);

      expect(
          DateValidatorService.isValidTime(
              'Ciudad Autónoma de Buenos Aires', invalidTime),
          false);
    });

    test('validateDateTime should return success for valid dates', () {
      final DateTime validDate =
          DateTime(2024, 2, 19, 14, 0); // Lunes a las 14:00
      const TimeOfDay validTime = TimeOfDay(hour: 14, minute: 0);

      final ValidationResult result = DateValidatorService.validateDateTime(
          validDate, validTime, 'Ciudad Autónoma de Buenos Aires');

      expect(result.isValid, true);
      expect(result.message, 'Fecha y hora válidas');
      expect(result.errorMessage, null);
    });

    test('validateDateTime should return error for past dates', () {
      final DateTime pastDate =
          DateTime.now().subtract(const Duration(days: 1));
      const TimeOfDay validTime = TimeOfDay(hour: 14, minute: 0);

      final ValidationResult result = DateValidatorService.validateDateTime(
          pastDate, validTime, 'Ciudad Autónoma de Buenos Aires');

      expect(result.isValid, false);
      expect(result.message, null);
      expect(result.errorMessage, 'La fecha seleccionada ya pasó');
    });
  });
}
