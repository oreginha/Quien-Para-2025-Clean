// lib/presentation/widgets/common/platform_aware_app_bar.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Widget que muestra u oculta el AppBar según la plataforma
/// En dispositivos móviles muestra el AppBar, en web lo oculta
/// Similar a PlatformAwareBottomNav pero para AppBars
class PlatformAwareAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// AppBar a mostrar (si debe mostrarse)
  final PreferredSizeWidget appBar;

  /// Control manual para forzar la visibilidad (opcional)
  final bool? forceVisible;

  const PlatformAwareAppBar({
    super.key,
    required this.appBar,
    this.forceVisible,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar si debemos mostrar el AppBar
    // Por defecto, ocultarlo en web y mostrarlo en móvil
    final bool shouldShow = forceVisible ?? !kIsWeb;

    // Si no debe mostrarse, retornar un widget vacío con tamaño 0
    if (!shouldShow) {
      return const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: SizedBox.shrink(),
      );
    }

    // Mostrar el AppBar
    return appBar;
  }

  @override
  Size get preferredSize =>
      shouldShow ? appBar.preferredSize : const Size.fromHeight(0);

  bool get shouldShow => forceVisible ?? !kIsWeb;
}
