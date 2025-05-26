// lib/presentation/widgets/empty_state_widget.dart

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? actionButton;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.lightTextPrimary.withAlpha((255 * 0.5).round()),
            ),
            SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: AppTypography.heading2(
                Theme.of(context).brightness == Brightness.dark,
              ).copyWith(color: AppColors.lightTextPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              description,
              style: AppTypography.heading2(
                Theme.of(context).brightness == Brightness.dark,
              ).copyWith(color: AppColors.lightTextSecondary),
              textAlign: TextAlign.center,
            ),
            if (actionButton != null) ...[
              SizedBox(height: AppSpacing.xl),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
}
