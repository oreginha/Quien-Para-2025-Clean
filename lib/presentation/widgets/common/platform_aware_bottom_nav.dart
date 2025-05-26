// lib/presentation/widgets/common/platform_aware_bottom_nav.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:quien_para/presentation/widgets/common/bottom_nav_bar.dart';

/// Widget que muestra u oculta la barra de navegación inferior según la plataforma
/// En dispositivos móviles muestra la barra, en web la oculta
class PlatformAwareBottomNav extends StatelessWidget {
  /// Índice actual de navegación
  final int currentIndex;

  /// Callback cuando se toca un ítem de navegación
  final Function(int)? onTap;

  /// Control manual para forzar la visibilidad (opcional)
  final bool? forceVisible;

  const PlatformAwareBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.forceVisible,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar si debemos mostrar la barra de navegación
    // Por defecto, ocultarla en web y mostrarla en móvil
    final bool shouldShow = forceVisible ?? !kIsWeb;

    // Si no debe mostrarse, retornar un widget vacío
    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    // Mostrar la barra de navegación inferior
    return BottomNavBar(currentIndex: currentIndex, onTap: onTap ?? (_) {});
  }
}
