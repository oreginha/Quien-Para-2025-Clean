// router_observer.dart
// Este archivo contiene el observador para el router

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Observer para hacer log de la navegación - Versión optimizada
class GoRouterObserver extends NavigatorObserver {
  final Logger logger;
  final Map<String, int> _routeStartTimes = {};
  static const int _maxTrackedRoutes = 10;

  GoRouterObserver(this.logger);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final String screenName = route.settings.name ?? 'unnamed';
    _routeStartTimes[screenName] = DateTime.now().millisecondsSinceEpoch;

    if (_routeStartTimes.length > _maxTrackedRoutes) {
      final List<String> keys = _routeStartTimes.keys.toList();
      for (int i = 0; i < keys.length - _maxTrackedRoutes; i++) {
        _routeStartTimes.remove(keys[i]);
      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final String screenName = route.settings.name ?? 'unnamed';

    if (kDebugMode) {
      final int? startTime = _routeStartTimes[screenName];
      if (startTime != null) {
        final int elapsedMs = DateTime.now().millisecondsSinceEpoch - startTime;
        if (elapsedMs > 100) {
          logger.d('Navegación: $screenName - Tiempo: ${elapsedMs}ms');
        }
        _routeStartTimes.remove(screenName);
      }
    } else {
      _routeStartTimes.remove(screenName);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (kDebugMode) {
      final String newName = newRoute?.settings.name ?? 'unnamed';
      _routeStartTimes[newName] = DateTime.now().millisecondsSinceEpoch;

      if (oldRoute?.settings.name != null) {
        _routeStartTimes.remove(oldRoute!.settings.name);
      }
    }
  }
}
