// lib/services/interfaces/analytics_interface.dart

abstract class AnalyticsInterface {
  Future<void> trackCitySelection(String city, bool isEnabled);
  Future<Map<String, Map<String, int>>> getMetrics();
  Future<void> saveToFirebase();
}