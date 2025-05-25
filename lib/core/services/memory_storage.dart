import '../../domain/interfaces/storage_interface.dart';

class MemoryStorage implements StorageInterface {
  final Map<String, Map<String, int>> _metrics = <String, Map<String, int>>{};

  @override
  Future<void> saveMetric(final String city, final bool wasEnabled) async {
    if (!_metrics.containsKey(city)) {
      _metrics[city] = <String, int>{
        'totalAttempts': 0,
        'successfulSelections': 0,
        'rejectedSelections': 0,
      };
    }

    _metrics[city]!['totalAttempts'] =
        (_metrics[city]!['totalAttempts'] ?? 0) + 1;
    if (wasEnabled) {
      _metrics[city]!['successfulSelections'] =
          (_metrics[city]!['successfulSelections'] ?? 0) + 1;
    } else {
      _metrics[city]!['rejectedSelections'] =
          (_metrics[city]!['rejectedSelections'] ?? 0) + 1;
    }
  }

  @override
  Future<Map<String, int>> getMetrics(final String city) async {
    return Map<String, int>.from(_metrics[city] ?? <String, dynamic>{});
  }

  // Método auxiliar para testing
  void clear() {
    _metrics.clear();
  }
}
