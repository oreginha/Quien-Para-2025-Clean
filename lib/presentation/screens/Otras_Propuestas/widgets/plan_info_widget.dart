// lib/presentation/screens/Otras_Propuestas/widgets/plan_info_widget.dart

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

/// Widget que muestra la información principal del plan
class PlanInfoWidget extends StatelessWidget {
  final PlanEntity plan;
  final bool isDarkMode;

  const PlanInfoWidget({
    super.key,
    required this.plan,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Fecha
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.brandYellow,
                  size: 28,
                ),
                SizedBox(height: AppSpacing.s),
                Text(
                  plan.date != null
                      ? '${plan.date!.day}/${plan.date!.month}/${plan.date!.year}'
                      : 'Fecha no disponible',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Separador vertical
          Container(
            height: 40,
            width: 1,
            color: AppColors.getBorder(
              isDarkMode,
            ).withAlpha((0.3 * 255).round()),
          ),
          // Ubicación
          Expanded(
            child: Column(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.brandYellow,
                  size: 28,
                ),
                SizedBox(height: AppSpacing.s),
                Text(
                  plan.location.isNotEmpty
                      ? plan.location
                      : 'Ubicación no especificada',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
