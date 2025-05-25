// libcore/blocs/my_applications/my_applications_cubit.dart
// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quien_para/domain/entities/application/application_entity.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

import '../loading_cubit.dart';

part 'my_applications_cubit.freezed.dart';

/// Datos específicos para la pantalla de mis aplicaciones
@freezed
class MyApplicationsData with _$MyApplicationsData {
  const factory MyApplicationsData({
    required List<ApplicationEntity> applications,
    required Map<String, PlanEntity?> plansCache,
    required String? selectedFilter,
    required bool isRefreshing,
  }) = _MyApplicationsData;

  /// Estado inicial para la pantalla de mis aplicaciones
  factory MyApplicationsData.initial() => const MyApplicationsData(
        applications: [],
        plansCache: {},
        selectedFilter: null,
        isRefreshing: false,
      );
}

/// Cubit para manejar la lógica de la pantalla de mis aplicaciones
///
/// Reemplaza la gestión de estado basada en setState() por un enfoque
/// más estructurado y predecible usando el patrón BLoC/Cubit.
class MyApplicationsCubit extends LoadingCubit<MyApplicationsData> {
  final FirebaseFirestore _firestore;
  final String? _userId;
  StreamSubscription? _applicationsSubscription;

  MyApplicationsCubit({
    required FirebaseFirestore firestore,
    String? userId,
  })  : _firestore = firestore,
        _userId = userId ?? FirebaseAuth.instance.currentUser?.uid,
        super() {
    // Inicializar con estado vacío
    setLoaded(MyApplicationsData.initial());
    // Cargar aplicaciones
    loadApplications();
  }

  /// Carga las aplicaciones del usuario
  Future<void> loadApplications() async {
    if (_userId == null) {
      setError('No se ha iniciado sesión');
      return;
    }

    try {
      // Siempre mostrar estado de carga para asegurar que la UI refleje que estamos cargando
      setLoading();

      if (kDebugMode) {
        print(
            '🔄 MyApplicationsCubit - Iniciando carga de aplicaciones para usuario: $_userId');
      }

      // Cancelar suscripción anterior si existe
      await _applicationsSubscription?.cancel();

      // Primero hacer una carga única para obtener datos rápidamente
      final snapshot = await _firestore
          .collection('applications')
          .where('applicantId', isEqualTo: _userId)
          .orderBy('appliedAt', descending: true)
          .get();

      // Verificar si hay documentos antes de procesar
      if (snapshot.docs.isEmpty) {
        // Si no hay aplicaciones, mostrar estado vacío en lugar de error
        setEmpty();
      } else {
        // Procesar los resultados inmediatamente si hay documentos
        _handleApplicationsSnapshot(snapshot);
      }

      // Luego configurar la suscripción para actualizaciones en tiempo real
      _applicationsSubscription = _firestore
          .collection('applications')
          .where('applicantId', isEqualTo: _userId)
          .orderBy('appliedAt', descending: true)
          .snapshots()
          .listen(
        (snapshot) {
          _handleApplicationsSnapshot(snapshot);
        },
        onError: (error) {
          if (kDebugMode) {
            print('Error en suscripción de aplicaciones: $error');
          }
          // Asegurarnos de salir del estado de carga incluso si hay un error
          // Esto evita que la UI se quede bloqueada en estado de carga
          if (state.isLoading) {
            setError('Error al cargar aplicaciones: $error');
          }
        },
        // Manejar el caso cuando el emisor está cerrado
        onDone: () {
          if (kDebugMode) {
            print('Suscripción de aplicaciones cerrada');
          }
          // Si todavía estamos en estado de carga cuando la suscripción se cierra,
          // forzar la salida del estado de carga para evitar bloqueos en la UI
          if (state.isLoading) {
            setEmpty();
          }
        },
      );
    } catch (error, stackTrace) {
      handleError('loadApplications', error, stackTrace);
      setError('Error al cargar aplicaciones: ${error.toString()}');
    }
  }

  /// Maneja los snapshots de aplicaciones recibidos
  void _handleApplicationsSnapshot(QuerySnapshot snapshot) {
    try {
      final applications = snapshot.docs
          .map((doc) => ApplicationEntity.fromMap(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      if (kDebugMode) {
        print(
            '✅ MyApplicationsCubit - Aplicaciones cargadas: ${applications.length}');
      }

      // Garantizar que salimos del estado de carga, incluso si hay un error posterior
      // Esto es crítico para evitar que la UI se quede bloqueada en estado de carga
      final currentState = state;
      final Map<String, PlanEntity?> currentCache = currentState.isLoaded
          ? Map<String, PlanEntity?>.from(currentState.data!.plansCache)
          : {};

      // Verificar si es la primera carga o una recarga
      final bool isInitialLoad = !currentState.isLoaded ||
          (currentState.isLoaded && currentState.data!.applications.isEmpty);

      // IMPORTANTE: Siempre emitir un estado cargado, incluso si no hay aplicaciones
      // Esto garantiza que salimos del estado de carga y evitamos el bloqueo reportado en los logs
      if (applications.isEmpty) {
        if (!isInitialLoad) {
          // Si no hay aplicaciones y no es la carga inicial, mostrar estado vacío
          setEmpty();
        } else {
          // Incluso en la carga inicial, si no hay aplicaciones, emitir un estado cargado vacío
          // en lugar de mantener el estado de carga
          setLoaded(MyApplicationsData.initial());
        }
      } else {
        // Emitir estado cargado con las aplicaciones
        setLoaded(MyApplicationsData.initial().copyWith(
          applications: applications,
          isRefreshing:
              false, // Siempre false para asegurar que la UI refleje que la carga ha terminado
          plansCache: currentCache,
        ));
      }

      // Cargar detalles de planes - Esto debe ejecutarse independientemente del estado de las aplicaciones
      if (applications.isNotEmpty) {
        _loadPlansInfo(applications);
      }
    } catch (error, stackTrace) {
      handleError('handleApplicationsSnapshot', error, stackTrace);
      // Incluso en caso de error, asegurarnos de salir del estado de carga
      // para evitar que la UI se quede bloqueada
      if (state.isLoading) {
        setError('Error al procesar aplicaciones: ${error.toString()}');
      }
    }
  }

  /// Carga la información de los planes asociados a las aplicaciones
  Future<void> _loadPlansInfo(List<ApplicationEntity> applications) async {
    try {
      final currentState = state;
      if (!currentState.isLoaded) {
        // Si no estamos en estado cargado, asegurar que salimos del estado de carga
        if (currentState.isLoading) {
          if (kDebugMode) {
            print(
                '⚠️ MyApplicationsCubit - Estado no cargado al intentar cargar planes');
          }
          // Forzar un estado cargado con aplicaciones vacías para evitar bloqueo
          setLoaded(MyApplicationsData.initial().copyWith(
            applications: applications,
            isRefreshing: false,
          ));
        }
        return;
      }

      final currentData = currentState.data!;
      final plansCache = Map<String, PlanEntity?>.from(currentData.plansCache);

      // Identificar planes que necesitan ser cargados
      final planIdsToLoad = <String>{};
      for (final application in applications) {
        if (!plansCache.containsKey(application.planId)) {
          planIdsToLoad.add(application.planId);
        }
      }

      if (planIdsToLoad.isEmpty) return;

      // Cargar planes en paralelo
      final futures = <Future>[];
      for (final planId in planIdsToLoad) {
        futures.add(_loadPlanDetails(planId, plansCache));
      }

      await Future.wait(futures);

      // Actualizar estado con los planes cargados
      if (state.isLoaded) {
        final updatedData = state.data!;
        setLoaded(updatedData.copyWith(plansCache: plansCache));
      } else if (state.isLoading) {
        // Si por alguna razón estamos en estado de carga, forzar la salida
        if (kDebugMode) {
          print(
              '⚠️ MyApplicationsCubit - Forzando salida de estado de carga en _loadPlansInfo');
        }
        setLoaded(MyApplicationsData.initial().copyWith(
          applications: applications,
          plansCache: plansCache,
          isRefreshing: false,
        ));
      }
    } catch (error, stackTrace) {
      handleError('loadPlansInfo', error, stackTrace);
      // No emitimos error aquí para no interrumpir la visualización de aplicaciones
      if (kDebugMode) {
        print('Error al cargar detalles de planes: $error');
      }

      // Asegurar que no nos quedamos en estado de carga incluso si hay un error
      if (state.isLoading) {
        if (kDebugMode) {
          print(
              '⚠️ MyApplicationsCubit - Forzando salida de estado de carga después de error en planes');
        }
        // Usar las aplicaciones que ya tenemos, sin los planes que fallaron
        setLoaded(MyApplicationsData.initial().copyWith(
          applications: applications,
          isRefreshing: false,
        ));
      }
    }
  }

  /// Carga los detalles de un plan específico
  Future<void> _loadPlanDetails(
    String planId,
    Map<String, PlanEntity?> plansCache,
  ) async {
    try {
      final planDoc = await _firestore.collection('plans').doc(planId).get();

      if (planDoc.exists) {
        final planData = planDoc.data();
        if (planData != null) {
          final data = planDoc.data() as Map<String, dynamic>;
          data['id'] =
              planDoc.id; // Asegurar que el ID esté incluido en los datos
          plansCache[planId] = PlanEntity.fromJson(data);
        } else {
          plansCache[planId] = null;
        }
        plansCache[planId] = null;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error al cargar plan $planId: $error');
      }
      plansCache[planId] = null;
    }
  }

  /// Filtra las aplicaciones por estado
  void filterApplications(String? filter) {
    final currentState = state;
    if (!currentState.isLoaded) return;

    final currentData = currentState.data!;
    setLoaded(currentData.copyWith(selectedFilter: filter));
  }

  /// Obtiene las aplicaciones filtradas según el filtro seleccionado
  List<ApplicationEntity> getFilteredApplications() {
    final currentState = state;
    if (!currentState.isLoaded) return [];

    final currentData = currentState.data!;
    final filter = currentData.selectedFilter;

    if (filter == null) {
      return currentData.applications;
    }

    return currentData.applications
        .where((app) => app.status == filter)
        .toList();
  }

  /// Obtiene el plan asociado a una aplicación
  PlanEntity? getPlanForApplication(ApplicationEntity application) {
    final currentState = state;
    if (!currentState.isLoaded) return null;

    final currentData = currentState.data!;
    return application.planId != null
        ? currentData.plansCache[application.planId]
        : null;
  }

  @override
  Future<void> close() {
    _applicationsSubscription?.cancel();
    return super.close();
  }
}
