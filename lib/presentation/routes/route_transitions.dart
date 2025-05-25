// route_transitions.dart
// Este archivo contiene la lógica relacionada con las transiciones de rutas

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Tipos de transiciones disponibles para las páginas
enum PageTransitionType {
  fade, // Transición con desvanecimiento
  slide, // Transición deslizante desde la derecha
  slideUp, // Transición deslizante desde abajo
  scale, // Transición con escalado
  none // Sin transición
}

/// Utilidades para crear transiciones entre rutas
class RouteTransitions {
  // Método para crear transiciones estandarizadas en toda la aplicación
  static CustomTransitionPage<void> buildPageTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    PageTransitionType transitionType = PageTransitionType.fade,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case PageTransitionType.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );

          case PageTransitionType.slide:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );

          case PageTransitionType.slideUp:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );

          case PageTransitionType.scale:
            return ScaleTransition(
              scale: animation,
              child: child,
            );

          case PageTransitionType.none:
            return child;
        }
      },
      transitionDuration: duration,
    );
  }
  
  // Método de conveniencia para crear una transición con desvanecimiento
  static CustomTransitionPage<void> fadeTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
