// lib/domain/usecases/application/get_user_applications_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../failures/app_failures.dart';
import '../../entities/application/application_entity.dart';
import '../../interfaces/application_repository_interface.dart';

/// Caso de uso para obtener las aplicaciones de un usuario
class GetUserApplicationsUseCase {
  final ApplicationRepositoryInterface _repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GetUserApplicationsUseCase(this._repository);

  /// Obtiene todas las aplicaciones hechas por un usuario específico
  Future<Either<AppFailure, List<ApplicationEntity>>> call(
      String userId) async {
    return await _repository.getUserApplications(userId);
  }

  /// Obtiene el ID del usuario actual o utiliza el ID proporcionado
  /// Si userId es null, obtiene el ID del usuario autenticado
  Future<String> getCurrentUserId(String? userId) async {
    if (userId != null && userId.isNotEmpty) {
      return userId;
    }

    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    }

    throw Exception('Usuario no autenticado');
  }
}
