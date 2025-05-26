// lib/core/utils/resource_manager.dart

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/core/utils/firestore_pool.dart';
import 'package:quien_para/core/logger/logger.dart';

/// Clase que gestiona los recursos compartidos de la aplicación.
///
/// Proporciona acceso centralizado a recursos como el pool de conexiones de Firestore,
/// y garantiza la correcta inicialización y limpieza de estos recursos.
class ResourceManager {
  // Instancia única (patrón Singleton)
  static final ResourceManager _instance = ResourceManager._internal();

  factory ResourceManager() => _instance;

  ResourceManager._internal();

  // Pool de conexiones para Firestore
  late final FirestorePool _firestorePool;

  // Indica si se ha inicializado
  bool _isInitialized = false;

  /// Inicializa el gestor de recursos y todos los recursos compartidos.
  ///
  /// Este método debe llamarse al inicio de la aplicación, antes de que se
  /// intente acceder a cualquier recurso compartido.
  Future<void> initialize() async {
    if (_isInitialized) return;

    _firestorePool = FirestorePool();
    await _firestorePool.initialize(maxConnections: 5);

    _isInitialized = true;
    logger.d('ResourceManager inicializado correctamente');
  }

  /// Obtiene el pool de Firestore.
  ///
  /// Si el gestor no ha sido inicializado, lanza una excepción.
  FirestorePool get firestorePool {
    _ensureInitialized();
    return _firestorePool;
  }

  /// Comprueba que el gestor esté inicializado antes de usarlo.
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'ResourceManager no ha sido inicializado. Llame a initialize() primero.',
      );
    }
  }

  /// Ejecuta una operación con una instancia de Firestore del pool.
  ///
  /// Automatiza la adquisición y liberación de la instancia.
  ///
  /// Ejemplo de uso:
  /// ```dart
  /// final documents = await ResourceManager().withFirestore((firestore) async {
  ///   return await firestore.collection('users').get();
  /// });
  /// ```
  Future<T> withFirestore<T>(
    Future<T> Function(FirebaseFirestore firestore) operation,
  ) async {
    _ensureInitialized();
    return _firestorePool.withFirestore(operation);
  }

  /// Limpia todos los recursos compartidos.
  ///
  /// Debe llamarse cuando la aplicación se cierra.
  Future<void> dispose() async {
    if (!_isInitialized) return;

    await _firestorePool.close();

    _isInitialized = false;
    logger.d('ResourceManager: Todos los recursos liberados');
  }

  /// Obtiene estadísticas de los recursos.
  Map<String, dynamic> getStats() {
    if (!_isInitialized) {
      return {'initialized': false};
    }

    return {'initialized': true, 'firestorePool': _firestorePool.getStats()};
  }
}
