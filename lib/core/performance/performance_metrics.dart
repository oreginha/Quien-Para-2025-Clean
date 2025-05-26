// lib/core/performance/performance_metrics.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:quien_para/core/logger/logger.dart';

/// Clase para medir y registrar métricas de rendimiento de la aplicación
/// Permite comparar el rendimiento antes y después de las optimizaciones
class PerformanceMetrics {
  // Singleton
  static final PerformanceMetrics _instance = PerformanceMetrics._internal();
  factory PerformanceMetrics() => _instance;
  PerformanceMetrics._internal();

  // Mapa para almacenar métricas
  final Map<String, Map<String, dynamic>> _metrics = {};

  // Lista de operaciones cronometradas en curso
  final Map<String, Stopwatch> _timers = {};

  // Control de inicialización
  bool _initialized = false;

  // Archivo para métricas persistentes
  File? _metricsFile;

  // Datos históricos
  final Map<String, List<Map<String, dynamic>>> _historicalData = {};

  /// Inicializar el sistema de métricas
  Future<void> init() async {
    if (_initialized) return;

    try {
      // Inicializar archivo para persistencia
      final appDir = await getApplicationDocumentsDirectory();
      _metricsFile = File('${appDir.path}/performance_metrics.json');

      // Cargar datos históricos si existen
      if (await _metricsFile!.exists()) {
        final jsonStr = await _metricsFile!.readAsString();
        final dynamic data = jsonDecode(jsonStr);

        if (data is Map<String, dynamic>) {
          data.forEach((key, value) {
            if (value is List) {
              _historicalData[key] = List<Map<String, dynamic>>.from(
                value.map((item) => Map<String, dynamic>.from(item as Map)),
              );
            }
          });
        }
      }

      _initialized = true;
      logger.d('PerformanceMetrics inicializado correctamente');
    } catch (e) {
      logger.e('Error inicializando PerformanceMetrics', error: e);
    }
  }

  /// Iniciar medición de tiempo para una operación
  void startTimer(String operationName) {
    if (!_initialized) return;

    final stopwatch = Stopwatch()..start();
    _timers[operationName] = stopwatch;
  }

  /// Detener la medición de tiempo e incluir el resultado en las métricas
  void stopTimer(String operationName) {
    if (!_initialized || !_timers.containsKey(operationName)) return;

    final stopwatch = _timers[operationName]!;
    stopwatch.stop();

    // Guardar tiempo en ms
    recordMetric(operationName, 'duration_ms', stopwatch.elapsedMilliseconds);

    _timers.remove(operationName);
  }

  /// Registrar una métrica específica
  void recordMetric(String category, String name, dynamic value) {
    if (!_initialized) return;

    _metrics[category] ??= {};
    _metrics[category]![name] = value;

    // Para métricas que requieren promedio o acumulación
    if (value is num) {
      _metrics[category]!['${name}_count'] =
          (_metrics[category]!['${name}_count'] as num? ?? 0) + 1;

      _metrics[category]!['${name}_total'] =
          (_metrics[category]!['${name}_total'] as num? ?? 0) + value;

      _metrics[category]!['${name}_avg'] =
          _metrics[category]!['${name}_total'] /
          _metrics[category]!['${name}_count'];
    }
  }

  /// Obtener todas las métricas
  Map<String, Map<String, dynamic>> getAllMetrics() {
    return Map.from(_metrics);
  }

  /// Obtener métricas para una categoría específica
  Map<String, dynamic>? getMetricsForCategory(String category) {
    return _metrics[category] != null ? Map.from(_metrics[category]!) : null;
  }

  /// Reiniciar las métricas (mantiene los datos históricos)
  void resetMetrics() {
    // Guardar histórico antes de reiniciar
    saveCurrentMetricsAsHistorical();
    _metrics.clear();
    _timers.clear();
  }

  /// Guardar las métricas actuales como históricas
  void saveCurrentMetricsAsHistorical() {
    if (!_initialized) return;

    final timestamp = DateTime.now().toIso8601String();

    _metrics.forEach((category, metrics) {
      _historicalData[category] ??= [];

      final snapshot = Map<String, dynamic>.from(metrics);
      snapshot['timestamp'] = timestamp;

      _historicalData[category]!.add(snapshot);
    });

    // Persistir datos
    _persistMetrics();
  }

  /// Persistir métricas en archivo local
  Future<void> _persistMetrics() async {
    if (!_initialized || _metricsFile == null) return;

    try {
      final jsonData = jsonEncode(_historicalData);
      await _metricsFile!.writeAsString(jsonData);
    } catch (e) {
      logger.e('Error guardando métricas', error: e);
    }
  }

  /// Obtener comparación entre antes y después de optimizaciones
  Map<String, dynamic> getComparison(
    String category, {
    int beforeCount = 5, // Número de muestras anteriores
    int afterCount = 5, // Número de muestras recientes
  }) {
    if (!_initialized || !_historicalData.containsKey(category)) {
      return {'available': false};
    }

    final data = _historicalData[category]!;
    if (data.length < beforeCount + afterCount) {
      return {'available': false};
    }

    // Obtener datos para comparación
    final beforeData = data.sublist(0, beforeCount);
    final afterData = data.sublist(data.length - afterCount);

    final comparison = <String, dynamic>{
      'available': true,
      'metrics': <String, dynamic>{},
    };

    // Crear conjunto de todas las métricas disponibles
    final Set<String> allMetrics = {};
    for (final entry in [...beforeData, ...afterData]) {
      allMetrics.addAll(entry.keys.where((k) => k != 'timestamp'));
    }

    // Comparar cada métrica
    for (final metric in allMetrics) {
      // Solo comparar valores numéricos
      final beforeValues = beforeData
          .where((d) => d.containsKey(metric) && d[metric] is num)
          .map((d) => d[metric] as num)
          .toList();

      final afterValues = afterData
          .where((d) => d.containsKey(metric) && d[metric] is num)
          .map((d) => d[metric] as num)
          .toList();

      if (beforeValues.isNotEmpty && afterValues.isNotEmpty) {
        final beforeAvg =
            beforeValues.reduce((a, b) => a + b) / beforeValues.length;
        final afterAvg =
            afterValues.reduce((a, b) => a + b) / afterValues.length;

        final percentChange = ((afterAvg - beforeAvg) / beforeAvg) * 100;

        comparison['metrics'][metric] = {
          'before': beforeAvg,
          'after': afterAvg,
          'change': afterAvg - beforeAvg,
          'percent_change': percentChange,
          'improved': percentChange < 0 ? true : false,
        };
      }
    }

    return comparison;
  }

  /// Exportar métricas para análisis
  Future<String?> exportMetricsToFile() async {
    if (!_initialized) return null;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final exportFile = File('${appDir.path}/metrics_export_$timestamp.json');

      final exportData = {
        'current': _metrics,
        'historical': _historicalData,
        'export_timestamp': DateTime.now().toIso8601String(),
        'app_version': '1.0.0', // Idealmente obtenido dinámicamente
      };

      final jsonData = jsonEncode(exportData);
      await exportFile.writeAsString(jsonData);

      return exportFile.path;
    } catch (e) {
      logger.e('Error exportando métricas', error: e);
      return null;
    }
  }
}

/// Extension para medir el rendimiento de funciones
extension PerformanceMeasurement<T> on Future<T> {
  /// Medir el rendimiento de una función asíncrona
  Future<T> measured(String operationName) {
    final metrics = PerformanceMetrics();
    metrics.startTimer(operationName);

    return then((value) {
      metrics.stopTimer(operationName);
      return value;
    }).catchError((error) {
      metrics.stopTimer(operationName);
      throw error; // Usar throw en lugar de Future.error para respetar el tipo de retorno
    });
  }
}
