// lib/core/utils/data_loading/batch_loader.dart
import 'dart:async';

/// Clase para cargar datos en lotes (batches) para mejorar rendimiento
class BatchLoader {
  /// Timer para manejar retrasos entre operaciones en lote
  Timer? _batchTimer;

  /// Lista de operaciones pendientes
  final List<Function()> _pendingBatches = [];

  /// Retraso entre cargas de lotes para permitir agrupar operaciones
  final Duration _batchDelay;

  /// Constructor con parámetros opcionales
  BatchLoader({Duration? batchDelay})
    : _batchDelay = batchDelay ?? const Duration(milliseconds: 300);

  /// Programa un lote para carga después de un retraso
  ///
  /// Agrupa múltiples solicitudes para procesarlas juntas, mejorando
  /// el rendimiento al reducir el número de operaciones separadas.
  void scheduleBatch(Function() batchFunction) {
    _pendingBatches.add(batchFunction);

    // Cancelar cualquier timer existente
    _batchTimer?.cancel();

    // Crear un nuevo timer para procesar el lote después del retraso
    _batchTimer = Timer(_batchDelay, _processPendingBatches);
  }

  /// Programa un lote para ejecución inmediata sin esperar el retraso
  void executeImmediately(Function() batchFunction) {
    _pendingBatches.add(batchFunction);
    _processPendingBatches();
  }

  /// Procesa todos los lotes pendientes
  void _processPendingBatches() {
    // Copia la lista para evitar problemas de concurrencia
    final batches = List<Function()>.from(_pendingBatches);
    _pendingBatches.clear();

    // Ejecutar todos los lotes pendientes
    for (final batch in batches) {
      batch();
    }
  }

  /// Limpia todos los recursos
  void dispose() {
    _batchTimer?.cancel();
    _pendingBatches.clear();
  }

  /// Verifica si hay lotes pendientes
  bool get hasPendingBatches => _pendingBatches.isNotEmpty;

  /// Retorna el número de lotes pendientes
  int get pendingBatchesCount => _pendingBatches.length;
}
