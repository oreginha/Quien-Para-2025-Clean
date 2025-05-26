// lib/presentation/widgets/optimized_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/presentation/routes/app_router.dart';
import '../../core/theme/app_theme.dart';

class OptimizedHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final String? iconAssetPath;
  final double progress;
  final int currentStep;
  final int totalSteps;
  final bool showLogo;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const OptimizedHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconAssetPath,
    this.progress = 0.0,
    this.currentStep = 0,
    this.totalSteps = 0,
    this.showLogo = false,
    this.onBackPressed,
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 50); // Aumentar altura preferida para evitar desbordamiento de 19 píxeles

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Espacio superior para mejorar posición vertical
        const SizedBox(
          height: 4,
        ), // Reducido de 8 a 4 para ahorrar espacio vertical
        // Barra superior con logo/botón atrás
        if (showLogo || onBackPressed != null || showBackButton)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 2.0,
            ), // Reducido de 4.0 a 2.0
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Botón atrás si es necesario
                if (showBackButton || onBackPressed != null)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: AppColors.lightTextPrimary,
                    onPressed: onBackPressed ?? () => context.closeScreen(),
                    padding: const EdgeInsets.all(4.0),
                    constraints: const BoxConstraints(),
                    iconSize: 24, // Aumentar tamaño del icono
                  )
                else
                  const SizedBox(width: 24),

                // Logo de la aplicación
                if (showLogo)
                  SizedBox(
                    height:
                        100, // Reducido de 120 a 100 para ahorrar espacio vertical
                    width:
                        100, // Reducido de 120 a 100 para mantener proporción
                    child: Image.asset(
                      'lib/assets/images/logo1.png',
                      fit: BoxFit.contain,
                      errorBuilder:
                          (
                            final BuildContext context,
                            final Object error,
                            final StackTrace? stackTrace,
                          ) => Center(
                            child: Text(
                              "Q",
                              style: TextStyle(
                                color: AppColors.lightTextPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20, // Aumentar tamaño de texto
                              ),
                            ),
                          ),
                    ),
                  ),
              ],
            ),
          ),

        // Indicador de progreso
        if (progress > 0 || currentStep > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: LinearProgressIndicator(
              value: progress > 0 ? progress : (currentStep / totalSteps),
              backgroundColor: AppColors.getSecondaryBackground(false),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.lightTextPrimary,
              ),
              minHeight: 4,
            ),
          ),

        // Título con icono (compacto)
        Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            4,
          ), // Reducido de 8 a 4 para ahorrar espacio vertical
          child: Row(
            children: <Widget>[
              // Icono (SVG, asset o icono de material)
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16.0,
                  ), // Aumentar padding
                  child: icon!,
                )
              else if (iconAssetPath != null)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16.0,
                  ), // Aumentar padding
                  child: iconAssetPath!.endsWith('.svg')
                      ? SvgPicture.asset(
                          iconAssetPath!,
                          height: 28, // Aumentar tamaño
                          width: 28, // Aumentar tamaño
                          colorFilter: ColorFilter.mode(
                            AppColors.lightTextPrimary,
                            BlendMode.srcIn,
                          ),
                        )
                      : Image.asset(
                          iconAssetPath!,
                          height: 28, // Aumentar tamaño
                          width: 28, // Aumentar tamaño
                          errorBuilder:
                              (
                                final BuildContext context,
                                final Object error,
                                final StackTrace? stackTrace,
                              ) => Icon(
                                Icons.image_not_supported,
                                size: 28,
                                color: AppColors.getSecondaryBackground(false),
                              ), // Aumentar tamaño
                        ),
                )
              // Si no hay icono específico, usar uno predeterminado según la pantalla
              else
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16.0,
                  ), // Aumentar padding
                  child: Icon(
                    Icons.arrow_circle_right_outlined,
                    size: 28, // Aumentar tamaño
                    color: AppColors.lightTextPrimary,
                  ),
                ),

              // Textos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightTextPrimary,
                      ), // Aumentar tamaño de fuente
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.lightTextSecondary,
                        ), // Aumentar tamaño
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Info de paso (si aplica)
              if (currentStep > 0 && totalSteps > 0)
                Text(
                  'Paso $currentStep de $totalSteps',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkTextSecondary,
                  ),
                ),
            ],
          ),
        ),

        // Línea divisoria sutil
        Padding(
          padding: const EdgeInsets.only(
            top: 4.0,
          ), // Reducido de 8.0 a 4.0 para ahorrar espacio vertical
          child: Container(height: 1, color: AppTheme.of(context).border),
        ),
      ],
    );
  }
}
