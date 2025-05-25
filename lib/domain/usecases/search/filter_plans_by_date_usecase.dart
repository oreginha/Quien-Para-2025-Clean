// lib/domain/usecases/search/filter_plans_by_date_usecase.dart

import 'package:dartz/dartz.dart';
import '../../entities/failure.dart';
import '../../entities/plan/plan_with_creator_entity.dart';
import '../../repositories/plan/plan_repository.dart';

/// Caso de uso para filtrar planes por rango de fechas
///
/// Permite filtrar planes que ocurren dentro de un período específico
class FilterPlansByDateUseCase {
  final PlanRepository repository;

  const FilterPlansByDateUseCase(this.repository);

  /// Filtra planes por rango de fechas
  ///
  /// [startDate] - Fecha de inicio del rango
  /// [endDate] - Fecha de fin del rango
  /// [limit] - Límite de resultados (por defecto 20)
  /// [lastDocumentId] - Para paginación (opcional)
  ///
  /// Retorna planes que ocurren dentro del rango especificado
  Future<Either<Failure, List<PlanWithCreatorEntity>>> execute({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      // Validar parámetros
      if (startDate.isAfter(endDate)) {
        return const Left(ValidationFailure(
            'La fecha de inicio no puede ser posterior a la fecha de fin'));
      }

      final now = DateTime.now();
      if (endDate.isBefore(now.subtract(const Duration(days: 1)))) {
        return const Left(
            ValidationFailure('No se pueden buscar planes que ya han pasado'));
      }

      // Verificar que el rango no sea demasiado amplio (máximo 1 año)
      final difference = endDate.difference(startDate);
      if (difference.inDays > 365) {
        return const Left(
            ValidationFailure('El rango de fechas no puede ser mayor a 1 año'));
      }

      // Ejecutar filtro por fechas
      final result = await repository.filterPlansByDateRange(
        startDate: startDate,
        endDate: endDate,
        limit: limit,
        lastDocumentId: lastDocumentId,
      );

      return result;
    } catch (e) {
      return Left(
          ServerFailure(null, 'Error al filtrar por fechas: ${e.toString()}'));
    }
  }

  /// Filtra planes para hoy
  Future<Either<Failure, List<PlanWithCreatorEntity>>> getPlansForToday({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return execute(
      startDate: startOfDay,
      endDate: endOfDay,
      limit: limit,
      lastDocumentId: lastDocumentId,
    );
  }

  /// Filtra planes para esta semana
  Future<Either<Failure, List<PlanWithCreatorEntity>>> getPlansForThisWeek({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek
        .add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    return execute(
      startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      endDate: endOfWeek,
      limit: limit,
      lastDocumentId: lastDocumentId,
    );
  }

  /// Filtra planes para este mes
  Future<Either<Failure, List<PlanWithCreatorEntity>>> getPlansForThisMonth({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return execute(
      startDate: startOfMonth,
      endDate: endOfMonth,
      limit: limit,
      lastDocumentId: lastDocumentId,
    );
  }

  /// Filtra planes para el próximo fin de semana
  Future<Either<Failure, List<PlanWithCreatorEntity>>> getPlansForWeekend({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    final now = DateTime.now();

    // Encontrar el próximo sábado
    int daysUntilSaturday = (DateTime.saturday - now.weekday) % 7;
    if (daysUntilSaturday == 0 && now.weekday == DateTime.saturday) {
      // Si hoy es sábado, usar este fin de semana
      daysUntilSaturday = 0;
    } else if (daysUntilSaturday == 0) {
      // Si es domingo, usar el próximo fin de semana
      daysUntilSaturday = 6;
    }

    final saturday = now.add(Duration(days: daysUntilSaturday));
    final sunday = saturday.add(const Duration(days: 1));

    final startOfSaturday =
        DateTime(saturday.year, saturday.month, saturday.day);
    final endOfSunday =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    return execute(
      startDate: startOfSaturday,
      endDate: endOfSunday,
      limit: limit,
      lastDocumentId: lastDocumentId,
    );
  }
}
