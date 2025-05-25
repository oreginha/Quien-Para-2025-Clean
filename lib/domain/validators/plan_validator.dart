// lib/domain/validators/plan_validator.dart
import 'package:quien_para/presentation/widgets/errors/app_exceptions.dart';

import '../entities/plan/plan_entity.dart';

class PlanValidator {
  static void validate(final PlanEntity plan) {
    final List<String> errors = <String>[];

    // Validar título
    if (plan.title.isEmpty) {
      errors.add('Title cannot be empty');
    } else if (plan.title.length > 100) {
      errors.add('Title is too long (max 100 characters)');
    }

    // Validar descripción
    if (plan.description.isEmpty) {
      errors.add('Description cannot be empty');
    } else if (plan.description.length > 500) {
      errors.add('Description is too long (max 500 characters)');
    }

    // Validar URL de imagen
    if (plan.imageUrl.isNotEmpty && !_isValidUrl(plan.imageUrl)) {
      errors.add('Invalid image URL format');
    }

    // Validar categoría
    if (plan.category.isEmpty) {
      errors.add('Category cannot be empty');
    }

    // Validar ubicación
    if (plan.location.isEmpty) {
      errors.add('Location cannot be empty');
    }

    // Validar fecha (opcional pero si existe debe ser válida)
    if (plan.date != null) {
      final DateTime now = DateTime.now();
      if (plan.date!.isBefore(now) && !_isSameDay(plan.date!, now)) {
        errors.add('Date cannot be in the past');
      }
    }

    // Si hay errores, lanzar excepción
    if (errors.isNotEmpty) {
      throw ValidationException(
        'Plan validation failed',
        data: errors,
      );
    }
  }

  // Función auxiliar para validar URL
  static bool _isValidUrl(final String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (_) {
      return false;
    }
  }

  // Función auxiliar para comparar solo el día (sin tiempo)
  static bool _isSameDay(final DateTime date1, final DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
