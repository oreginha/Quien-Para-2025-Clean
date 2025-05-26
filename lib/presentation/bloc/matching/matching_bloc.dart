// lib/presentation/bloc/matching/matching_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/usecases/application/get_plan_applications_usecase.dart';
import 'package:quien_para/domain/usecases/application/apply_to_plan_usecase.dart';
import 'package:quien_para/domain/usecases/application/get_user_applications_usecase.dart';
import 'package:quien_para/domain/usecases/application/update_application_status_usecase.dart';
import 'package:quien_para/domain/usecases/application/cancel_application_usecase.dart';
import 'package:quien_para/domain/usecases/application/send_application_notification_usecase.dart';
import '../base_bloc.dart';
import '../bloc_use_case_executor.dart';
import '../../../domain/entities/application/application_entity.dart';
import '../../../core/services/application_chat_service.dart';
import 'matching_event.dart';
import 'matching_state.dart';

/// Bloc responsable de gestionar todas las operaciones relacionadas con
/// las postulaciones a planes y su estado
class MatchingBloc extends BaseBloc<MatchingEvent, MatchingState> {
  // Casos de uso
  final ApplyToPlanUseCase _applyToPlanUseCase;
  final GetPlanApplicationsUseCase _getPlanApplicationsUseCase;
  final GetUserApplicationsUseCase _getUserApplicationsUseCase;
  final UpdateApplicationStatusUseCase _updateApplicationStatusUseCase;
  final CancelApplicationUseCase _cancelApplicationUseCase;
  final SendApplicationNotificationUseCase _sendNotificationUseCase;

  // Servicios
  final ApplicationChatService _applicationChatService =
      ApplicationChatService();

  /// Constructor del MatchingBloc que inyecta todas las dependencias necesarias
  MatchingBloc(
    this._applyToPlanUseCase,
    this._getPlanApplicationsUseCase,
    this._getUserApplicationsUseCase,
    this._updateApplicationStatusUseCase,
    this._cancelApplicationUseCase,
    this._sendNotificationUseCase,
  ) : super(const MatchingState.initial()) {
    on<MatchingEvent>((event, emit) {
      if (kDebugMode) {
        print('💥 MatchingBloc - Evento recibido: ${event.runtimeType}');
      }

      // Usamos when para manejar los eventos de manera consistente
      event.when(
        applyToPlan: (planId, message) =>
            _handleApplyToPlan(planId, message, emit),
        loadUserApplications: (userId) =>
            _handleLoadUserApplications(userId, emit),
        loadPlanApplications: (planId) =>
            _handleLoadPlanApplications(planId, emit),
        acceptApplication: (applicationId) =>
            _handleAcceptApplication(applicationId, emit),
        rejectApplication: (applicationId) =>
            _handleRejectApplication(applicationId, emit),
        cancelApplication: (applicationId) =>
            _handleCancelApplication(applicationId, emit),
        refreshApplications: () => _handleRefreshApplications(emit),
      );
    });

    if (kDebugMode) {
      logger.d('MatchingBloc inicializado');
    }
  }

  /// Maneja la postulación a un plan
  Future<void> _handleApplyToPlan(
    String planId,
    String? message,
    Emitter<MatchingState> emit,
  ) async {
    await BlocUseCaseExecutor.execute<ApplicationEntity, MatchingState>(
      emit: emit,
      loadingState: const MatchingState.loading(),
      operation: 'aplicar a plan',
      execute: () async {
        // El caso de uso debe obtener el ID del usuario actual del repositorio de autenticación
        // en lugar de accederlo directamente desde Firebase

        // Crear la entidad de aplicación con userId obtenido a través del caso de uso
        final ApplicationEntity application = await _applyToPlanUseCase
            .createApplicationEntity(
              planId: planId,
              message: message,
              status: 'pending',
              appliedAt: DateTime.now(),
            );

        // Delegar al caso de uso
        final Either<AppFailure, ApplicationEntity> result =
            await _applyToPlanUseCase(application);

        // Desempaquetar el Either
        return result.fold((failure) => throw Exception(failure.message), (
          appEntity,
        ) async {
          await _sendNotificationUseCase.call(
            application: appEntity,
            notificationType: 'new_application',
          );
          return appEntity;
        });
      },
      onSuccess: (application) {
        // Actualizar la lista de aplicaciones del usuario en segundo plano
        _handleLoadUserApplications(null, emit);
        return MatchingState.applicationActionSuccess(
          'Aplicación enviada con éxito',
          application,
        );
      },
      onError: (e) => MatchingState.error(e.toString()),
    );
  }

  /// Carga las aplicaciones de un usuario específico o del usuario actual si no se proporciona ID
  Future<void> _handleLoadUserApplications(
    String? userId,
    Emitter<MatchingState> emit,
  ) async {
    await BlocUseCaseExecutor.execute<List<ApplicationEntity>, MatchingState>(
      emit: emit,
      loadingState: const MatchingState.loading(),
      operation: 'cargar aplicaciones de usuario',
      execute: () async {
        final String userIdToUse = await _getUserApplicationsUseCase
            .getCurrentUserId(userId);
        if (userIdToUse.isEmpty) {
          throw Exception('Usuario no autenticado');
        }
        if (kDebugMode) {
          logger.d('Cargando aplicaciones para usuario: $userIdToUse');
        }
        final result = await _getUserApplicationsUseCase(userIdToUse);
        return result.fold(
          (failure) => throw Exception(failure.message),
          (apps) => apps,
        );
      },
      onSuccess: (applications) {
        if (kDebugMode) {
          print(
            '✅ MatchingBloc - Emitiendo userApplicationsLoaded con ${applications.length} aplicaciones',
          );
        }
        return MatchingState.userApplicationsLoaded(applications);
      },
      onError: (e) => MatchingState.error(e.toString()),
    );
  }

  /// Carga las aplicaciones para un plan específico
  Future<void> _handleLoadPlanApplications(
    String planId,
    Emitter<MatchingState> emit,
  ) async {
    await BlocUseCaseExecutor.execute<List<ApplicationEntity>, MatchingState>(
      emit: emit,
      loadingState: const MatchingState.loading(),
      operation: 'cargar aplicaciones del plan',
      execute: () async {
        try {
          final result = await _getPlanApplicationsUseCase(planId);
          return result.fold(
            (failure) => throw Exception(failure.message),
            (apps) => apps,
          );
        } catch (e) {
          logger.e('Error al cargar aplicaciones del plan: $e');
          rethrow;
        }
      },
      onSuccess: (applications) =>
          MatchingState.planApplicationsLoaded(applications),
      onError: (e) => MatchingState.error(e.toString()),
    );
  }

  /// Acepta una aplicación a un plan
  Future<void> _handleAcceptApplication(
    String applicationId,
    Emitter<MatchingState> emit,
  ) async {
    await BlocUseCaseExecutor.execute<ApplicationEntity, MatchingState>(
      emit: emit,
      loadingState: const MatchingState.loading(),
      operation: 'aceptar aplicación',
      execute: () async {
        try {
          final result = await _updateApplicationStatusUseCase(
            applicationId,
            'accepted',
          );
          return result.fold((failure) => throw Exception(failure.message), (
            application,
          ) async {
            await _sendNotificationUseCase.call(
              application: application,
              notificationType: 'application_accepted',
            );
            if (application.status == 'accepted') {
              final String? chatId = await _applicationChatService
                  .createChatForAcceptedApplication(application);
              if (chatId != null) {
                logger.d('Chat creado con éxito: $chatId');
              }
            }
            return application;
          });
        } catch (e) {
          logger.e('Error al aceptar aplicación: $e');
          rethrow;
        }
      },
      onSuccess: (application) {
        if (application.planId.isNotEmpty) {
          _handleLoadPlanApplications(application.planId, emit);
        }
        return MatchingState.applicationActionSuccess(
          'Aplicación aceptada',
          application,
        );
      },
      onError: (e) => MatchingState.error(e.toString()),
    );
  }

  /// Rechaza una aplicación a un plan
  Future<void> _handleRejectApplication(
    String applicationId,
    Emitter<MatchingState> emit,
  ) async {
    await BlocUseCaseExecutor.execute<ApplicationEntity, MatchingState>(
      emit: emit,
      loadingState: const MatchingState.loading(),
      operation: 'rechazar aplicación',
      execute: () async {
        final result = await _updateApplicationStatusUseCase(
          applicationId,
          'rejected',
        );
        return result.fold((failure) => throw Exception(failure.message), (
          application,
        ) async {
          await _sendNotificationUseCase.call(
            application: application,
            notificationType: 'application_rejected',
          );
          return application;
        });
      },
      onSuccess: (application) {
        if (application.planId.isNotEmpty) {
          _handleLoadPlanApplications(application.planId, emit);
        }
        return MatchingState.applicationActionSuccess(
          'Aplicación rechazada',
          application,
        );
      },
      onError: (e) => MatchingState.error(e.toString()),
    );
  }

  /// Cancela una aplicación a un plan
  Future<void> _handleCancelApplication(
    String applicationId,
    Emitter<MatchingState> emit,
  ) async {
    await BlocUseCaseExecutor.execute<ApplicationEntity, MatchingState>(
      emit: emit,
      loadingState: const MatchingState.loading(),
      operation: 'cancelar aplicación',
      execute: () async {
        try {
          // 1. Obtener el ID del usuario actual usando el caso de uso
          // Este enfoque sigue los principios de Clean Architecture al encapsular la lógica
          // de autenticación dentro del caso de uso
          final String userId = await _getUserApplicationsUseCase
              .getCurrentUserId(null);

          // 2. Crear una aplicación temporal con el ID para mostrar en el estado
          final ApplicationEntity tempApplication = ApplicationEntity(
            id: applicationId,
            planId: '',
            applicantId: userId,
            status: 'cancelled',
            appliedAt: DateTime.now(),
          );

          // 3. Llamar al caso de uso para eliminar la aplicación
          await _cancelApplicationUseCase(applicationId);

          // 4. Enviar notificación de cancelación
          await _sendNotificationUseCase.call(
            application: tempApplication,
            notificationType: 'application_cancelled',
          );

          return tempApplication;
        } catch (e) {
          logger.e('Error al cancelar aplicación: $e');
          rethrow; // Re-lanzar para manejo consistente
        }
      },
      onSuccess: (application) {
        // Recargar las aplicaciones del usuario en segundo plano
        _handleLoadUserApplications(null, emit);
        return MatchingState.applicationActionSuccess(
          'Aplicación cancelada',
          application,
        );
      },
      onError: (e) => MatchingState.error(e.toString()),
    );
  }

  /// Refresca las aplicaciones según el estado actual
  Future<void> _handleRefreshApplications(Emitter<MatchingState> emit) async {
    // Refrescar según el estado actual
    final MatchingState currentState = state;

    // Log para depuración
    logger.d(
      'Refrescando aplicaciones desde estado: ${currentState.runtimeType}',
    );

    await currentState.map(
      initial: (_) {
        // No hacemos nada en estado inicial
        logger.d('Refresh en estado inicial - sin acción');
      },
      loading: (_) {
        // Ya está cargando, no hacemos nada
        logger.d('Refresh durante carga - operación ignorada');
      },
      userApplicationsLoaded: (loadedState) async {
        logger.d('Refresh de aplicaciones de usuario');
        await _handleLoadUserApplications(null, emit);
      },
      planApplicationsLoaded: (loadedState) async {
        // Intentar encontrar el planId del último estado
        if (loadedState.applications.isNotEmpty) {
          final String planId = loadedState.applications.first.planId;
          logger.d('Refresh de aplicaciones del plan: $planId');
          await _handleLoadPlanApplications(planId, emit);
        }
      },
      applicationActionSuccess: (successState) async {
        // Determinar qué refrescar basado en el application
        if (successState.application.planId.isNotEmpty) {
          logger.d(
            'Refresh después de acción en plan: ${successState.application.planId}',
          );
          await _handleLoadPlanApplications(
            successState.application.planId,
            emit,
          );
        } else {
          // Si no hay planId, refrescar las del usuario
          logger.d(
            'Refresh después de acción - cargando aplicaciones de usuario',
          );
          await _handleLoadUserApplications(null, emit);
        }
      },
      error: (errorState) {
        // No podemos determinar qué refrescar desde un error
        logger.d('Refresh en estado de error - operación ignorada');
      },
    );
  }
}
