import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/core/performance/performance_metrics.dart';

void main() {
  group('PerformanceMetrics', () {
    late PerformanceMetrics performanceMetrics;

    setUp(() {
      performanceMetrics = PerformanceMetrics();
    });

    tearDown(() {
      performanceMetrics.clear();
    });

    test('should start and stop timer correctly', () async {
      const operationName = 'test_operation';

      performanceMetrics.startTimer(operationName);
      expect(performanceMetrics.isTimerRunning(operationName), isTrue);

      // Simulate some work
      await Future.delayed(const Duration(milliseconds: 10));

      final duration = performanceMetrics.stopTimer(operationName);
      expect(duration, isNotNull);
      expect(duration!.inMilliseconds, greaterThanOrEqualTo(0));
      expect(performanceMetrics.isTimerRunning(operationName), isFalse);
    });

    test('should handle multiple concurrent timers', () async {
      const operation1 = 'operation_1';
      const operation2 = 'operation_2';

      performanceMetrics.startTimer(operation1);
      performanceMetrics.startTimer(operation2);

      expect(performanceMetrics.isTimerRunning(operation1), isTrue);
      expect(performanceMetrics.isTimerRunning(operation2), isTrue);

      // Add small delay to ensure measurable duration
      await Future.delayed(const Duration(milliseconds: 1));

      final duration1 = performanceMetrics.stopTimer(operation1);
      final duration2 = performanceMetrics.stopTimer(operation2);

      expect(duration1, isNotNull);
      expect(duration2, isNotNull);
      expect(performanceMetrics.isTimerRunning(operation1), isFalse);
      expect(performanceMetrics.isTimerRunning(operation2), isFalse);
    });

    test('should return null for non-existent timer', () {
      const nonExistentOperation = 'non_existent';

      final duration = performanceMetrics.stopTimer(nonExistentOperation);
      expect(duration, isNull);
      expect(
        performanceMetrics.isTimerRunning(nonExistentOperation),
        isFalse,
      );
    });

    test('should track memory usage', () {
      final memoryUsage = performanceMetrics.getCurrentMemoryUsage();
      expect(memoryUsage, isNotNull);
      expect(memoryUsage.runtimeType, equals(int));
      expect(memoryUsage, greaterThanOrEqualTo(0));
    });

    test('should generate performance report', () async {
      const operation = 'report_test';

      performanceMetrics.startTimer(operation);
      await Future.delayed(const Duration(milliseconds: 1));
      performanceMetrics.stopTimer(operation);

      final report = performanceMetrics.generateReport();
      expect(report, isNotNull);
      expect(report, contains(operation));
      expect(report, contains('Performance Metrics Report'));
    });

    test('should clear all timer data', () {
      const operation = 'clear_test';

      performanceMetrics.startTimer(operation);
      expect(performanceMetrics.isTimerRunning(operation), isTrue);

      performanceMetrics.clear();
      expect(performanceMetrics.isTimerRunning(operation), isFalse);

      final report = performanceMetrics.generateReport();
      expect(report, contains('No completed operations'));
    });
  });
}
