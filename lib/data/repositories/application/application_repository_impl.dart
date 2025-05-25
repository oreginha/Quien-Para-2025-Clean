// lib/data/repositories/application_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import 'package:quien_para/data/mappers/application_mapper.dart';
import 'package:quien_para/domain/entities/application/application_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/interfaces/application_repository_interface.dart';
import 'package:quien_para/domain/repositories/application/application_repository.dart';

/// Implementación mejorada del repositorio de aplicaciones que sigue los principios de Clean Architecture
/// y utiliza Either para un manejo de errores consistente.
class ApplicationRepositoryImpl
    implements ApplicationRepositoryInterface, ApplicationRepository {
  final FirebaseFirestore _firestore;
  final ApplicationMapper _mapper;
  final Logger _logger;

  /// Constructor
  ApplicationRepositoryImpl({
    required FirebaseFirestore firestore,
    required ApplicationMapper mapper,
    Logger? logger,
  })  : _firestore = firestore,
        _mapper = mapper,
        _logger = logger ?? Logger();

  @override
  Future<Either<AppFailure, List<ApplicationEntity>>> getApplicationsForPlan(
      String planId) async {
    try {
      _logger.d(
          '📝 [ApplicationRepositoryImpl] Obteniendo aplicaciones para plan: $planId');

      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('applications')
          .where('planId', isEqualTo: planId)
          .orderBy('appliedAt', descending: true)
          .get();

      final applications =
          snapshot.docs.map((doc) => _mapper.fromFirestore(doc)).toList();

      return Right(applications);
    } catch (e) {
      _logger.e('Error obteniendo aplicaciones para plan: $e');
      return Left(AppFailure(
        code: 'application-fetch-error',
        message: 'Error al obtener aplicaciones para el plan: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<AppFailure, List<ApplicationEntity>>> getUserApplications(
      String userId) async {
    try {
      _logger.d(
          '📝 [ApplicationRepositoryImpl] Obteniendo aplicaciones de usuario: $userId');

      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('applications')
          .where('applicantId', isEqualTo: userId)
          .orderBy('appliedAt', descending: true)
          .get();

      final applications =
          snapshot.docs.map((doc) => _mapper.fromFirestore(doc)).toList();

      return Right(applications);
    } catch (e) {
      _logger.e('Error obteniendo aplicaciones de usuario: $e');
      return Left(AppFailure(
        code: 'user-applications-fetch-error',
        message: 'Error al obtener aplicaciones del usuario: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<AppFailure, ApplicationEntity>> applyToPlan(
      ApplicationEntity application) async {
    try {
      _logger.d(
          '📝 [ApplicationRepositoryImpl] Aplicando a plan: ${application.planId}');

      // Verificar si el usuario ya aplicó a este plan
      final hasApplied = await hasUserAppliedToPlan(
          application.applicantId, application.planId);

      if (hasApplied.isRight()) {
        final bool alreadyApplied = hasApplied.getOrElse(() => false);
        if (alreadyApplied) {
          return Left(AppFailure(
            code: 'already-applied',
            message: 'Ya has aplicado a este plan',
          ));
        }
      }

      // Convertir la entidad a un mapa para Firestore
      final Map<String, dynamic> data = _mapper.toFirestore(application);

      // Crear el documento en Firestore
      final DocumentReference docRef =
          await _firestore.collection('applications').add(data);

      // Obtener el documento recién creado
      final DocumentSnapshot doc = await docRef.get();
      final ApplicationEntity createdApplication =
          _mapper.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);

      return Right(createdApplication);
    } catch (e) {
      _logger.e('Error aplicando a plan: $e');
      return Left(AppFailure(
        code: 'apply-error',
        message: 'Error al aplicar al plan: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<AppFailure, ApplicationEntity>> updateApplicationStatus(
      String applicationId, String status,
      {String? message}) async {
    try {
      _logger.d(
          '📝 [ApplicationRepositoryImpl] Actualizando estado de aplicación: $applicationId a $status');

      // Actualizar el estado en Firestore
      final docRef = _firestore.collection('applications').doc(applicationId);
      final updates = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
        if (message != null) 'statusMessage': message,
      };

      await docRef.update(updates);

      // Obtener la aplicación actualizada
      final DocumentSnapshot doc = await docRef.get();
      final ApplicationEntity updatedApplication =
          _mapper.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);

      return Right(updatedApplication);
    } catch (e) {
      _logger.e('Error actualizando estado de aplicación: $e');
      return Left(AppFailure(
        code: 'update-status-error',
        message:
            'Error al actualizar el estado de la aplicación: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteApplication(
      String applicationId) async {
    try {
      _logger.d(
          '📝 [ApplicationRepositoryImpl] Eliminando aplicación: $applicationId');

      await _firestore.collection('applications').doc(applicationId).delete();

      return const Right(unit);
    } catch (e) {
      _logger.e('Error eliminando aplicación: $e');
      return Left(AppFailure(
        code: 'delete-error',
        message: 'Error al eliminar la aplicación: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<AppFailure, ApplicationEntity>> getApplicationById(
      String applicationId) async {
    try {
      _logger.d(
          '📝 [ApplicationRepositoryImpl] Obteniendo aplicación por ID: $applicationId');

      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('applications').doc(applicationId).get();

      if (!doc.exists) {
        return Left(AppFailure(
          code: 'not-found',
          message: 'La aplicación no existe',
        ));
      }

      final ApplicationEntity application = _mapper.fromFirestore(doc);
      return Right(application);
    } catch (e) {
      _logger.e('Error obteniendo aplicación por ID: $e');
      return Left(AppFailure(
        code: 'fetch-by-id-error',
        message: 'Error al obtener la aplicación: ${e.toString()}',
      ));
    }
  }

  /// Obtener la aplicación de un usuario para un plan específico
  @override
  Future<Either<AppFailure, ApplicationEntity?>> getUserApplicationForPlan(
      String userId, String planId) async {
    try {
      _logger.d(
          '📝 [ApplicationRepositoryImpl] Obteniendo aplicación de usuario: $userId para plan: $planId');

      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('applications')
          .where('applicantId', isEqualTo: userId)
          .where('planId', isEqualTo: planId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Right(null);
      }

      final application = _mapper.fromFirestore(snapshot.docs.first);
      return Right(application);
    } catch (e) {
      _logger.e('Error obteniendo aplicación de usuario para plan: $e');
      return Left(AppFailure(
        code: 'user-application-fetch-error',
        message: 'Error al obtener la aplicación del usuario: ${e.toString()}',
      ));
    }
  }

  /// Método auxiliar para verificar si un usuario ya aplicó a un plan
  @override
  Future<Either<AppFailure, bool>> hasUserAppliedToPlan(
      String userId, String planId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('applications')
          .where('applicantId', isEqualTo: userId)
          .where('planId', isEqualTo: planId)
          .limit(1)
          .get();

      return Right(snapshot.docs.isNotEmpty);
    } catch (e) {
      _logger.e('Error verificando aplicación existente: $e');
      return Left(AppFailure(
        code: 'check-application-error',
        message: 'Error al verificar aplicación existente: ${e.toString()}',
      ));
    }
  }

  // Implementaciones adicionales para la interfaz ApplicationRepository

  /// Obtiene las aplicaciones de un plan (implementación para ApplicationRepository)
  @override
  Future<Either<AppFailure, List<ApplicationEntity>>> getPlanApplications(
      String planId) async {
    return getApplicationsForPlan(planId);
  }

  /// Cancela una aplicación (implementación para ApplicationRepository)
  @override
  Future<Either<AppFailure, ApplicationEntity>> cancelApplication(
      String applicationId) async {
    try {
      _logger.d(
          '📋 [ApplicationRepositoryImpl] Cancelando aplicación: $applicationId');

      // Actualizar el estado en Firestore
      final docRef = _firestore.collection('applications').doc(applicationId);
      final updates = {
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await docRef.update(updates);

      // Obtener la aplicación actualizada
      final DocumentSnapshot doc = await docRef.get();
      final ApplicationEntity updatedApplication =
          _mapper.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);

      return Right(updatedApplication);
    } catch (e) {
      _logger.e('Error cancelando aplicación: $e');
      return Left(AppFailure(
        code: 'cancel-error',
        message: 'Error al cancelar la aplicación: ${e.toString()}',
      ));
    }
  }
}
