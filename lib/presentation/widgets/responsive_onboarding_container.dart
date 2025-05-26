// lib/core/widgets/responsive_onboarding_container.dart
import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';

/// Container widget para pantallas de onboarding que resuelve problemas de desbordamiento
/// y proporciona un diseño responsivo y coherente para todos los pasos
class ResponsiveOnboardingContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool scrollable;
  final Widget? bottomActions;

  const ResponsiveOnboardingContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.scrollable = true,
    this.bottomActions,
  });

  @override
  Widget build(BuildContext context) {
    // Calcular la altura disponible considerando el padding inferior para evitar overflow
    final double safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final double bottomActionsHeight = bottomActions != null ? 80.0 : 0.0;
    final double paddingOffset = 16.0;

    return Column(
      children: [
        // Contenido principal con scroll si es necesario
        Expanded(
          child: scrollable
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: padding.add(
                    EdgeInsets.only(
                      bottom:
                          bottomActionsHeight + safeAreaBottom + paddingOffset,
                    ),
                  ),
                  child: child,
                )
              : Padding(padding: padding, child: child),
        ),

        // Acciones inferiores (botones, etc.) si existen
        if (bottomActions != null)
          Container(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 20.0 + safeAreaBottom,
              top: 10.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkTextPrimary.withAlpha((255 * 0.8).round()),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: bottomActions,
          ),
      ],
    );
  }
}
