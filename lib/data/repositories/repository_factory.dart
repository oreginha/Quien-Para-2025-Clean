// lib/data/repositories/repository_factory.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/core/services/notification_api_service.dart';
import 'package:quien_para/core/services/planes_api_service.dart';
import 'package:quien_para/core/utils/firestore_pool.dart';
import 'package:quien_para/data/datasources/local/cache_interface.dart';
import 'package:quien_para/data/datasources/local/notification_cache.dart';
import 'package:quien_para/data/datasources/local/plan_cache.dart';
import 'package:quien_para/data/datasources/local/user_cache.dart'
    as local_cache;
import 'package:quien_para/data/mappers/mapper_factory.dart';
import 'package:quien_para/data/mappers/notification_mapper.dart';
import 'package:quien_para/data/repositories/notification/notification_repository_impl.dart';
import 'package:quien_para/data/repositories/plan/plan_repository_impl.dart';
import 'package:quien_para/domain/entities/entity_base.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/repositories/notification/notification_repository.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/repositories/repository_base.dart';

/// Factoría para crear instancias de repositorios.
///
/// Proporciona un punto centralizado para la creación, inicialización y gestión
/// de repositorios. Facilita la inyección de dependencias y mejora la testabilidad.

class RepositoryFactory {
  // Instancia singleton
  static final RepositoryFactory _instance = RepositoryFactory._internal();

  // Fábrica para acceder a la instancia singleton
  factory RepositoryFactory() => _instance;

  // Firestore pool para compartir conexiones
  late final FirestorePool _firestorePool;

  // Factoría de mappers
  final MapperFactory _mapperFactory = MapperFactory();

  // Caché de repositorios para reutilización
  final Map<Type, RepositoryBase<dynamic>> _repositories = {};

  // Caché de cache managers para reutilización
  final Map<Type, Cache<dynamic>> _caches = {};

  // Constructor interno privado para el singleton
  RepositoryFactory._internal() {
    _firestorePool = FirestorePool();
    // Inicializar el pool con 3 conexiones máximas
    _firestorePool.initialize(maxConnections: 3);
  }

  /// Obtiene una instancia de NotificationRepository.
  ///
  /// Si ya existe una instancia, la retorna desde la caché.
  /// En caso contrario, crea y configura una nueva instancia.
  Object getNotificationRepository() {
    if (_repositories.containsKey(NotificationEntity)) {
      return _repositories[NotificationEntity] as NotificationRepository;
    }

    // Obtener el mapper de notificaciones
    final NotificationMapper mapper = _mapperFactory.getNotificationMapper();

    // Obtener o crear la caché
    final NotificationCache cache = _getNotificationCache();

    // Crear el servicio API
    final notificationApiService =
        NotificationApiService(); // Asegúrate de tener este servicio

    // Crear e inicializar el repositorio con Firestore de pooling
    final repo = NotificationRepositoryImpl(
      firestore: FirebaseFirestore
          .instance, // Por ahora usamos la instancia directa, actualizaremos esto
      apiService: notificationApiService,
      cache: cache,
      mapper: mapper,
    );

    // Almacenar en caché para futuras solicitudes
    _repositories[NotificationEntity] = repo as RepositoryBase;

    return repo;
  }

  /// Obtiene o crea una instancia de caché para notificaciones.
  NotificationCache _getNotificationCache() {
    if (_caches.containsKey(NotificationEntity)) {
      return _caches[NotificationEntity] as NotificationCache;
    }

    // Crear instancia de caché
    final cache = NotificationCache();
    cache.init();

    // Almacenar en caché para futuras solicitudes
    _caches[NotificationEntity] = cache;

    return cache;
  }

  /// Obtiene una instancia de PlanRepository.
  ///
  /// Si ya existe una instancia, la retorna desde la caché.
  /// En caso contrario, crea y configura una nueva instancia.
  PlanRepository getPlanRepository() {
    if (_repositories.containsKey(PlanEntity)) {
      return _repositories[PlanEntity] as PlanRepository;
    }

    // Crear el user cache
    final userCache = local_cache.UserCache();
    userCache.init();

    // Crear el servicio API
    final apiService = PlanApiService();

    // Crear e inicializar el repositorio
    final repo = PlanRepositoryImpl(
      apiService,
      firestore: FirebaseFirestore.instance,
      storage: FirebaseStorage.instance,
      auth: FirebaseAuth.instance,
      cache: userCache,
      logger: Logger(),
      mapper: _mapperFactory.getUserMapper(),
    );

    // Almacenar en caché para futuras solicitudes
    _repositories[PlanEntity] = repo;

    return repo;
  }

  /// Obtiene o crea una instancia de caché para planes.
  Cache<PlanEntity> _getPlanCache() {
    if (_caches.containsKey(PlanEntity)) {
      return _caches[PlanEntity] as Cache<PlanEntity>;
    }

    // Crear instancia de caché
    final cache = PlanCache(mapper: _mapperFactory.getPlanMapper());

    // Inicializar caché
    cache.init();

    // Almacenar en caché para futuras solicitudes
    _caches[PlanEntity] = cache;

    return cache;
  }

  /// Registra un repositorio personalizado para un tipo específico.
  ///
  /// Útil para pruebas cuando se necesita reemplazar un repositorio con un mock.
  void registerRepository<E extends EntityBase, R extends RepositoryBase<E>>(
      R repository) {
    _repositories[E] = repository;
  }

  /// Registra una caché personalizada para un tipo específico.
  ///
  /// Útil para pruebas cuando se necesita reemplazar una caché con un mock.
  void registerCache<E extends EntityBase>(Cache<E> cache) {
    _caches[E] = cache;
  }

  /// Libera los recursos de todos los repositorios.
  ///
  /// Útil para limpiar la memoria cuando ya no se necesitan los repositorios.
  Future<void> dispose() async {
    // Liberar recursos de todos los repositorios
    for (final repo in _repositories.values) {
      await repo.dispose();
    }

    // Cerrar el pool de Firestore
    await _firestorePool.close();

    // Limpiar caché
    _repositories.clear();
    _caches.clear();
  }
}
