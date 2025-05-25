// lib/core/widgets/feedback/app_dialog.dart

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

/// Widget para mostrar diálogos con estilos consistentes
class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget>? actions;
  final Widget? content;
  final bool isDangerous;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;

  const AppDialog({
    super.key,
    required this.title,
    this.message = '',
    this.actions,
    this.content,
    this.isDangerous = false,
    this.contentPadding,
    this.actionsPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkCardBackground
          : AppColors.lightCardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDangerous
                    ? AppColors.success
                    : AppColors.lightTextPrimary,
                backgroundColor: isDangerous
                    ? AppColors.success
                    : AppColors.lightTextPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.s),

            // Contenido
            if (content != null)
              Padding(
                padding: contentPadding ??
                    const EdgeInsets.symmetric(vertical: AppSpacing.s),
                child: content!,
              )
            else if (message.isNotEmpty)
              Padding(
                padding: contentPadding ??
                    const EdgeInsets.symmetric(vertical: AppSpacing.s),
                child: Text(
                  message,
                  style: AppTypography.bodyMedium(false),
                ),
              ),

            // Acciones
            if (actions != null && actions!.isNotEmpty)
              Padding(
                padding: actionsPadding ??
                    const EdgeInsets.only(top: AppSpacing.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Muestra un diálogo de confirmación
  static Future<bool?> showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        isDangerous: isDangerous,
        actions: [
          TextButton(
            onPressed: () => context.closeScreen(false),
            child: Text(
              cancelText,
              style: AppTypography.buttonMedium(Theme.of(context).brightness == Brightness.dark)
                  .copyWith(color: Theme.of(context).brightness == Brightness.dark 
                    ? AppColors.darkTextSecondary 
                    : AppColors.lightTextSecondary),
            ),
          ),
          TextButton(
            onPressed: () => context.closeScreen(true),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(isDangerous
                  ? AppColors.success
                  : AppColors.brandYellow),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s,
                  vertical: AppSpacing.s,
                ),
              ),
            ),
            child: Text(
              confirmText,
              style: AppTypography.buttonMedium(Theme.of(context).brightness == Brightness.dark)
                  .copyWith(color: Theme.of(context).brightness == Brightness.dark 
                    ? AppColors.darkTextSecondary 
                    : AppColors.lightTextSecondary),
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra un diálogo de error
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'Entendido',
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        isDangerous: true,
        actions: [
          TextButton(
            onPressed: () => context.closeScreen(),
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(AppColors.success),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s,
                  vertical: AppSpacing.s,
                ),
              ),
            ),
            child: Text(
              buttonText,
              style:
                  AppTypography.buttonMedium(false).copyWith(color: AppColors.lightTextPrimary),
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra un diálogo de éxito
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'Aceptar',
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        actions: [
          TextButton(
            onPressed: () => context.closeScreen(),
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(AppColors.success),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(
                  horizontal: AppSpacing.s,
                  vertical: AppSpacing.s,
                ),
              ),
            ),
            child: Text(
              buttonText,
              style:
                  AppTypography.buttonMedium(false).copyWith(color: AppColors.lightTextPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
