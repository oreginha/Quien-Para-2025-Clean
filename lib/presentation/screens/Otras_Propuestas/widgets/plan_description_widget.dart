// lib/presentation/screens/Otras_Propuestas/widgets/plan_description_widget.dart

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';

/// Widget que muestra la sección de descripción del plan
class PlanDescriptionWidget extends StatelessWidget {
  final String description;
  final bool isDarkMode;

  const PlanDescriptionWidget({
    super.key,
    required this.description,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Text(
          'Descripción',
          style: AppTypography.heading2(
            isDarkMode,
          ).copyWith(color: AppColors.brandYellow),
        ),
        SizedBox(height: AppSpacing.xxl),

        // Contenedor con la descripción
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.getCardBackground(isDarkMode),
            borderRadius: BorderRadius.circular(AppRadius.l),
            boxShadow: [
              BoxShadow(
                color: AppColors.getCardBackground(
                  isDarkMode,
                ).withAlpha((0.2 * 255).round()),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            description.isNotEmpty
                ? description
                : 'No hay descripción disponible para este plan.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
