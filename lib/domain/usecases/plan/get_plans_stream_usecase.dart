// lib/domain/usecases/plan/get_plans_stream_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';
import 'package:quien_para/presentation/widgets/errors/failures.dart';

/// Parámetros para obtener un stream de planes.
class GetPlansStreamParams {
  final Map<String, dynamic>? filters;

  const GetPlansStreamParams({
    this.filters,
  });
}

/// Caso de uso para obtener un stream de planes
///
/// Este caso de uso implementa la interfaz StreamUseCaseInterface y utiliza el repositorio
/// de planes para obtener un stream de planes con opciones de filtrado.
class GetPlansStreamUseCase
    implements StreamUseCaseInterface<List<PlanEntity>, GetPlansStreamParams> {
  final PlanRepository _planRepository;
  final Logger _logger = Logger();

  GetPlansStreamUseCase(this._planRepository);

  @override
  Stream<Either<AppFailure, List<PlanEntity>>> execute(
      GetPlansStreamParams params) {
    _logger.d('GetPlansStreamUseCase: Obteniendo stream de planes');

    // Obtener stream del repositorio
    final stream = _planRepository.getStream(filters: params.filters);

    // Si no hay stream disponible, devolver un stream con error
    if (stream == null) {
      _logger.e('GetPlansStreamUseCase: Stream no disponible');
      return Stream.value(Left(
        ServerFailure('Stream no disponible',
            originalError: 'No stream available') as AppFailure,
      ));
    }

    return stream;
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Stream<Either<AppFailure, List<PlanEntity>>> call(
          GetPlansStreamParams params) =>
      execute(params);

  /// Método de conveniencia para obtener un stream de todos los planes
  Stream<Either<AppFailure, List<PlanEntity>>> getAllPlansStream() {
    return execute(const GetPlansStreamParams());
  }

  /// Método de conveniencia para obtener un stream de planes por categoría
  Stream<Either<AppFailure, List<PlanEntity>>> getPlansByCategoryStream(
      String category) {
    return execute(GetPlansStreamParams(
      filters: {'category': category},
    ));
  }

  /// Método de conveniencia para obtener un stream de planes de otros usuarios
  Stream<Either<AppFailure, List<PlanEntity>>> getOtherUsersPlansStream(
      String currentUserId,
      {int? limit}) {
    return execute(GetPlansStreamParams(
      filters: {
        'currentUserId': currentUserId,
        if (limit != null) 'limit': limit,
      },
    ));
  }
}
