// lib/core/di/modules/repository_module.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase;
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/core/di/modules/di_module.dart';
import 'package:quien_para/core/services/planes_api_service.dart';
import 'package:quien_para/core/services/firebase_storage.dart' as metrics;
import 'package:quien_para/data/datasources/local/user_cache.dart';
import 'package:quien_para/data/mappers/application_mapper.dart';
import 'package:quien_para/data/mappers/chat_mapper.dart';
import 'package:quien_para/data/mappers/message_mapper.dart';
import 'package:quien_para/data/mappers/plan_mapper.dart';
import 'package:quien_para/data/mappers/user_mapper.dart';
import 'package:quien_para/data/repositories/application/application_repository_impl.dart';
import 'package:quien_para/data/repositories/chat/chat_repository_impl.dart';
import 'package:quien_para/data/repositories/plan/plan_repository_impl.dart';
import 'package:quien_para/data/repositories/user/user_repository_impl.dart';
import 'package:quien_para/domain/repositories/application/application_repository.dart';
import 'package:quien_para/domain/interfaces/application_repository_interface.dart';
import 'package:quien_para/domain/repositories/chat/chat_repository.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/repositories/user/user_repository_interface.dart';

/// Módulo de inyección de dependencias para los repositorios
class RepositoryModule implements DIModule {
  final Logger _logger = Logger();

  /// Registra todas las implementaciones de repositorio en el contenedor de dependencias
  @override
  Future<void> register(GetIt sl) async {
    _logger.d('Registrando repositorios...');

    // Registrar servicios de almacenamiento
    if (!sl.isRegistered<firebase.FirebaseStorage>()) {
      sl.registerLazySingleton<firebase.FirebaseStorage>(
        () => firebase.FirebaseStorage.instance,
      );
    }
    if (!sl.isRegistered<metrics.FirebaseMetricsStorage>()) {
      sl.registerLazySingleton<metrics.FirebaseMetricsStorage>(
        () => metrics.FirebaseMetricsStorage(sl<FirebaseFirestore>()),
      );
    }

    // Registrar mappers
    sl.registerLazySingleton<PlanMapper>(() => const PlanMapper());
    sl.registerLazySingleton<UserMapper>(() => const UserMapper());
    sl.registerLazySingleton<ChatMapper>(() => const ChatMapper());
    sl.registerLazySingleton<MessageMapper>(() => const MessageMapper());
    sl.registerLazySingleton<ApplicationMapper>(
      () => const ApplicationMapper(),
    );

    // Registrar repositorios
    _registerPlanRepository(sl);
    _registerUserRepository(sl);
    _registerChatRepository(sl);
    _registerApplicationRepository(sl);

    _logger.d('Repositorios registrados correctamente');
  }

  /// Registrar la implementación del repositorio de planes
  void _registerPlanRepository(GetIt sl) {
    sl.registerLazySingleton<PlanRepository>(() {
      // Verificar si ya existen las dependencias necesarias
      final FirebaseFirestore firestore = sl.isRegistered<FirebaseFirestore>()
          ? sl<FirebaseFirestore>()
          : FirebaseFirestore.instance;

      final FirebaseAuth auth = sl.isRegistered<FirebaseAuth>()
          ? sl<FirebaseAuth>()
          : FirebaseAuth.instance;

      final firebase.FirebaseStorage storage =
          sl.isRegistered<firebase.FirebaseStorage>()
              ? sl<firebase.FirebaseStorage>()
              : firebase.FirebaseStorage.instance;

      // Obtener el mapper
      final UserMapper mapper = sl<UserMapper>();

      // Obtener el caché de usuario si está disponible
      final userCache =
          sl.isRegistered<UserCache>() ? sl<UserCache>() : UserCache();

      // Obtener el logger si está disponible
      final Logger logger = sl.isRegistered<Logger>() ? sl<Logger>() : Logger();

      // Obtener o crear el servicio API
      final apiService = sl.isRegistered<PlanApiService>()
          ? sl<PlanApiService>()
          : PlanApiService();

      return PlanRepositoryImpl(
        apiService,
        firestore: firestore,
        storage: storage,
        auth: auth,
        cache: userCache,
        logger: logger,
        mapper: mapper,
      );
    });
  }

  /// Registrar la implementación del repositorio de usuarios
  void _registerUserRepository(GetIt sl) {
    sl.registerLazySingleton<IUserRepository>(() {
      // Verificar si ya existen las dependencias necesarias
      final FirebaseFirestore firestore = sl.isRegistered<FirebaseFirestore>()
          ? sl<FirebaseFirestore>()
          : FirebaseFirestore.instance;

      final FirebaseAuth auth = sl.isRegistered<FirebaseAuth>()
          ? sl<FirebaseAuth>()
          : FirebaseAuth.instance;

      // Usar Firebase Storage para el repositorio de usuarios
      final firebase.FirebaseStorage storage =
          sl.isRegistered<firebase.FirebaseStorage>()
              ? sl<firebase.FirebaseStorage>()
              : firebase.FirebaseStorage.instance;

      // Obtener el mapper
      final UserMapper mapper = sl<UserMapper>();

      // Obtener el caché de usuario si está disponible
      final userCache =
          sl.isRegistered<UserCache>() ? sl<UserCache>() : UserCache();

      return UserRepositoryImpl(
        firestore: firestore,
        auth: auth,
        storage: storage,
        mapper: mapper,
        cache: userCache,
      );
    });
  }

  /// Registrar la implementación del repositorio de chat
  void _registerChatRepository(GetIt sl) {
    sl.registerLazySingleton<ChatRepository>(() {
      // Verificar si ya existen las dependencias necesarias
      final FirebaseFirestore firestore = sl.isRegistered<FirebaseFirestore>()
          ? sl<FirebaseFirestore>()
          : FirebaseFirestore.instance;

      final FirebaseAuth auth = sl.isRegistered<FirebaseAuth>()
          ? sl<FirebaseAuth>()
          : FirebaseAuth.instance;

      // Obtener los mappers
      final ChatMapper chatMapper = sl<ChatMapper>();
      final MessageMapper messageMapper = sl<MessageMapper>();

      // Obtener el logger si está disponible
      final Logger logger = sl.isRegistered<Logger>() ? sl<Logger>() : Logger();

      return ChatRepositoryImpl(
        firestore: firestore,
        auth: auth,
        chatMapper: chatMapper,
        messageMapper: messageMapper,
        logger: logger,
      );
    });
  }

  /// Registrar la implementación del repositorio de aplicaciones
  void _registerApplicationRepository(GetIt sl) {
    // Crear una instancia del repositorio de aplicaciones
    final applicationRepoImpl = ApplicationRepositoryImpl(
      firestore: sl.isRegistered<FirebaseFirestore>()
          ? sl<FirebaseFirestore>()
          : FirebaseFirestore.instance,
      mapper: sl<ApplicationMapper>(),
      logger: sl.isRegistered<Logger>() ? sl<Logger>() : Logger(),
    );

    // Registrar la implementación para ambas interfaces
    sl.registerLazySingleton<ApplicationRepository>(() => applicationRepoImpl);

    // Registrar también para la interfaz extendida
    sl.registerLazySingleton<ApplicationRepositoryInterface>(
      () => applicationRepoImpl,
    );
  }

  @override
  Future<void> dispose(GetIt container) async {
    _logger.d('Liberando recursos de los repositorios...');

    // Desregistrar los mappers
    if (container.isRegistered<PlanMapper>()) {
      await container.unregister<PlanMapper>();
    }
    if (container.isRegistered<UserMapper>()) {
      await container.unregister<UserMapper>();
    }
    if (container.isRegistered<ChatMapper>()) {
      await container.unregister<ChatMapper>();
    }
    if (container.isRegistered<MessageMapper>()) {
      await container.unregister<MessageMapper>();
    }
    if (container.isRegistered<ApplicationMapper>()) {
      await container.unregister<ApplicationMapper>();
    }

    // Desregistrar los repositorios
    if (container.isRegistered<PlanRepository>()) {
      await container.unregister<PlanRepository>();
    }
    if (container.isRegistered<IUserRepository>()) {
      await container.unregister<IUserRepository>();
    }
    if (container.isRegistered<ChatRepository>()) {
      await container.unregister<ChatRepository>();
    }
    if (container.isRegistered<ApplicationRepository>()) {
      await container.unregister<ApplicationRepository>();
    }
    if (container.isRegistered<ApplicationRepositoryInterface>()) {
      await container.unregister<ApplicationRepositoryInterface>();
    }

    // No desregistramos las instancias de Firebase ya que podrían
    // ser utilizadas por otros módulos

    _logger.d('Recursos de los repositorios liberados correctamente');
  }

  @override
  Future<void> registerTestDependencies(GetIt container) async {
    _logger.d('Registrando dependencias de prueba para repositorios...');

    // En un escenario de prueba, podríamos registrar mocks de Firebase
    // o implementaciones en memoria de los repositorios

    // Registrar mappers (estos son los mismos que para producción)
    container.registerLazySingleton<PlanMapper>(() => const PlanMapper());
    container.registerLazySingleton<UserMapper>(() => const UserMapper());
    container.registerLazySingleton<ChatMapper>(() => const ChatMapper());
    container.registerLazySingleton<MessageMapper>(() => const MessageMapper());
    container.registerLazySingleton<ApplicationMapper>(
      () => const ApplicationMapper(),
    );

    // Ejemplo de cómo podríamos registrar mocks de repositorios:
    // Si tuviéramos implementaciones de prueba, las registraríamos aquí
    // container.registerLazySingleton<PlanRepository>(() => MockPlanRepository());
    // container.registerLazySingleton<IUserRepository>(() => MockUserRepository());
    // container.registerLazySingleton<ChatRepository>(() => MockChatRepository());

    // Como alternativa, podemos usar las implementaciones reales pero con
    // configuraciones específicas para pruebas

    // Para este ejemplo, usaremos las implementaciones reales con Firebase
    // pero en un entorno de emulación o prueba
    _registerPlanRepository(container);
    _registerUserRepository(container);
    _registerChatRepository(container);
    _registerApplicationRepository(container);

    _logger.d(
      'Dependencias de prueba para repositorios registradas correctamente',
    );
  }
}
