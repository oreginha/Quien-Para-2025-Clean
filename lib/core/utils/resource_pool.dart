// lib/core/utils/resource_pool.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:quien_para/core/logger/logger.dart';

/// Una implementación genérica de un pool de recursos.
///
/// Permite administrar recursos costosos como conexiones a bases de datos
/// o servicios externos, limitando la cantidad de instancias simultáneas
/// y reutilizándolas cuando sea posible.
class ResourcePool<T> {
  /// Función que crea un nuevo recurso
  final Future<T> Function() _factory;

  /// Función opcional para validar si un recurso sigue siendo válido
  final Future<bool> Function(T resource)? _validator;

  /// Función opcional para limpiar un recurso antes de liberarlo
  final Future<void> Function(T resource)? _cleanup;

  /// Capacidad máxima del pool
  final int _maxSize;

  /// Tiempo de espera antes de cerrar recursos inactivos
  final Duration _idleTimeout;

  /// Lista de recursos disponibles
  final List<_PooledResource<T>> _available = [];

  /// Lista de recursos en uso
  final List<_PooledResource<T>> _inUse = [];

  /// Cola de solicitudes pendientes
  final List<Completer<T>> _waiting = [];

  /// Timer para limpiar recursos inactivos
  Timer? _cleanupTimer;

  /// Flag para marcar si el pool está cerrado
  bool _isClosed = false;

  ResourcePool({
    required Future<T> Function() factory,
    Future<bool> Function(T resource)? validator,
    Future<void> Function(T resource)? cleanup,
    int maxSize = 5,
    Duration idleTimeout = const Duration(minutes: 5),
  }) : _factory = factory,
       _validator = validator,
       _cleanup = cleanup,
       _maxSize = maxSize,
       _idleTimeout = idleTimeout {
    // Iniciar timer de limpieza
    _cleanupTimer = Timer.periodic(
      _idleTimeout,
      (_) => _cleanupIdleResources(),
    );
  }

  /// Obtiene un recurso del pool.
  ///
  /// Si hay recursos disponibles, retorna uno inmediatamente.
  /// Si no hay recursos disponibles pero no se ha alcanzado el límite, crea uno nuevo.
  /// Si se ha alcanzado el límite, espera hasta que un recurso sea liberado.
  Future<T> acquire() async {
    if (_isClosed) {
      throw StateError('ResourcePool está cerrado');
    }

    // Verificar si hay recursos disponibles
    if (_available.isNotEmpty) {
      final resource = _available.removeLast();

      // Verificar si el recurso sigue siendo válido
      if (_validator != null) {
        final isValid = await _validator!(resource.value);
        if (!isValid) {
          // Si no es válido, descartar y crear uno nuevo
          await _disposeResource(resource);
          return await _createAndAcquireResource();
        }
      }

      // Actualizar timestamps y mover a la lista de en uso
      resource.lastUsed = DateTime.now();
      _inUse.add(resource);

      return resource.value;
    }

    // Si no hay recursos disponibles, verificar si podemos crear uno nuevo
    if (_inUse.length < _maxSize) {
      return await _createAndAcquireResource();
    }

    // Si hemos alcanzado el límite, esperar a que se libere un recurso
    final completer = Completer<T>();
    _waiting.add(completer);
    return completer.future;
  }

  /// Crea un nuevo recurso y lo marca como en uso.
  Future<T> _createAndAcquireResource() async {
    try {
      final value = await _factory();
      final resource = _PooledResource<T>(
        value,
        DateTime.now(),
        DateTime.now(),
      );
      _inUse.add(resource);
      return value;
    } catch (e) {
      logger.e('Error creando recurso en el pool', error: e);
      rethrow;
    }
  }

  /// Libera un recurso para que pueda ser reutilizado.
  Future<void> release(T resource) async {
    if (_isClosed) {
      // Si el pool está cerrado, simplemente destruir el recurso
      await _cleanup?.call(resource);
      return;
    }

    // Buscar el recurso en la lista de en uso
    final index = _inUse.indexWhere((r) => identical(r.value, resource));
    if (index < 0) {
      logger.w('Se intenta liberar un recurso que no pertenece al pool');
      return;
    }

    final pooledResource = _inUse.removeAt(index);

    // Si hay alguien esperando, darle este recurso inmediatamente
    if (_waiting.isNotEmpty) {
      final completer = _waiting.removeAt(0);
      pooledResource.lastUsed = DateTime.now();
      _inUse.add(pooledResource);
      completer.complete(resource);
      return;
    }

    // Actualizar timestamp y mover a la lista de disponibles
    pooledResource.lastReleased = DateTime.now();
    _available.add(pooledResource);

    // Log de estado del pool
    if (kDebugMode) {
      final availableCount = _available.length;
      final inUseCount = _inUse.length;
      final waitingCount = _waiting.length;
      logger.d(
        'ResourcePool: $availableCount disponibles, $inUseCount en uso, $waitingCount esperando',
      );
    }
  }

  /// Limpia recursos que han estado inactivos por más del timeout.
  Future<void> _cleanupIdleResources() async {
    if (_isClosed) return;

    final now = DateTime.now();
    final idleResources = _available
        .where((r) => now.difference(r.lastReleased) > _idleTimeout)
        .toList();

    // Remover recursos inactivos de la lista de disponibles
    _available.removeWhere((r) => idleResources.contains(r));

    // Limpiar cada recurso
    for (final resource in idleResources) {
      await _disposeResource(resource);
    }

    if (idleResources.isNotEmpty && kDebugMode) {
      logger.d(
        'ResourcePool: Limpiados ${idleResources.length} recursos inactivos',
      );
    }
  }

  /// Destruye un recurso específico.
  Future<void> _disposeResource(_PooledResource<T> resource) async {
    try {
      if (_cleanup != null) {
        await _cleanup!(resource.value);
      }
    } catch (e) {
      logger.e('Error limpiando recurso', error: e);
    }
  }

  /// Cierra el pool y libera todos los recursos.
  Future<void> close() async {
    if (_isClosed) return;

    _isClosed = true;
    _cleanupTimer?.cancel();

    // Completar solicitudes pendientes con error
    for (final completer in _waiting) {
      completer.completeError(StateError('ResourcePool cerrado'));
    }
    _waiting.clear();

    // Limpiar todos los recursos
    final allResources = [..._available, ..._inUse];
    _available.clear();
    _inUse.clear();

    for (final resource in allResources) {
      await _disposeResource(resource);
    }

    logger.d('ResourcePool cerrado y todos los recursos liberados');
  }

  /// Retorna el estado actual del pool.
  Map<String, dynamic> getStats() {
    return {
      'available': _available.length,
      'inUse': _inUse.length,
      'waiting': _waiting.length,
      'total': _available.length + _inUse.length,
      'maxSize': _maxSize,
      'isClosed': _isClosed,
    };
  }
}

/// Clase que representa un recurso en el pool con metadatos.
class _PooledResource<T> {
  /// El recurso real
  final T value;

  /// Timestamp de la última vez que se usó
  DateTime lastUsed;

  /// Timestamp de la última vez que se liberó
  DateTime lastReleased;

  _PooledResource(this.value, this.lastUsed, this.lastReleased);
}
