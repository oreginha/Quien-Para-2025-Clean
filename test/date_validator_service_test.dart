// lib/services/date_validator_service.dart
import 'package:flutter/material.dart';

class ValidationResult {
  final bool isValid;
  final String? message; // Hacemos message opcional
  final String? errorMessage; // Agregamos errorMessage para manejar errores

  ValidationResult({required this.isValid, this.message, this.errorMessage});

  // Constructor factory para crear resultados exitosos
  factory ValidationResult.success([final String? message]) {
    return ValidationResult(isValid: true, message: message);
  }

  // Constructor factory para crear resultados de error
  factory ValidationResult.error(final String errorMessage) {
    return ValidationResult(isValid: false, errorMessage: errorMessage);
  }
}

class DateValidatorService {
  // Lista de días festivos para Argentina en 2024-2025
  static final List<DateTime> _holidays = <DateTime>[
    DateTime(2024, 1, 1), // Año Nuevo
    DateTime(2024, 2, 12), // Carnaval
    DateTime(2024, 2, 13), // Carnaval
    DateTime(2024, 3, 24), // Día Nacional de la Memoria
    DateTime(2024, 4, 2), // Malvinas
    // ... Agregar más fechas según necesidad
  ];

  // Horarios por ciudad
  static final Map<String, Map<String, TimeOfDay>> _cityHours =
      <String, Map<String, TimeOfDay>>{
    'Ciudad Autónoma de Buenos Aires': <String, TimeOfDay>{
      'start': const TimeOfDay(hour: 8, minute: 0),
      'end': const TimeOfDay(hour: 23, minute: 0),
    },
    'La Plata': <String, TimeOfDay>{
      'start': const TimeOfDay(hour: 8, minute: 0),
      'end': const TimeOfDay(hour: 22, minute: 0),
    },
    'Rosario': <String, TimeOfDay>{
      'start': const TimeOfDay(hour: 8, minute: 0),
      'end': const TimeOfDay(hour: 22, minute: 0),
    },
    'Córdoba': <String, TimeOfDay>{
      'start': const TimeOfDay(hour: 8, minute: 0),
      'end': const TimeOfDay(hour: 22, minute: 0),
    },
  };

  // Validar si es día laboral
  static bool isWorkday(final DateTime date) {
    // Los fines de semana no son días laborales
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return false;
    }

    // Verificar si es feriado
    return !_holidays.any(
      (final DateTime holiday) =>
          holiday.year == date.year &&
          holiday.month == date.month &&
          holiday.day == date.day,
    );
  }

  // Validar horario según la ciudad
  static bool isValidTime(final String city, final TimeOfDay time) {
    final Map<String, TimeOfDay>? citySchedule = _cityHours[city];
    if (citySchedule == null) return false;

    final TimeOfDay start = citySchedule['start']!;
    final TimeOfDay end = citySchedule['end']!;

    // Convertir a minutos para comparación más fácil
    final int timeInMinutes = time.hour * 60 + time.minute;
    final int startInMinutes = start.hour * 60 + start.minute;
    final int endInMinutes = end.hour * 60 + end.minute;

    return timeInMinutes >= startInMinutes && timeInMinutes <= endInMinutes;
  }

  // Validar fecha completa (incluyendo hora)
  static ValidationResult validateDateTime(
    final DateTime date,
    final TimeOfDay time,
    final String city,
  ) {
    if (!isWorkday(date)) {
      return ValidationResult.error(
        'Esta fecha no está disponible por ser fin de semana o feriado',
      );
    }

    if (!isValidTime(city, time)) {
      // ignore: unnecessary_brace_in_string_interps
      return ValidationResult.error(
        'El horario está fuera del rango permitido para $city',
      );
    }

    // Validar que la fecha no sea pasada
    if (date.isBefore(DateTime.now())) {
      return ValidationResult.error('La fecha seleccionada ya pasó');
    }

    return ValidationResult.success('Fecha y hora válidas');
  }
}
