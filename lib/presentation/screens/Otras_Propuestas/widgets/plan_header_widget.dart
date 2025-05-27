// lib/presentation/screens/Otras_Propuestas/widgets/plan_header_widget.dart

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

/// Widget que muestra el encabezado del plan con imagen y título
class PlanHeaderWidget extends StatelessWidget {
  final PlanEntity plan;
  final bool isDarkMode;

  const PlanHeaderWidget({
    super.key,
    required this.plan,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.3 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Imagen
          plan.imageUrl.isNotEmpty
              ? Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(plan.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  height: 220,
                  width: double.infinity,
                  color: AppColors.getCardBackground(isDarkMode),
                  child: Icon(
                    Icons.image,
                    size: 80,
                    color: AppColors.getBorder(isDarkMode),
                  ),
                ),

          // Degradado para mejorar legibilidad del texto sobre la imagen
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha((0.7 * 255).round()),
                  ],
                ),
              ),
            ),
          ),

          // Título sobre la imagen
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                plan.title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black.withAlpha((0.5 * 255).round()),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Categoría (tag) sobre la imagen
          if (plan.category.isNotEmpty)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandYellow,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.3 * 255).round()),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  plan.category,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.lightTextPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
