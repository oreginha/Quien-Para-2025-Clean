// libcore/blocs/applications_management/applications_management_bloc.dart
// ignore_for_file: unused_field

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/usecases/application/get_plan_applications_usecase.dart';
import '../../../domain/entities/application/application_entity.dart';
import '../../../domain/usecases/application/send_application_notification_usecase.dart';
import '../../../domain/usecases/application/update_application_status_usecase.dart';
import '../../../data/repositories/user/user_repository_impl.dart';
import '../../../core/services/application_chat_service.dart';
import 'applications_management_event.dart';
import 'applications_management_state.dart';

class ApplicationsManagementBloc
    extends Bloc<ApplicationsManagementEvent, ApplicationsManagementState> {
  final GetPlanApplicationsUseCase _getPlanApplicationsUseCase;
  final UpdateApplicationStatusUseCase _updateApplicationStatusUseCase;
  final SendApplicationNotificationUseCase _sendNotificationUseCase;
  final UserRepositoryImpl _userRepository;
  final FirebaseAuth _auth;
  final ApplicationChatService _applicationChatService;
  final Logger logger = Logger();

  ApplicationsManagementBloc(
    this._getPlanApplicationsUseCase,
    this._updateApplicationStatusUseCase,
    this._sendNotificationUseCase,
    this._userRepository,
    this._auth,
    this._applicationChatService,
  ) : super(const ApplicationsManagementState.initial()) {
    on<ApplicationsManagementEvent>((event, emit) async {
      await event.when(
        initialize: (planId) => _onInitialize(planId, emit),
        loadApplications: (planId) => _onLoadApplications(planId, emit),
        loadUserProfiles: () => _onLoadUserProfiles(emit),
        acceptApplication: (applicationId) =>
            _onAcceptApplication(applicationId, emit),
        rejectApplication: (applicationId) =>
            _onRejectApplication(applicationId, emit),
        filterApplications: (filterType) =>
            _onFilterApplications(filterType, emit),
        searchApplications: (query) => _onSearchApplications(query, emit),
        changeView: (viewType) => _onChangeView(viewType, emit),
      );
    });
  }

  // Método de inicialización - carga aplicaciones y perfiles
  Future<void> _onInitialize(
    String planId,
    Emitter<ApplicationsManagementState> emit,
  ) async {
    emit(const ApplicationsManagementState.loading());
    try {
      // Cargar aplicaciones
      final Either<AppFailure, List<ApplicationEntity>> result =
          await _getPlanApplicationsUseCase(planId);

      final List<ApplicationEntity> applications = result.fold((failure) {
        throw Exception(failure.toString());
      }, (applications) => applications);

      // Inicializar con estado cargado pero perfiles vacíos
      emit(
        ApplicationsManagementState.loaded(
          allApplications: applications,
          filteredApplications: applications,
          userProfiles: <String, dynamic>{},
          currentFilter: 'all',
          currentSearch: '',
          viewType: 'card',
        ),
      );

      // Disparar el evento para cargar los perfiles
      add(const ApplicationsManagementEvent.loadUserProfiles());
    } catch (e) {
      logger.e('Error al inicializar las aplicaciones: $e');
      emit(ApplicationsManagementState.error(e.toString()));
    }
  }

  // Método para cargar las aplicaciones
  Future<void> _onLoadApplications(
    String planId,
    Emitter<ApplicationsManagementState> emit,
  ) async {
    // Si ya estamos en estado cargado, marcamos como refrescando
    state.maybeWhen(
      loaded: (
        allApplications,
        filteredApplications,
        userProfiles,
        currentFilter,
        currentSearch,
        viewType,
        isRefreshing,
        message,
      ) {
        emit(
          ApplicationsManagementState.loaded(
            allApplications: allApplications,
            filteredApplications: filteredApplications,
            userProfiles: userProfiles,
            currentFilter: currentFilter,
            currentSearch: currentSearch,
            viewType: viewType,
            isRefreshing: true,
          ),
        );
      },
      orElse: () => emit(const ApplicationsManagementState.loading()),
    );

    try {
      // Cargar aplicaciones
      final Either<AppFailure, List<ApplicationEntity>> result =
          await _getPlanApplicationsUseCase(planId);

      final List<ApplicationEntity> applications = result.fold((failure) {
        throw Exception(failure.toString());
      }, (applications) => applications);

      // Aplicar filtros actuales si estaban en estado cargado
      state.maybeWhen(
        loaded: (
          _,
          __,
          userProfiles,
          currentFilter,
          currentSearch,
          viewType,
          isRefreshing,
          message,
        ) {
          final List<ApplicationEntity> filtered = _applyFiltersAndSearch(
            applications,
            currentFilter,
            currentSearch,
          );

          emit(
            ApplicationsManagementState.loaded(
              allApplications: applications,
              filteredApplications: filtered,
              userProfiles: userProfiles,
              currentFilter: currentFilter,
              currentSearch: currentSearch,
              viewType: viewType,
              isRefreshing: false,
            ),
          );

          // Actualizar perfiles si hay nuevos aplicantes
          if (_needToUpdateProfiles(applications, userProfiles)) {
            add(const ApplicationsManagementEvent.loadUserProfiles());
          }
        },
        orElse: () {
          // Si no estaba en estado cargado, inicializar todo
          emit(
            ApplicationsManagementState.loaded(
              allApplications: applications,
              filteredApplications: applications,
              userProfiles: <String, dynamic>{},
              currentFilter: 'all',
              currentSearch: '',
              viewType: 'card',
              isRefreshing: false,
            ),
          );

          // Cargar perfiles
          add(const ApplicationsManagementEvent.loadUserProfiles());
        },
      );
    } catch (e) {
      logger.e('Error al cargar las aplicaciones: $e');
      emit(ApplicationsManagementState.error(e.toString()));
    }
  }

  // Método para cargar los perfiles de usuario
  Future<Object?> _onLoadUserProfiles(
    Emitter<ApplicationsManagementState> emit,
  ) async {
    return state.maybeWhen(
      loaded: (
        allApplications,
        filteredApplications,
        userProfiles,
        currentFilter,
        currentSearch,
        viewType,
        isRefreshing,
        message,
      ) async {
        try {
          Map<String, dynamic> updatedProfiles = Map.from(userProfiles);
          bool profilesChanged = false;

          // Para cada aplicación, cargar el perfil si no existe
          for (ApplicationEntity app in allApplications) {
            if (!updatedProfiles.containsKey(app.applicantId)) {
              try {
                final Either<AppFailure, UserEntity?> profile =
                    await _userRepository.getUserProfileById(
                  app.applicantId,
                );
                updatedProfiles[app.applicantId] = profile;
                profilesChanged = true;
              } catch (e) {
                logger.e(
                  'Error al cargar perfil de usuario ${app.applicantId}: $e',
                );
              }
            }
          }

          // Solo emitir nuevo estado si hubo cambios en los perfiles
          if (profilesChanged) {
            emit(
              ApplicationsManagementState.loaded(
                allApplications: allApplications,
                filteredApplications: filteredApplications,
                userProfiles: updatedProfiles,
                currentFilter: currentFilter,
                currentSearch: currentSearch,
                viewType: viewType,
                isRefreshing: isRefreshing,
                message: 'Perfiles de usuario actualizados',
              ),
            );
          }
        } catch (e) {
          logger.e('Error al cargar perfiles de usuario: $e');
          // No emitimos estado de error para no interrumpir la UI
        }
        return null;
      },
      orElse: () {
        return null;

        // No hacer nada si no estamos en estado cargado
      },
    );
  }

  // Método para aceptar una aplicación
  Future<void> _onAcceptApplication(
    String applicationId,
    Emitter<ApplicationsManagementState> emit,
  ) async {
    try {
      emit(const ApplicationsManagementState.loading());

      final Either<AppFailure, ApplicationEntity> result =
          await _updateApplicationStatusUseCase(applicationId, 'accepted');

      final ApplicationEntity application = await result.fold((failure) {
        throw Exception(failure.toString());
      }, (application) => application);

      // Enviar notificación
      await _sendNotificationUseCase.call(
        application: application,
        notificationType: 'application_accepted',
      );

      // Crear chat si la aplicación fue aceptada
      if (application.status == 'accepted') {
        final String? chatId = await _applicationChatService
            .createChatForAcceptedApplication(application);
        if (chatId != null) {
          if (kDebugMode) {
            print('Chat creado con éxito: $chatId');
          }
        }
      }

      // Emitir estado de éxito
      emit(
        ApplicationsManagementState.actionSuccess(
          message: 'Aplicación aceptada con éxito',
          application: application,
        ),
      );

      // Recargar las aplicaciones
      if (application.planId.isNotEmpty) {
        add(ApplicationsManagementEvent.loadApplications(application.planId));
      }
    } catch (e) {
      emit(ApplicationsManagementState.error(e.toString()));
    }
  }

  // Método para rechazar una aplicación
  Future<void> _onRejectApplication(
    String applicationId,
    Emitter<ApplicationsManagementState> emit,
  ) async {
    try {
      emit(const ApplicationsManagementState.loading());

      final Either<AppFailure, ApplicationEntity> result =
          await _updateApplicationStatusUseCase(applicationId, 'rejected');

      final ApplicationEntity application = await result.fold((failure) {
        throw Exception(failure.toString());
      }, (application) => application);

      // Enviar notificación
      await _sendNotificationUseCase.call(
        application: application,
        notificationType: 'application_rejected',
      );

      // Emitir estado de éxito
      emit(
        ApplicationsManagementState.actionSuccess(
          message: 'Aplicación rechazada',
          application: application,
        ),
      );

      // Recargar las aplicaciones
      if (application.planId.isNotEmpty) {
        add(ApplicationsManagementEvent.loadApplications(application.planId));
      }
    } catch (e) {
      emit(ApplicationsManagementState.error(e.toString()));
    }
  }

  // Método para filtrar aplicaciones
  Future<void> _onFilterApplications(
    String filterType,
    Emitter<ApplicationsManagementState> emit,
  ) async {
    state.maybeWhen(
      loaded: (
        allApplications,
        filteredApplications,
        userProfiles,
        currentFilter,
        currentSearch,
        viewType,
        isRefreshing,
        message,
      ) {
        final List<ApplicationEntity> filtered = _applyFiltersAndSearch(
          allApplications,
          filterType,
          currentSearch,
        );

        emit(
          ApplicationsManagementState.loaded(
            allApplications: allApplications,
            filteredApplications: filtered,
            userProfiles: userProfiles,
            currentFilter: filterType,
            currentSearch: currentSearch,
            viewType: viewType,
            isRefreshing: false,
            message: 'Mostrando ${filtered.length} aplicaciones',
          ),
        );
      },
      orElse: () {
        // No hacer nada si no estamos en estado cargado
      },
    );
  }

  // Método para buscar aplicaciones
  Future<void> _onSearchApplications(
    String query,
    Emitter<ApplicationsManagementState> emit,
  ) async {
    state.maybeWhen(
      loaded: (
        allApplications,
        filteredApplications,
        userProfiles,
        currentFilter,
        currentSearch,
        viewType,
        isRefreshing,
        message,
      ) {
        final List<ApplicationEntity> filtered = _applyFiltersAndSearch(
          allApplications,
          currentFilter,
          query,
        );

        emit(
          ApplicationsManagementState.loaded(
            allApplications: allApplications,
            filteredApplications: filtered,
            userProfiles: userProfiles,
            currentFilter: currentFilter,
            currentSearch: query,
            viewType: viewType,
            isRefreshing: false,
          ),
        );
      },
      orElse: () {
        // No hacer nada si no estamos en estado cargado
      },
    );
  }

  // Método para cambiar el tipo de vista
  Future<void> _onChangeView(
    String viewType,
    Emitter<ApplicationsManagementState> emit,
  ) async {
    state.maybeWhen(
      loaded: (
        allApplications,
        filteredApplications,
        userProfiles,
        currentFilter,
        currentSearch,
        currentViewType,
        isRefreshing,
        message,
      ) {
        emit(
          ApplicationsManagementState.loaded(
            allApplications: allApplications,
            filteredApplications: filteredApplications,
            userProfiles: userProfiles,
            currentFilter: currentFilter,
            currentSearch: currentSearch,
            viewType: viewType,
            isRefreshing: false,
          ),
        );
      },
      orElse: () {
        // No hacer nada si no estamos en estado cargado
      },
    );
  }

  // Método auxiliar para aplicar filtros y búsqueda
  List<ApplicationEntity> _applyFiltersAndSearch(
    List<ApplicationEntity> applications,
    String filter,
    String search,
  ) {
    // Primero aplicamos el filtro
    List<ApplicationEntity> filtered;
    switch (filter) {
      case 'pending':
        filtered =
            applications.where((app) => app.status == 'pending').toList();
        break;
      case 'accepted':
        filtered =
            applications.where((app) => app.status == 'accepted').toList();
        break;
      case 'rejected':
        filtered =
            applications.where((app) => app.status == 'rejected').toList();
        break;
      case 'all':
      default:
        filtered = List.from(applications);
        break;
    }

    // Si la búsqueda está vacía, devolver solo con filtro
    if (search.isEmpty) {
      return filtered;
    }

    // Luego aplicamos la búsqueda
    return filtered.where((app) {
      // Buscar en los campos de la aplicación
      final String searchLower = search.toLowerCase();

      // Si tenemos el perfil de usuario, buscar ahí también
      final Map<String, dynamic>? profile = state.maybeWhen(
        loaded: (_, __, userProfiles, ___, ____, _____, ______, _______) =>
            userProfiles[app.applicantId] as Map<String, dynamic>?,
        orElse: () => null,
      );

      if (profile != null) {
        final String name = (profile['name'] as String? ?? '').toLowerCase();
        final String email = (profile['email'] as String? ?? '').toLowerCase();

        if (name.contains(searchLower) || email.contains(searchLower)) {
          return true;
        }
      }

      // Si el mensaje de la aplicación coincide
      if (app.message != null &&
          app.message!.toLowerCase().contains(searchLower)) {
        return true;
      }

      return false;
    }).toList();
  }

  // Método para verificar si necesitamos actualizar perfiles
  bool _needToUpdateProfiles(
    List<ApplicationEntity> applications,
    Map<String, dynamic> userProfiles,
  ) {
    for (ApplicationEntity app in applications) {
      if (!userProfiles.containsKey(app.applicantId)) {
        return true;
      }
    }
    return false;
  }
}
