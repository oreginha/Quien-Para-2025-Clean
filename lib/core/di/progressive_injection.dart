// lib/core/di/progressive_injection.dart
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/user_cache.dart';
import '../../data/mappers/user_mapper.dart';
import '../../data/mappers/application_mapper.dart';
import '../../data/repositories/plan/plan_repository_impl.dart';
import '../../data/repositories/application/application_repository_impl.dart';
import '../../domain/repositories/plan/plan_repository.dart';
import '../../domain/interfaces/application_repository_interface.dart';
import '../../domain/interfaces/notification_service_interface.dart';
import '../../domain/usecases/plan/create_plan_usecase.dart';
import '../../domain/usecases/plan/get_plan_by_id_usecase.dart';
import '../../domain/usecases/plan/update_plan_usecase.dart';
import '../../domain/usecases/plan/save_plan_usecase.dart';
import '../../domain/usecases/plan/get_plans_usecase.dart';
import '../../domain/usecases/plan/match_plan_usecase.dart';
import '../../domain/usecases/plan/delete_plan_usecase.dart';
import '../../domain/usecases/plan/get_other_users_plans_usecase.dart';
import '../../domain/usecases/application/apply_to_plan_usecase.dart';
import '../../domain/usecases/application/get_plan_applications_usecase.dart';
import '../../domain/usecases/application/get_user_applications_usecase.dart';
import '../../domain/usecases/application/update_application_status_usecase.dart';
import '../../domain/usecases/application/cancel_application_usecase.dart';
import '../../domain/usecases/application/send_application_notification_usecase.dart';
import '../../domain/usecases/search/filter_plans_by_category_usecase.dart';
import '../../domain/usecases/search/search_plans_usecase.dart';
import '../../domain/usecases/search/filter_plans_by_location_usecase.dart';
import '../../domain/usecases/search/filter_plans_by_date_usecase.dart';
import '../../domain/usecases/security/create_report_usecase.dart';
import '../../domain/usecases/security/get_pending_reports_usecase.dart';
import '../../domain/repositories/report/report_repository.dart';
import '../../data/repositories/security/report_repository_impl.dart';
// Review system imports
import '../../domain/usecases/review/create_review_usecase.dart';
import '../../domain/usecases/review/get_user_reviews_usecase.dart';
import '../../domain/usecases/review/calculate_user_rating_usecase.dart';
import '../../domain/repositories/review/review_repository.dart';
import '../../data/repositories/review/review_repository_impl.dart';
import '../services/notification_service.dart';
import '../services/planes_api_service.dart';
import '../../presentation/bloc/chat/simple_chat_bloc.dart';

/// Inyección de dependencias progresiva optimizada
/// Permite inicialización lazy de servicios y casos de uso
class ProgressiveInjection {
  static final GetIt sl = GetIt.instance;

  // Control de estado de inicialización
  static bool _servicesInitialized = false;
  static bool _repositoriesInitialized = false;
  static final Map<String, bool> _useCasesInitialized = {};

  // Log para diagnóstico
  static final List<String> initializationLog = [];

  /// Inicializa servicios básicos de forma optimizada
  static Future<bool> initializeServices() async {
    if (_servicesInitialized) return true;

    try {
      _log('⚙️ Iniciando servicios básicos...');

      // Firebase (verificar si ya están registrados desde main)
      if (!sl.isRegistered<FirebaseFirestore>(
          instanceName: 'FirebaseFirestore')) {
        _safeRegister<FirebaseFirestore>(
            FirebaseFirestore.instance, 'FirebaseFirestore');
      }
      if (!sl.isRegistered<FirebaseAuth>(instanceName: 'FirebaseAuth')) {
        _safeRegister<FirebaseAuth>(FirebaseAuth.instance, 'FirebaseAuth');
      }
      if (!sl.isRegistered<FirebaseStorage>(instanceName: 'FirebaseStorage')) {
        _safeRegister<FirebaseStorage>(
            FirebaseStorage.instance, 'FirebaseStorage');
      }

      // SharedPreferences
      if (!sl.isRegistered<SharedPreferences>(
          instanceName: 'SharedPreferences')) {
        final prefs = await SharedPreferences.getInstance();
        _safeRegister<SharedPreferences>(prefs, 'SharedPreferences');
      }

      // Utilidades básicas
      if (!sl.isRegistered<Logger>(instanceName: 'Logger')) {
        _safeRegister<Logger>(Logger(), 'Logger');
      }
      if (!sl.isRegistered<UserCache>(instanceName: 'UserCache')) {
        _safeRegister<UserCache>(UserCache(), 'UserCache');
      }
      if (!sl.isRegistered<UserMapper>(instanceName: 'UserMapper')) {
        _safeRegister<UserMapper>(const UserMapper(), 'UserMapper');
      }
      if (!sl.isRegistered<ApplicationMapper>(
          instanceName: 'ApplicationMapper')) {
        _safeRegister<ApplicationMapper>(
            const ApplicationMapper(), 'ApplicationMapper');
      }
      if (!sl.isRegistered<PlanApiService>(instanceName: 'PlanApiService')) {
        _safeRegister<PlanApiService>(PlanApiService(), 'PlanApiService');
      }

      // Servicio de notificaciones
      if (!sl.isRegistered<NotificationService>(
          instanceName: 'NotificationService')) {
        _safeRegister<NotificationService>(
            NotificationService(), 'NotificationService');
      }

      // SimpleChatBloc
      if (!sl.isRegistered<SimpleChatBloc>(
          instanceName: 'SimpleChatBloc')) {
        _safeRegister<SimpleChatBloc>(
            SimpleChatBloc(), 'SimpleChatBloc');
      }

      _servicesInitialized = true;
      _log('✅ Servicios básicos inicializados');
      return true;
    } catch (e, stack) {
      _log('❌ Error inicializando servicios: $e');
      if (kDebugMode) print(stack);
      return false;
    }
  }

  /// Inicializa repositorios básicos
  static Future<bool> initializeRepositories() async {
    if (_repositoriesInitialized) return true;

    if (!_servicesInitialized) {
      final success = await initializeServices();
      if (!success) return false;
    }

    try {
      _log('⚙️ Iniciando repositorios...');

      // Plan Repository
      final planRepo = PlanRepositoryImpl(
        sl.get(instanceName: 'PlanApiService'),
        firestore: sl.get(instanceName: 'FirebaseFirestore'),
        storage: sl.get(instanceName: 'FirebaseStorage'),
        auth: sl.get(instanceName: 'FirebaseAuth'),
        cache: sl.get(instanceName: 'UserCache'),
        mapper: sl.get(instanceName: 'UserMapper'),
        logger: sl.get(instanceName: 'Logger'),
      );
      _safeRegister<PlanRepository>(planRepo, 'PlanRepository');

      // Application Repository
      final appRepo = ApplicationRepositoryImpl(
        firestore: sl.get(instanceName: 'FirebaseFirestore'),
        mapper: sl.get(instanceName: 'ApplicationMapper'),
        logger: sl.get(instanceName: 'Logger'),
      );
      _safeRegister<ApplicationRepositoryInterface>(
          appRepo, 'ApplicationRepository');

      // Report Repository
      final reportRepo = ReportRepositoryImpl(
        sl.get(instanceName: 'FirebaseFirestore'),
      );
      _safeRegister<ReportRepository>(reportRepo, 'ReportRepository');

      // Review Repository
      final reviewRepo = ReviewRepositoryImpl(
        firestore: sl.get(instanceName: 'FirebaseFirestore'),
      );
      _safeRegister<IReviewRepository>(reviewRepo, 'ReviewRepository');

      _repositoriesInitialized = true;
      _log('✅ Repositorios inicializados');
      return true;
    } catch (e, stack) {
      _log('❌ Error inicializando repositorios: $e');
      if (kDebugMode) print(stack);
      return false;
    }
  }

  /// Inicializa un caso de uso específico
  static Future<bool> initializeUseCase(String name) async {
    if (_useCasesInitialized.containsKey(name) && _useCasesInitialized[name]!) {
      return true;
    }

    if (!_repositoriesInitialized) {
      final success = await initializeRepositories();
      if (!success) return false;
    }

    try {
      _log('⚙️ Iniciando caso de uso: $name');

      bool success = false;

      switch (name) {
        // Plan Use Cases
        case 'CreatePlanUseCase':
          success = _initializeCreatePlanUseCase();
          break;
        case 'GetPlanByIdUseCase':
          success = _initializeGetPlanByIdUseCase();
          break;
        case 'UpdatePlanUseCase':
          success = _initializeUpdatePlanUseCase();
          break;
        case 'SavePlanUseCase':
          success = _initializeSavePlanUseCase();
          break;
        case 'GetPlansUseCase':
          success = _initializeGetPlansUseCase();
          break;
        case 'MatchPlanUseCase':
          success = _initializeMatchPlanUseCase();
          break;
        case 'DeletePlanUseCase':
          success = _initializeDeletePlanUseCase();
          break;
        case 'GetOtherUsersPlansUseCase':
          success = _initializeGetOtherUsersPlansUseCase();
          break;

        // Application Use Cases
        case 'ApplyToPlanUseCase':
          success = _initializeApplyToPlanUseCase();
          break;
        case 'GetPlanApplicationsUseCase':
          success = _initializeGetPlanApplicationsUseCase();
          break;
        case 'GetUserApplicationsUseCase':
          success = _initializeGetUserApplicationsUseCase();
          break;
        case 'UpdateApplicationStatusUseCase':
          success = _initializeUpdateApplicationStatusUseCase();
          break;
        case 'CancelApplicationUseCase':
          success = _initializeCancelApplicationUseCase();
          break;
        case 'SendApplicationNotificationUseCase':
          success = _initializeSendApplicationNotificationUseCase();
          break;

        // Search Use Cases
        case 'SearchPlansUseCase':
          success = _initializeSearchPlansUseCase();
          break;
        case 'FilterPlansByLocationUseCase':
          success = _initializeFilterPlansByLocationUseCase();
          break;
        case 'FilterPlansByDateUseCase':
          success = _initializeFilterPlansByDateUseCase();
          break;
        case 'FilterPlansByCategoryUseCase':
          success = _initializeFilterPlansByCategoryUseCase();
          break;

        // Security Use Cases
        case 'CreateReportUseCase':
          success = _initializeCreateReportUseCase();
          break;
        case 'GetPendingReportsUseCase':
          success = _initializeGetPendingReportsUseCase();
          break;
        case 'GetReportsByUserUseCase':
          success = _initializeGetReportsByUserUseCase();
          break;
        case 'UpdateReportStatusUseCase':
          success = _initializeUpdateReportStatusUseCase();
          break;

        // Review Use Cases
        case 'CreateReviewUseCase':
          success = _initializeCreateReviewUseCase();
          break;
        case 'GetUserReviewsUseCase':
          success = _initializeGetUserReviewsUseCase();
          break;
        case 'CalculateUserRatingUseCase':
          success = _initializeCalculateUserRatingUseCase();
          break;

        default:
          _log('❓ Caso de uso desconocido: $name');
          return false;
      }

      _useCasesInitialized[name] = success;

      if (success) {
        _log('✅ Caso de uso $name inicializado');
      } else {
        _log('❌ Error inicializando caso de uso $name');
      }

      return success;
    } catch (e, stack) {
      _log('❌ Error inicializando caso de uso $name: $e');
      if (kDebugMode) print(stack);
      _useCasesInitialized[name] = false;
      return false;
    }
  }

  /// Inicializa múltiples casos de uso
  static Future<Map<String, bool>> initializeMultipleUseCases(
      List<String> names) async {
    final Map<String, bool> results = {};

    for (final name in names) {
      results[name] = await initializeUseCase(name);
    }

    return results;
  }

  // ---- IMPLEMENTACIONES PRIVADAS DE CASOS DE USO ----

  static bool _initializeCreatePlanUseCase() {
    try {
      final repo = sl.get<PlanRepository>(instanceName: 'PlanRepository');
      _safeRegister<CreatePlanUseCase>(
          CreatePlanUseCase(repo), 'CreatePlanUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeGetPlanByIdUseCase() {
    try {
      final repo = sl.get<PlanRepository>(instanceName: 'PlanRepository');
      _safeRegister<GetPlanByIdUseCase>(
          GetPlanByIdUseCase(repo), 'GetPlanByIdUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeUpdatePlanUseCase() {
    try {
      final repo = sl.get<PlanRepository>(instanceName: 'PlanRepository');
      _safeRegister<UpdatePlanUseCase>(
          UpdatePlanUseCase(repo), 'UpdatePlanUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeSavePlanUseCase() {
    try {
      final repo = sl.get<PlanRepository>(instanceName: 'PlanRepository');
      _safeRegister<SavePlanUseCase>(SavePlanUseCase(repo), 'SavePlanUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeGetPlansUseCase() {
    try {
      final repo = sl.get<PlanRepository>(instanceName: 'PlanRepository');
      _safeRegister<GetPlansUseCase>(GetPlansUseCase(repo), 'GetPlansUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeMatchPlanUseCase() {
    try {
      final repo = sl.get<PlanRepository>(instanceName: 'PlanRepository');
      _safeRegister<MatchPlanUseCase>(
          MatchPlanUseCase(repo), 'MatchPlanUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeDeletePlanUseCase() {
    try {
      final repo = sl.get<PlanRepository>(instanceName: 'PlanRepository');
      _safeRegister<DeletePlanUseCase>(
          DeletePlanUseCase(repo), 'DeletePlanUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeGetOtherUsersPlansUseCase() {
    try {
      final repo = sl.get<PlanRepository>(instanceName: 'PlanRepository');
      _safeRegister<GetOtherUserPlansUseCase>(
          GetOtherUserPlansUseCase(repo), 'GetOtherUsersPlansUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeApplyToPlanUseCase() {
    try {
      final repo = sl.get<ApplicationRepositoryInterface>(
          instanceName: 'ApplicationRepository');
      _safeRegister<ApplyToPlanUseCase>(
          ApplyToPlanUseCase(repo), 'ApplyToPlanUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeGetPlanApplicationsUseCase() {
    try {
      final repo = sl.get<ApplicationRepositoryInterface>(
          instanceName: 'ApplicationRepository');
      _safeRegister<GetPlanApplicationsUseCase>(
          GetPlanApplicationsUseCase(repo), 'GetPlanApplicationsUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeGetUserApplicationsUseCase() {
    try {
      final repo = sl.get<ApplicationRepositoryInterface>(
          instanceName: 'ApplicationRepository');
      _safeRegister<GetUserApplicationsUseCase>(
          GetUserApplicationsUseCase(repo), 'GetUserApplicationsUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeUpdateApplicationStatusUseCase() {
    try {
      final repo = sl.get<ApplicationRepositoryInterface>(
          instanceName: 'ApplicationRepository');
      _safeRegister<UpdateApplicationStatusUseCase>(
          UpdateApplicationStatusUseCase(repo),
          'UpdateApplicationStatusUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeCancelApplicationUseCase() {
    try {
      final repo = sl.get<ApplicationRepositoryInterface>(
          instanceName: 'ApplicationRepository');
      _safeRegister<CancelApplicationUseCase>(
          CancelApplicationUseCase(repo), 'CancelApplicationUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeSendApplicationNotificationUseCase() {
    try {
      if (!sl.isRegistered<NotificationService>(
          instanceName: 'NotificationService')) {
        _log(
            '⚠️ NotificationService no registrado, omitiendo SendApplicationNotificationUseCase');
        return false;
      }

      final service = sl.get<NotificationServiceInterface>(
          instanceName: 'NotificationService');
      _safeRegister<SendApplicationNotificationUseCase>(
          SendApplicationNotificationUseCase(service),
          'SendApplicationNotificationUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  // ---- CASOS DE USO DE BÚSQUEDA ----

  static bool _initializeSearchPlansUseCase() {
    try {
      final repo = sl.get<PlanRepository>(instanceName: 'PlanRepository');
      _safeRegister<SearchPlansUseCase>(
          SearchPlansUseCase(repo), 'SearchPlansUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeFilterPlansByLocationUseCase() {
    try {
      final repo = sl.get<PlanRepository>(instanceName: 'PlanRepository');
      _safeRegister<FilterPlansByLocationUseCase>(
          FilterPlansByLocationUseCase(repo), 'FilterPlansByLocationUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeFilterPlansByDateUseCase() {
    try {
      final repo = sl.get<PlanRepository>(instanceName: 'PlanRepository');
      _safeRegister<FilterPlansByDateUseCase>(
          FilterPlansByDateUseCase(repo), 'FilterPlansByDateUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeFilterPlansByCategoryUseCase() {
    try {
      final repo = sl.get<PlanRepository>(instanceName: 'PlanRepository');
      _safeRegister<FilterPlansByCategoryUseCase>(
          FilterPlansByCategoryUseCase(repo), 'FilterPlansByCategoryUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  // ---- CASOS DE USO DE SEGURIDAD ----

  static bool _initializeCreateReportUseCase() {
    try {
      final repo = sl.get<ReportRepository>(instanceName: 'ReportRepository');
      _safeRegister<CreateReportUseCase>(
          CreateReportUseCase(repo), 'CreateReportUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeGetPendingReportsUseCase() {
    try {
      final repo = sl.get<ReportRepository>(instanceName: 'ReportRepository');
      _safeRegister<GetPendingReportsUseCase>(
          GetPendingReportsUseCase(repo), 'GetPendingReportsUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeGetReportsByUserUseCase() {
    try {
      final repo = sl.get<ReportRepository>(instanceName: 'ReportRepository');
      _safeRegister<GetReportsByUserUseCase>(
          GetReportsByUserUseCase(repo), 'GetReportsByUserUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeUpdateReportStatusUseCase() {
    try {
      final repo = sl.get<ReportRepository>(instanceName: 'ReportRepository');
      _safeRegister<UpdateReportStatusUseCase>(
          UpdateReportStatusUseCase(repo), 'UpdateReportStatusUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  // ---- CASOS DE USO DE REVIEWS ----

  static bool _initializeCreateReviewUseCase() {
    try {
      final repo = sl.get<IReviewRepository>(instanceName: 'ReviewRepository');
      _safeRegister<CreateReviewUseCase>(
          CreateReviewUseCase(repo), 'CreateReviewUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeGetUserReviewsUseCase() {
    try {
      final repo = sl.get<IReviewRepository>(instanceName: 'ReviewRepository');
      _safeRegister<GetUserReviewsUseCase>(
          GetUserReviewsUseCase(repo), 'GetUserReviewsUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  static bool _initializeCalculateUserRatingUseCase() {
    try {
      final repo = sl.get<IReviewRepository>(instanceName: 'ReviewRepository');
      _safeRegister<CalculateUserRatingUseCase>(
          CalculateUserRatingUseCase(repo), 'CalculateUserRatingUseCase');
      return true;
    } catch (e) {
      _log('Error: $e');
      return false;
    }
  }

  // ---- MÉTODOS UTILITARIOS ----

  /// Registra un servicio de forma segura con tipo explícito
  static void _safeRegister<T extends Object>(T instance, String name) {
    try {
      if (!sl.isRegistered<T>(instanceName: name)) {
        sl.registerSingleton<T>(instance, instanceName: name);
        _log('✓ Registrado: $name');
      } else {
        _log('⚠️ Ya registrado: $name');
      }
    } catch (e) {
      _log('❌ Error registrando $name: $e');
      rethrow;
    }
  }

  /// Log de mensajes
  static void _log(String message) {
    initializationLog.add(message);
    if (kDebugMode) {
      print(message);
    }
  }

  /// Obtiene el estado de inicialización
  static Map<String, bool> getInitializationStatus() {
    final Map<String, bool> status = {};

    status['Services'] = _servicesInitialized;
    status['Repositories'] = _repositoriesInitialized;
    status.addAll(_useCasesInitialized);

    return status;
  }

  /// Reinicia toda la inyección (útil para testing)
  static void reset() {
    try {
      sl.reset();
      _servicesInitialized = false;
      _repositoriesInitialized = false;
      _useCasesInitialized.clear();
      initializationLog.clear();
      _log('🔄 Inyección reiniciada');
    } catch (e) {
      _log('❌ Error reiniciando: $e');
    }
  }
}
