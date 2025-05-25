// lib/domain/usecases/plan/get_other_users_plans_usecase.dart

import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';

/// Caso de uso para obtener planes creados por otros usuarios
class GetOtherUserPlansUseCase {
  final PlanRepository _planRepository;

  GetOtherUserPlansUseCase(this._planRepository);

  /// Obtiene un stream de planes creados por otros usuarios (no por el usuario actual)
  ///
  /// Este método devuelve un stream para que la UI pueda reaccionar automáticamente
  /// a cambios en los planes disponibles.
  ///
  /// Parámetros:
  /// - currentUserId: ID del usuario actual cuyos planes serán excluidos
  /// - limit: número máximo de planes a recuperar (por defecto: 20)
  Stream<Either<AppFailure, List<PlanEntity>>> execute(
      {required String currentUserId, int limit = 20}) {
    try {
      if (kDebugMode) {
        print(
            'GetOtherUserPlansUseCase: Obteniendo planes de otros usuarios, ID de usuario actual: $currentUserId');
      }

      return _planRepository.getOtherUserPlansStream(
          currentUserId: currentUserId, limit: limit);
    } catch (e) {
      if (kDebugMode) {
        print('GetOtherUserPlansUseCase: Error al obtener planes: $e');
      }

      // En caso de error, retornamos un stream con Either.left
      return Stream.value(Left(AppFailure(
        message: 'Error al obtener planes: $e',
        code: 'GET_OTHER_USERS_PLANS_ERROR',
      )));
    }
  }

  /// Fuerza una actualización de los planes almacenados en caché
  Future<void> refreshPlans(String currentUserId) async {
    try {
      if (kDebugMode) {
        print('GetOtherUserPlansUseCase: Refrescando planes de otros usuarios');
      }

      await _planRepository.refreshOtherUserPlans(currentUserId: currentUserId);

      if (kDebugMode) {
        print('GetOtherUserPlansUseCase: Planes refrescados correctamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('GetOtherUserPlansUseCase: Error al refrescar planes: $e');
      }
      rethrow;
    }
  }
}
