import 'dart:io';

class PerformanceMetrics {
  final Map<String, DateTime> _timers = {};
  final Map<String, Duration> _completedTimers = {};
  final Map<String, dynamic> _metrics = {};
  bool _initialized = false;

  /// Initializes the performance metrics system
  Future<void> init() async {
    _initialized = true;
    _timers.clear();
    _completedTimers.clear();
    _metrics.clear();
  }

  /// Starts a timer for the given operation name
  void startTimer(String operationName) {
    _timers[operationName] = DateTime.now();
  }

  /// Stops the timer for the given operation name and returns the duration
  Duration? stopTimer(String operationName) {
    final startTime = _timers.remove(operationName);
    if (startTime == null) return null;

    final duration = DateTime.now().difference(startTime);
    _completedTimers[operationName] = duration;
    return duration;
  }

  /// Checks if a timer is currently running for the given operation
  bool isTimerRunning(String operationName) {
    return _timers.containsKey(operationName);
  }

  /// Records a custom metric
  void recordMetric(String name, dynamic value, [String? unit]) {
    _metrics[name] = {
      'value': value,
      'unit': unit ?? '',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Gets all recorded metrics
  Map<String, dynamic> getAllMetrics() {
    final allMetrics = Map<String, dynamic>.from(_metrics);

    // Add timer metrics
    for (final entry in _completedTimers.entries) {
      allMetrics['timer_${entry.key}'] = {
        'value': entry.value.inMilliseconds,
        'unit': 'ms',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }

    // Add memory usage
    allMetrics['memory_usage'] = {
      'value': getCurrentMemoryUsage(),
      'unit': 'bytes',
      'timestamp': DateTime.now().toIso8601String(),
    };

    return allMetrics;
  }

  /// Gets the current memory usage in bytes (approximation)
  int getCurrentMemoryUsage() {
    // This is a simplified implementation
    // In a real app, you might want to use more sophisticated memory tracking
    try {
      final info = ProcessInfo.currentRss;
      return info;
    } catch (e) {
      // Fallback if ProcessInfo is not available
      return 0;
    }
  }

  /// Generates a performance report of all completed timers
  String generateReport() {
    final buffer = StringBuffer();
    buffer.writeln('Performance Metrics Report');
    buffer.writeln('=' * 30);

    if (_completedTimers.isEmpty && _metrics.isEmpty) {
      buffer.writeln('No completed operations to report.');
    } else {
      // Report timer data
      if (_completedTimers.isNotEmpty) {
        buffer.writeln('Timer Metrics:');
        for (final entry in _completedTimers.entries) {
          buffer.writeln('  ${entry.key}: ${entry.value.inMilliseconds}ms');
        }
      }

      // Report custom metrics
      if (_metrics.isNotEmpty) {
        buffer.writeln('\nCustom Metrics:');
        for (final entry in _metrics.entries) {
          final metric = entry.value;
          buffer
              .writeln('  ${entry.key}: ${metric['value']} ${metric['unit']}');
        }
      }
    }

    buffer.writeln('\nCurrent Memory Usage: ${getCurrentMemoryUsage()} bytes');
    buffer.writeln('Report Generated: ${DateTime.now().toIso8601String()}');

    return buffer.toString();
  }

  /// Clears all timer data and metrics
  void clear() {
    _timers.clear();
    _completedTimers.clear();
    _metrics.clear();
  }

  /// Gets whether the metrics system is initialized
  bool get isInitialized => _initialized;
}
