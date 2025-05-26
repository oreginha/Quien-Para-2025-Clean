// lib/core/storage/offline_manager.dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/network_helper.dart';

/// Clase para gestionar el modo offline-first y cacheo de datos
class OfflineManager {
  final SharedPreferences _prefs;
  final NetworkHelper _networkHelper;
  static const String _cachePrefix = 'cache_';
  static const Duration _defaultExpiry = Duration(hours: 12);

  // Stream para notificar cambios en el estado de conexión
  final _connectionStatusController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  // Estado actual de la conexión
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  OfflineManager(this._prefs, this._networkHelper) {
    // Suscribirse a cambios de conectividad
    _networkHelper.connectivityStream.listen((result) {
      _isOnline =
          result.isNotEmpty && !result.contains(ConnectivityResult.none);
      _connectionStatusController.add(_isOnline);

      if (_isOnline && kDebugMode) {
        if (kDebugMode) {
          print('📱 Dispositivo en línea - activando sincronización');
        }
      } else if (kDebugMode) {
        print('📵 Dispositivo sin conexión - activando modo offline');
      }
    });
  }

  /// Guarda datos en la caché con un tiempo de expiración
  Future<bool> saveToCache(String key, dynamic data, {Duration? expiry}) async {
    try {
      final Map<String, dynamic> cacheData = {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expiry': (expiry ?? _defaultExpiry).inMilliseconds,
      };

      return await _prefs.setString('$_cachePrefix$key', jsonEncode(cacheData));
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al guardar en caché: $e');
      }
      return false;
    }
  }

  /// Obtiene datos de la caché si están disponibles y no han expirado
  T? getFromCache<T>(String key) {
    try {
      final String? cachedData = _prefs.getString('$_cachePrefix$key');

      if (cachedData == null) return null;

      final Map<String, dynamic> cacheMap = jsonDecode(cachedData);
      final int timestamp = cacheMap['timestamp'] ?? 0;
      final int expiryMs = cacheMap['expiry'] ?? _defaultExpiry.inMilliseconds;

      // Verificar si los datos han expirado
      final bool isExpired =
          DateTime.now().millisecondsSinceEpoch - timestamp > expiryMs;

      if (isExpired) {
        // Borrar datos expirados
        _prefs.remove('$_cachePrefix$key');
        return null;
      }

      return cacheMap['data'] as T?;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al leer caché: $e');
      }
      return null;
    }
  }

  /// Obtiene datos con estrategia offline-first: primero intenta
  /// la caché, y si no hay datos o están expirados, llama al fetcher remoto
  Future<T?> getData<T>({
    required String key,
    required Future<T?> Function() remoteFetcher,
    Duration? expiry,
    bool forceRefresh = false,
  }) async {
    // Si no se fuerza la actualización, intentar obtener de la caché primero
    if (!forceRefresh) {
      final T? cachedData = getFromCache<T>(key);

      if (cachedData != null) {
        if (kDebugMode) {
          print('🔄 Datos obtenidos de caché para: $key');
        }
        return cachedData;
      }
    }

    // Si hay conexión o se fuerza la actualización, obtener datos remotos
    if (_isOnline || forceRefresh) {
      try {
        final T? remoteData = await remoteFetcher();

        if (remoteData != null) {
          // Guardar en caché para uso futuro offline
          await saveToCache(key, remoteData, expiry: expiry);

          if (kDebugMode) {
            print('🔄 Datos actualizados desde API para: $key');
          }
        }

        return remoteData;
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error al obtener datos remotos: $e');
        }

        // En caso de error, intentar la caché como fallback
        return getFromCache<T>(key);
      }
    } else {
      // Sin conexión y sin datos en caché
      if (kDebugMode) {
        print('⚠️ Sin conexión y sin datos en caché para: $key');
      }
      return null;
    }
  }

  /// Borra un elemento específico de la caché
  Future<bool> clearCacheItem(String key) async {
    return await _prefs.remove('$_cachePrefix$key');
  }

  /// Limpia todos los datos en caché
  Future<bool> clearAllCache() async {
    try {
      final List<String> keys = _prefs
          .getKeys()
          .where((key) => key.startsWith(_cachePrefix))
          .toList();

      for (final String key in keys) {
        await _prefs.remove(key);
      }

      if (kDebugMode) {
        print('✅ Caché limpiada correctamente (${keys.length} elementos)');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al limpiar caché: $e');
      }
      return false;
    }
  }

  /// Limpia los datos de caché expirados
  Future<int> clearExpiredCache() async {
    try {
      final List<String> keys = _prefs
          .getKeys()
          .where((key) => key.startsWith(_cachePrefix))
          .toList();

      int removedCount = 0;

      for (final String key in keys) {
        final String? cachedData = _prefs.getString(key);
        if (cachedData == null) continue;

        try {
          final Map<String, dynamic> cacheMap = jsonDecode(cachedData);
          final int timestamp = cacheMap['timestamp'] ?? 0;
          final int expiryMs =
              cacheMap['expiry'] ?? _defaultExpiry.inMilliseconds;

          final bool isExpired =
              DateTime.now().millisecondsSinceEpoch - timestamp > expiryMs;

          if (isExpired) {
            await _prefs.remove(key);
            removedCount++;
          }
        } catch (e) {
          // Si hay error al decodificar, eliminar el registro corrupto
          await _prefs.remove(key);
          removedCount++;
        }
      }

      if (kDebugMode && removedCount > 0) {
        print(
          '🧹 Limpieza de caché: $removedCount elementos expirados eliminados',
        );
      }

      return removedCount;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al limpiar caché expirada: $e');
      }
      return 0;
    }
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
