// lib/core/utils/firestore_pool.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/core/utils/resource_pool.dart';
import 'package:quien_para/core/logger/logger.dart';

/// Un pool de conexiones para Firestore que evita crear demasiadas instancias.
///
/// En lugar de crear una nueva instancia de Firestore cada vez que se necesita,
/// esta clase gestiona un pool de conexiones que pueden ser reutilizadas.
class FirestorePool {
  // Instancia única (patrón Singleton)
  static final FirestorePool _instance = FirestorePool._internal();

  factory FirestorePool() => _instance;

  FirestorePool._internal();

  // El pool de recursos
  late final ResourcePool<FirebaseFirestore> _pool;

  // Indica si el pool ha sido inicializado
  bool _isInitialized = false;

  /// Inicializa el pool con una capacidad máxima.
  ///
  /// Debe llamarse antes de usar el pool. La capacidad máxima determina
  /// cuántas conexiones a Firestore pueden estar activas simultáneamente.
  Future<void> initialize({
    int maxConnections = 3,
    Duration idleTimeout = const Duration(minutes: 10),
  }) async {
    if (_isInitialized) return;

    _pool = ResourcePool<FirebaseFirestore>(
      factory: () async {
        logger.d('FirestorePool: Creando nueva instancia de Firestore');
        return FirebaseFirestore.instance;
      },
      validator: (firestore) async {
        // Verificar si la instancia de Firestore sigue siendo válida
        try {
          await firestore.collection('_test_connection').limit(1).get();
          return true;
        } catch (e) {
          logger.e('FirestorePool: Conexión inválida', error: e);
          return false;
        }
      },
      cleanup: (firestore) async {
        // No hay un método para "cerrar" Firestore,
        // pero podríamos limpiar caches o realizar otras tareas aquí
        logger.d('FirestorePool: Limpiando instancia de Firestore');
      },
      maxSize: maxConnections,
      idleTimeout: idleTimeout,
    );

    _isInitialized = true;
    logger.d(
      'FirestorePool inicializado con $maxConnections conexiones máximas',
    );
  }

  /// Obtiene una instancia de Firestore del pool.
  ///
  /// La instancia debe ser devuelta al pool llamando a [release] cuando ya no se necesite.
  Future<FirebaseFirestore> acquire() async {
    _ensureInitialized();
    return _pool.acquire();
  }

  /// Devuelve una instancia de Firestore al pool.
  ///
  /// Esto permite que la instancia sea reutilizada por otras partes de la aplicación.
  Future<void> release(FirebaseFirestore firestore) async {
    _ensureInitialized();
    await _pool.release(firestore);
  }

  /// Cierra el pool y libera todos los recursos.
  ///
  /// Normalmente se llama cuando la aplicación se cierra.
  Future<void> close() async {
    if (!_isInitialized) return;

    await _pool.close();
    _isInitialized = false;
    logger.d('FirestorePool cerrado');
  }

  /// Comprueba que el pool esté inicializado antes de usarlo.
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'FirestorePool no ha sido inicializado. Llame a initialize() primero.',
      );
    }
  }

  /// Obtiene estadísticas del estado actual del pool.
  Map<String, dynamic> getStats() {
    _ensureInitialized();
    return _pool.getStats();
  }

  /// Un método de utilidad para ejecutar operaciones en Firestore sin tener que
  /// gestionar manualmente la adquisición y liberación de instancias.
  ///
  /// Ejemplo de uso:
  /// ```dart
  /// final documents = await FirestorePool().withFirestore((firestore) async {
  ///   return await firestore.collection('users').get();
  /// });
  /// ```
  Future<T> withFirestore<T>(
    Future<T> Function(FirebaseFirestore firestore) operation,
  ) async {
    final firestore = await acquire();
    try {
      return await operation(firestore);
    } finally {
      await release(firestore);
    }
  }
}
