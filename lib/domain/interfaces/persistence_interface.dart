// lib/services/interfaces/persistence_interface.dart

abstract class PersistenceInterface {
  Future<void> savePendingMetric(String city, bool wasEnabled);
  Future<List<Map<String, dynamic>>> getPendingMetrics();
}
