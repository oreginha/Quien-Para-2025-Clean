// lib/core/widgets/feedback/app_feedback.dart

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/presentation/routes/app_router.dart';
import 'package:quien_para/core/theme/theme_constants.dart';


/// Clase de utilidad para mostrar mensajes de retroalimentación consistentes
class AppFeedback {
  /// Muestra un SnackBar con estilo de éxito
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              AppTypography.bodyMedium(false).copyWith(color: AppColors.lightTextPrimary),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Muestra un SnackBar con estilo de error
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              AppTypography.bodyMedium(false).copyWith(color: AppColors.lightTextPrimary),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Muestra un SnackBar con estilo de advertencia
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              AppTypography.bodyMedium(false).copyWith(color: AppColors.lightTextPrimary),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Muestra un SnackBar con estilo informativo
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              AppTypography.bodyMedium(false).copyWith(color: AppColors.lightTextPrimary),
        ),
        backgroundColor: AppColors.brandYellow,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Muestra un diálogo de confirmación estilizado
  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.getSecondaryBackground(Theme.of(context).brightness == Brightness.dark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        title: Text(
          title,
          style: AppTypography.heading2(false),
        ),
        content: Text(
          message,
          style: AppTypography.bodyMedium(false),
        ),
        actions: [
          TextButton(
            onPressed: () => context.closeScreen(false),
            child: Text(
              cancelText,
              style: AppTypography.bodyMedium(false).copyWith(
                color: AppColors.lightTextPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.closeScreen(true),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                isDangerous ? AppColors.success : AppColors.brandYellow,
              ),
            ),
            child: Text(
              confirmText,
              style: AppTypography.bodyMedium(false).copyWith(
                color: isDangerous
                    ? AppColors.lightTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
