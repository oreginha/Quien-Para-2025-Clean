// lib/domain/usecases/plan/search_plans_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

/// Parámetros para búsqueda de planes
class SearchPlansParams {
  final Map<String, dynamic> criteria;
  final int? limit;
  final String? lastDocumentId;

  const SearchPlansParams({
    required this.criteria,
    this.limit,
    this.lastDocumentId,
  });

  /// Constructor para búsqueda por texto
  factory SearchPlansParams.byText(
    String searchText, {
    int? limit,
    String? lastDocumentId,
  }) {
    return SearchPlansParams(
      criteria: {'searchText': searchText},
      limit: limit,
      lastDocumentId: lastDocumentId,
    );
  }

  /// Constructor para búsqueda por categoría
  factory SearchPlansParams.byCategory(
    String category, {
    int? limit,
    String? lastDocumentId,
  }) {
    return SearchPlansParams(
      criteria: {'category': category},
      limit: limit,
      lastDocumentId: lastDocumentId,
    );
  }

  /// Constructor para búsqueda por creador
  factory SearchPlansParams.byCreator(
    String creatorId, {
    int? limit,
    String? lastDocumentId,
  }) {
    return SearchPlansParams(
      criteria: {'creatorId': creatorId},
      limit: limit,
      lastDocumentId: lastDocumentId,
    );
  }

  /// Constructor para búsqueda por fecha
  factory SearchPlansParams.byDateRange(
    DateTime minDate,
    DateTime maxDate, {
    int? limit,
    String? lastDocumentId,
  }) {
    return SearchPlansParams(
      criteria: {'minDate': minDate, 'maxDate': maxDate},
      limit: limit,
      lastDocumentId: lastDocumentId,
    );
  }
}

/// Caso de uso para buscar planes según criterios específicos
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de planes para buscar planes según criterios específicos.
class SearchPlansUseCase
    implements UseCaseInterface<List<PlanEntity>, SearchPlansParams> {
  final PlanRepository _planRepository;
  final Logger _logger = Logger();

  SearchPlansUseCase(this._planRepository);

  @override
  Future<Either<AppFailure, List<PlanEntity>>> execute(
    SearchPlansParams params,
  ) async {
    _logger.d(
      'SearchPlansUseCase: Buscando planes con criterios: ${params.criteria}',
    );

    // Validar parámetros
    if (params.criteria.isEmpty) {
      _logger.w('SearchPlansUseCase: Criterios de búsqueda vacíos');
      return Left(
        ValidationFailure(
          message: 'Los criterios de búsqueda no pueden estar vacíos',
          code: '',
          field: '',
        ),
      );
    }

    // Delegar al repositorio
    return _planRepository.search(
      params.criteria,
      limit: params.limit,
      lastDocumentId: params.lastDocumentId,
    );
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, List<PlanEntity>>> call(SearchPlansParams params) =>
      execute(params);

  /// Método de conveniencia para buscar planes por texto
  Future<Either<AppFailure, List<PlanEntity>>> searchByText(
    String searchText, {
    int? limit,
    String? lastDocumentId,
  }) {
    return execute(
      SearchPlansParams.byText(
        searchText,
        limit: limit,
        lastDocumentId: lastDocumentId,
      ),
    );
  }

  /// Método de conveniencia para buscar planes por categoría
  Future<Either<AppFailure, List<PlanEntity>>> searchByCategory(
    String category, {
    int? limit,
    String? lastDocumentId,
  }) {
    return execute(
      SearchPlansParams.byCategory(
        category,
        limit: limit,
        lastDocumentId: lastDocumentId,
      ),
    );
  }
}
