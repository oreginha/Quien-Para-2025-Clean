import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationManager {
  static final NavigationManager _instance = NavigationManager._internal();
  factory NavigationManager() => _instance;
  NavigationManager._internal();

  final List<String> _routeHistory = <String>[];
  String? get previousRoute =>
      _routeHistory.length > 1 ? _routeHistory[_routeHistory.length - 2] : null;
  String? get currentRoute =>
      _routeHistory.isNotEmpty ? _routeHistory.last : null;

  void pushRoute(final String screenName) {
    if (_routeHistory.isEmpty || _routeHistory.last != screenName) {
      _routeHistory.add(screenName);
    }
  }

  bool pop(final BuildContext context) {
    if (_routeHistory.length > 1) {
      _routeHistory.removeLast();
      final String previousRoute = _routeHistory.last;

      // Use GoRouter instead of Navigator
      if (context.mounted) {
        context.go(previousRoute);
      }
      return true;
    }

    // If we can't pop, go to home
    if (context.mounted) {
      context.go('/');
    }
    return false;
  }

  void goBack(final BuildContext context) {
    pop(context);
  }

  void clearHistory() {
    _routeHistory.clear();
  }

  void printHistory() {
    if (kDebugMode) {
      print('Route History: $_routeHistory');
    }
  }
}
