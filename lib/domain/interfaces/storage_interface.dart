// lib/services/interfaces/storage_interface.dart
abstract class StorageInterface {
  Future<void> saveMetric(final String city, final bool wasEnabled);
  Future<Map<String, int>> getMetrics(final String city);
}
