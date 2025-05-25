// lib/presentation/widgets/responsive/responsive_layout.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../web/web_screen_wrapper.dart';

/// Widget que proporciona un layout responsive que se adapta a diferentes tamaños de pantalla
/// Muestra un diseño diferente para móvil y web
class ResponsiveLayout extends StatelessWidget {
  /// Widget a mostrar en pantallas móviles
  final Widget mobileLayout;

  /// Widget a mostrar en pantallas web/desktop
  final Widget webLayout;

  /// Ancho máximo para considerar una pantalla como móvil
  final double mobileBreakpoint;

  /// Título para mostrar en la AppBar del wrapper web (opcional)
  final String webTitle;

  /// Índice de navegación actual (para el menú lateral)
  final int? currentIndex;

  /// Callback cuando cambia la navegación
  final Function(int)? onTap;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    required this.webLayout,
    this.mobileBreakpoint = 600,
    this.webTitle = '',
    this.currentIndex,
    this.onTap,
  });

  /// Constructor alternativo que envuelve automáticamente el contenido móvil para web
  /// Útil para pantallas que no necesitan implementar un layout web específico
  factory ResponsiveLayout.autoWrap({
    Key? key,
    required Widget mobileLayout,
    String webTitle = '',
    int currentIndex = 2, // Por defecto, el índice de Home
    Function(int)? onTap,
    double mobileBreakpoint = 600,
  }) {
    return ResponsiveLayout(
      key: key,
      mobileLayout: mobileLayout,
      webLayout: WebScreenWrapper(
        currentIndex: currentIndex,
        onTap: onTap,
        title: webTitle,
        child: mobileLayout,
      ),
      webTitle: webTitle,
      currentIndex: currentIndex,
      onTap: onTap,
      mobileBreakpoint: mobileBreakpoint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar si estamos en web basado en kIsWeb y el ancho de la pantalla
        final bool isWebLayout =
            kIsWeb && constraints.maxWidth > mobileBreakpoint;

        // Mostrar el layout correspondiente según la plataforma
        return isWebLayout ? webLayout : mobileLayout;
      },
    );
  }
}
