// lib/domain/usecases/plan/get_plans_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

/// Parámetros para obtener planes.
class GetPlansParams {
  final int? limit;
  final String? lastDocumentId;
  final String? category;
  final Map<String, dynamic>? filters;

  const GetPlansParams({
    this.limit,
    this.lastDocumentId,
    this.category,
    this.filters,
  });
}

/// Caso de uso para obtener una lista de planes
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de planes para obtener todos los planes con opciones de filtrado y paginación.
class GetPlansUseCase
    implements UseCaseInterface<List<PlanEntity>, GetPlansParams> {
  final PlanRepository _planRepository;
  final Logger _logger = Logger();

  GetPlansUseCase(this._planRepository);

  @override
  Future<Either<AppFailure, List<PlanEntity>>> execute(
    GetPlansParams params,
  ) async {
    _logger.d('GetPlansUseCase: Obteniendo planes');

    // Validar parámetros
    if (params.limit != null && params.limit! <= 0) {
      _logger.w('GetPlansUseCase: Límite inválido: ${params.limit}');
      return Left(
        ValidationFailure(
          message: 'El límite debe ser un número positivo',
          field: 'limit',
          code: '',
        ),
      );
    }

    // Construir filtros combinados
    final Map<String, dynamic> combinedFilters = params.filters ?? {};
    if (params.category != null) {
      combinedFilters['category'] = params.category;
    }

    // Delegar al repositorio
    return _planRepository.getAll(
      limit: params.limit,
      lastDocumentId: params.lastDocumentId,
      filters: combinedFilters.isNotEmpty ? combinedFilters : null,
    );
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, List<PlanEntity>>> call(GetPlansParams params) =>
      execute(params);

  /// Método de conveniencia para obtener planes sin filtros
  Future<Either<AppFailure, List<PlanEntity>>> getAllPlans({int? limit}) {
    return execute(GetPlansParams(limit: limit));
  }

  /// Método de conveniencia para obtener planes por categoría
  Future<Either<AppFailure, List<PlanEntity>>> getPlansByCategory(
    String category, {
    int? limit,
  }) {
    return execute(GetPlansParams(category: category, limit: limit));
  }
}
