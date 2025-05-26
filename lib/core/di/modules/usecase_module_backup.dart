// COPIA DE SEGURIDAD DE USECASE_MODULE.DART
// lib/core/di/modules/usecase_module.dart

import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase;
import 'package:logger/logger.dart';
import 'package:quien_para/domain/interfaces/application_repository_interface.dart';
import 'package:quien_para/domain/repositories/application/application_repository.dart';

import '../di_logger.dart';
import 'di_module.dart';

// Repositorios
import '../../../domain/repositories/plan/plan_repository.dart';
import '../../../domain/interfaces/notification_repository_interface.dart';

// Implementaciones
import '../../../data/repositories/plan/plan_repository_impl.dart';
import '../../../data/repositories/application/application_repository_impl.dart';
import '../../../data/mappers/user_mapper.dart';
import '../../../data/mappers/application_mapper.dart';
import '../../../data/datasources/local/user_cache.dart';
import '../../../core/services/planes_api_service.dart';

// Casos de uso: Plan
import '../../../domain/usecases/plan/create_plan_usecase.dart';
import '../../../domain/usecases/plan/get_plan_by_id_usecase.dart';
import '../../../domain/usecases/plan/update_plan_usecase.dart';
import '../../../domain/usecases/plan/save_plan_usecase.dart';
import '../../../domain/usecases/plan/delete_plan_usecase.dart';
import '../../../domain/usecases/plan/get_plans_usecase.dart';
import '../../../domain/usecases/plan/match_plan_usecase.dart';
import '../../../domain/usecases/plan/get_plans_with_creators_usecase.dart';

// Casos de uso: Application
import '../../../domain/usecases/application/apply_to_plan_usecase.dart';
import '../../../domain/usecases/application/get_plan_applications_usecase.dart';
import '../../../domain/usecases/application/get_user_applications_usecase.dart';
import '../../../domain/usecases/application/update_application_status_usecase.dart';
import '../../../domain/usecases/application/cancel_application_usecase.dart';
import '../../../domain/usecases/application/send_application_notification_usecase.dart';

// Casos de uso: Notification
import '../../../domain/usecases/notification/create_notification_usecase.dart';
import '../../../domain/interfaces/notification_service_interface.dart';

/// Módulo simplificado para registro de casos de uso
class UseCaseModule implements DIModule {
  @override
  Future<void> register(GetIt sl) async {
    try {
      // 1. Registrar repositorios si no existen
      _ensureRepositoriesExist(sl);

      // 2. Registrar casos de uso de planes
      _registerPlanUseCases(sl);

      // 3. Registrar casos de uso de aplicaciones
      _registerApplicationUseCases(sl);

      // 4. Registrar casos de uso de notificaciones
      _registerNotificationUseCases(sl);

      DILogger.success('UseCaseModule registrado correctamente');
    } catch (e) {
      DILogger.error('Error en registro de UseCaseModule: $e');
      // No lanzamos la excepción para que la app pueda continuar
    }
  }

  /// Asegura que existan los repositorios necesarios
  void _ensureRepositoriesExist(GetIt sl) {
    // PlanRepository
    if (!sl.isRegistered<PlanRepository>()) {
      final cache = sl.isRegistered<UserCache>()
          ? sl<UserCache>()
          : UserCache();
      final mapper = sl.isRegistered<UserMapper>()
          ? sl<UserMapper>()
          : const UserMapper();
      final apiService = sl.isRegistered<PlanApiService>()
          ? sl<PlanApiService>()
          : PlanApiService();

      if (!sl.isRegistered<UserCache>()) sl.registerSingleton<UserCache>(cache);
      if (!sl.isRegistered<UserMapper>()) {
        sl.registerSingleton<UserMapper>(mapper);
      }
      if (!sl.isRegistered<PlanApiService>()) {
        sl.registerSingleton<PlanApiService>(apiService);
      }

      final planRepo = PlanRepositoryImpl(
        apiService,
        firestore: FirebaseFirestore.instance,
        storage: firebase.FirebaseStorage.instance,
        auth: FirebaseAuth.instance,
        cache: cache,
        mapper: mapper,
        logger: Logger(),
      );

      sl.registerSingleton<PlanRepository>(planRepo);
      DILogger.debug('PlanRepository registrado');
    }

    // ApplicationRepository
    if (!sl.isRegistered<ApplicationRepository>()) {
      final mapper = sl.isRegistered<ApplicationMapper>()
          ? sl<ApplicationMapper>()
          : const ApplicationMapper();

      if (!sl.isRegistered<ApplicationMapper>()) {
        sl.registerSingleton<ApplicationMapper>(mapper);
      }

      final appRepo = ApplicationRepositoryImpl(
        firestore: FirebaseFirestore.instance,
        mapper: mapper,
        logger: Logger(),
      );

      sl.registerSingleton<ApplicationRepository>(appRepo);
      DILogger.debug('ApplicationRepository registrado');
    }
  }

  /// Registra casos de uso de planes
  void _registerPlanUseCases(GetIt sl) {
    final repo = sl<PlanRepository>();

    // Registrar cada caso de uso individualmente, verificando primero si ya existe
    _safeRegister<CreatePlanUseCase>(sl, () => CreatePlanUseCase(repo));
    _safeRegister<GetPlanByIdUseCase>(sl, () => GetPlanByIdUseCase(repo));
    _safeRegister<UpdatePlanUseCase>(sl, () => UpdatePlanUseCase(repo));
    _safeRegister<SavePlanUseCase>(sl, () => SavePlanUseCase(repo));
    _safeRegister<DeletePlanUseCase>(sl, () => DeletePlanUseCase(repo));
    _safeRegister<GetPlansUseCase>(sl, () => GetPlansUseCase(repo));
    _safeRegister<MatchPlanUseCase>(sl, () => MatchPlanUseCase(repo));

    // Caso especial que requiere FirebaseFirestore
    _safeRegister<GetPlansWithCreatorsUseCase>(
      sl,
      () => GetPlansWithCreatorsUseCase(repo, FirebaseFirestore.instance),
    );
  }

  /// Registra casos de uso de aplicaciones
  void _registerApplicationUseCases(GetIt sl) {
    final repo = sl<ApplicationRepository>();

    // Registrar cada caso de uso individualmente, verificando primero si ya existe
    _safeRegister<ApplyToPlanUseCase>(
      sl,
      () => ApplyToPlanUseCase(repo as ApplicationRepositoryInterface),
    );
    _safeRegister<GetPlanApplicationsUseCase>(
      sl,
      () => GetPlanApplicationsUseCase(repo as ApplicationRepositoryInterface),
    );
    _safeRegister<GetUserApplicationsUseCase>(
      sl,
      () => GetUserApplicationsUseCase(repo as ApplicationRepositoryInterface),
    );
    _safeRegister<UpdateApplicationStatusUseCase>(
      sl,
      () => UpdateApplicationStatusUseCase(
        repo as ApplicationRepositoryInterface,
      ),
    );
    _safeRegister<CancelApplicationUseCase>(
      sl,
      () => CancelApplicationUseCase(repo as ApplicationRepositoryInterface),
    );

    // Notificaciones si están disponibles
    if (sl.isRegistered<NotificationServiceInterface>()) {
      _safeRegister<SendApplicationNotificationUseCase>(
        sl,
        () => SendApplicationNotificationUseCase(
          sl<NotificationServiceInterface>(),
        ),
      );
    }
  }

  /// Registra casos de uso de notificaciones
  void _registerNotificationUseCases(GetIt sl) {
    if (sl.isRegistered<INotificationRepository>()) {
      final repo = sl<INotificationRepository>();

      // Solo registramos el caso de uso más esencial para notificaciones
      _safeRegister<CreateNotificationUseCase>(
        sl,
        () => CreateNotificationUseCase(repo),
      );
    }
  }

  /// Registra un caso de uso de forma segura
  void _safeRegister<T extends Object>(GetIt sl, T Function() factory) {
    try {
      if (!sl.isRegistered<T>()) {
        sl.registerSingleton<T>(factory());
        DILogger.debug('Registrado $T');
      } else {
        DILogger.debug('$T ya registrado (omitido)');
      }
    } catch (e) {
      DILogger.error('Error registrando $T: $e');
    }
  }

  @override
  Future<void> dispose(GetIt sl) async {
    // Simplemente dejar que GetIt maneje la limpieza
  }

  @override
  Future<void> registerTestDependencies(GetIt sl) async {
    await register(sl);
  }
}
