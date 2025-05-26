// router_extension.dart
// Extensiones para facilitar la navegación con el router

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

/// Extensión para acceder fácilmente al router desde cualquier BuildContext
extension RouterExtension on BuildContext {
  // Navegación básica con historial mejorado
  void goBack({String? fallbackRoute}) {
    if (canPop()) {
      pop();
    } else {
      // Si no podemos hacer pop, vamos a la ruta alternativa o al home
      navigateTo(fallbackRoute ?? AppRoutes.home);
    }
  }

  // Verificar si podemos volver a una ruta específica en el historial
  bool canGoBackTo(String route) {
    final RouteMatchBase? match = GoRouter.of(this)
        .routerDelegate
        .currentConfiguration
        .matches
        .where((RouteMatchBase match) => match.matchedLocation == route)
        .firstOrNull;
    return match != null;
  }

  // Volver a una ruta específica del historial si existe, o a una ruta por defecto
  void goBackToRoute(String targetRoute, {String? fallbackRoute}) {
    if (canGoBackTo(targetRoute)) {
      // Si la ruta está en el historial, volver a ella
      GoRouter.of(this).go(targetRoute);
    } else {
      // Si no está en el historial, ir a la ruta alternativa o al home
      navigateTo(fallbackRoute ?? AppRoutes.home);
    }
  }

  void goToHome() => navigateTo(AppRoutes.home);

  // Reemplazar el método push2 con un método más claro
  void pushRoute(String path, {Object? extra}) =>
      GoRouter.of(this).push(path, extra: extra);

  // Método principal de navegación - conserva historial
  void navigateTo(String path, {Object? extra}) =>
      GoRouter.of(this).go(path, extra: extra);

  // Método de navegación que reemplaza la pantalla actual
  void replaceWith(String path, {Object? extra}) =>
      GoRouter.of(this).replace(path, extra: extra);

  // Métodos para navegación con parámetros nombrados
  void appPushNamed(
    String name, {
    Map<String, String>? params,
    Map<String, dynamic>? queryParams,
    Object? extra,
  }) => GoRouter.of(this).pushNamed(
    name,
    pathParameters: params ?? {},
    queryParameters: queryParams ?? {},
    extra: extra,
  );

  void appGoNamed(
    String name, {
    Map<String, String>? params,
    Map<String, dynamic>? queryParams,
    Object? extra,
  }) => GoRouter.of(this).goNamed(
    name,
    pathParameters: params ?? {},
    queryParameters: queryParams ?? {},
    extra: extra,
  );

  // Método para extraer extra params de manera segura
  T? getExtraAs<T>() {
    final GoRouterState state = GoRouterState.of(this);
    return state.extra as T?;
  }

  // Método para extraer parámetros de ruta
  String getParam(String name, {String defaultValue = ''}) {
    final GoRouterState state = GoRouterState.of(this);
    return state.pathParameters[name] ?? defaultValue;
  }

  // Métodos para manejar operaciones comunes de navegación

  /// Cierra la pantalla actual y devuelve un resultado
  void closeScreen<T>([T? result]) => Navigator.of(this).pop(result);

  /// Cierra todas las pantallas hasta la raíz
  void closeToRoot() => Navigator.of(this, rootNavigator: true).pop();

  /// Comprueba si se puede cerrar la pantalla actual
  bool canCloseScreen() => Navigator.of(this).canPop();

  /// Muestra un diálogo con GoRouter (compatible con web)
  Future<T?> showAppDialog<T>({required Widget dialog}) {
    return showDialog<T>(context: this, builder: (_) => dialog);
  }

  /// Muestra un modal bottom sheet con GoRouter (compatible con web)
  Future<T?> showAppBottomSheet<T>({required Widget sheet}) {
    return showModalBottomSheet<T>(context: this, builder: (_) => sheet);
  }
}
