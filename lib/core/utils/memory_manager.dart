// memory_manager.dart
// ignore_for_file: always_specify_types, unnecessary_null_comparison

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Clase que gestiona el uso de memoria en la aplicación
/// para evitar fugas de memoria y reducir la presión sobre el GC
class MemoryManager {
  // Singleton
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  // Seguimiento del estado actual del ciclo de vida de la aplicación
  AppLifecycleState _currentAppState = AppLifecycleState.resumed;

  // Período para programar limpiezas periódicas
  final Duration _cleanupInterval = const Duration(minutes: 5);
  Timer? _cleanupTimer;

  // Registro de uso de memoria (solo en debug)
  final List<String> _memoryLog = <String>[];

  // Iniciar el administrador de memoria
  void initialize() {
    if (kDebugMode) {
      print('🧠 [MemoryManager] Inicializando administrador de memoria');
    }

    // Programar limpieza periódica
    _setupPeriodicCleanup();

    // Registrar listeners para eventos de ciclo de vida
    _setupAppLifecycleListeners();
  }

  // Configurar limpieza periódica con intervalo más largo
  void _setupPeriodicCleanup() {
    _cleanupTimer?.cancel();
    // Aumentar el intervalo para reducir la frecuencia de limpieza
    _cleanupTimer = Timer.periodic(_cleanupInterval, (_) {
      // Solo ejecutar la limpieza si la app está en primer plano
      if (_currentAppState == AppLifecycleState.resumed) {
        if (kDebugMode) {
          print('📡 [MemoryManager] Ejecutando limpieza programada');
        }
        performCleanup(
            aggressive: false); // Nunca usar limpieza agresiva automáticamente
      } else if (kDebugMode) {
        print(
            '📡 [MemoryManager] Omitiendo limpieza programada (app en segundo plano)');
      }
    });
  }

  // Configurar escucha de eventos de ciclo de vida
  void _setupAppLifecycleListeners() {
    final WidgetsBinding binding = WidgetsBinding.instance;

    binding.addObserver(
      _AppLifecycleObserver(
        onStateChanged: (AppLifecycleState state) {
          _currentAppState = state;

          if (state == AppLifecycleState.paused) {
            // La app se fue a segundo plano, liberar memoria no esencial
            performCleanup(aggressive: true);
          } else if (state == AppLifecycleState.resumed) {
            // La app volvió a primer plano
            // Reiniciar contador de limpieza periódica
            _setupPeriodicCleanup();
          }
        },
      ),
    );
  }

  // Programar una limpieza para ejecutarse después de cierto tiempo
  void scheduleCleanup({
    Duration delay = const Duration(seconds: 30),
    bool aggressive = false,
  }) {
    if (kDebugMode) {
      print('🕒 [MemoryManager] Programando limpieza para dentro de ${delay.inSeconds}s');
    }
    
    // Cancelar cualquier limpieza programada anteriormente
    _cleanupTimer?.cancel();
    
    // Programar la nueva limpieza
    _cleanupTimer = Timer(delay, () {
      performCleanup(aggressive: aggressive);
    });
  }

  // Realizar limpieza de memoria
  void performCleanup({bool aggressive = false}) {
    if (kDebugMode) {
      print(
          '🧹 [MemoryManager] Realizando limpieza de memoria${aggressive ? " agresiva" : ""}');
    }

    try {
      // Limpiar caché de imágenes de manera segura
      _clearImageCache(aggressive);

      // Registrar la limpieza
      _logMemoryUsage('Limpieza ${aggressive ? "agresiva" : "normal"}');
    } catch (e) {
      if (kDebugMode) {
        print('❌ [MemoryManager] Error durante limpieza de memoria: $e');
      }
    }
  }

  // Limpiar caché de imágenes de manera segura
  void _clearImageCache(bool aggressive) {
    try {
      // Verificar si PaintingBinding está inicializado
      if (PaintingBinding.instance != null) {
        final ImageCache imageCache = PaintingBinding.instance.imageCache;

        if (aggressive) {
          // Eliminar todas las imágenes en caché pero de manera segura
          imageCache.clear();
          // Usar operación más segura para imágenes activas
          if (kDebugMode) {
            print('🧹 [MemoryManager] Limpiando caché de imágenes');
          }
        } else {
          // Solo reducir el tamaño del caché (operación más segura)
          imageCache.maximumSize = 50;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ [MemoryManager] Error al limpiar caché de imágenes: $e');
      }
    }
  }

  // Registrar el uso de memoria
  void _logMemoryUsage(String action) {
    if (kDebugMode) {
      final String timestamp = DateTime.now().toString();
      final String entry = '[$timestamp] $action';
      _memoryLog.add(entry);

      // Limitar el tamaño del log
      if (_memoryLog.length > 100) {
        _memoryLog.removeAt(0);
      }
    }
  }

  // Obtener registro de uso de memoria
  List<String> getMemoryLog() => List.unmodifiable(_memoryLog);

  // Liberar recursos cuando ya no se necesiten
  void dispose() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    _memoryLog.clear();
  }
}

/// Observador de ciclo de vida para la aplicación
class _AppLifecycleObserver extends WidgetsBindingObserver {
  final Function(AppLifecycleState) onStateChanged;

  _AppLifecycleObserver({
    required this.onStateChanged,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onStateChanged(state);
  }
}
