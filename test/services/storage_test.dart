// test/services/storage_test.dart
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/core/services/memory_storage.dart';

void main() {
  late MemoryStorage storage;

  setUp(() {
    storage = MemoryStorage();
  });

  tearDown(() {
    storage.clear();
  });

  test('saveMetric should increment total attempts', () async {
    await storage.saveMetric('Test City', true);
    final Map<String, int> metrics = await storage.getMetrics('Test City');

    expect(metrics['totalAttempts'], 1);
  });

  test('saveMetric should track successful selections', () async {
    await storage.saveMetric('Test City', true);
    final Map<String, int> metrics = await storage.getMetrics('Test City');

    expect(metrics['successfulSelections'], 1);
    expect(metrics['rejectedSelections'], 0);
  });

  test('saveMetric should track rejected selections', () async {
    await storage.saveMetric('Test City', false);
    final Map<String, int> metrics = await storage.getMetrics('Test City');

    expect(metrics['successfulSelections'], 0);
    expect(metrics['rejectedSelections'], 1);
  });

  test('getMetrics should return empty map for non-existent city', () async {
    final Map<String, int> metrics = await storage.getMetrics(
      'Non Existent City',
    );
    expect(metrics, isEmpty);
  });

  test('should accumulate metrics for same city', () async {
    await storage.saveMetric('Test City', true);
    await storage.saveMetric('Test City', false);
    await storage.saveMetric('Test City', true);

    final Map<String, int> metrics = await storage.getMetrics('Test City');

    expect(metrics['totalAttempts'], 3);
    expect(metrics['successfulSelections'], 2);
    expect(metrics['rejectedSelections'], 1);
  });
}
