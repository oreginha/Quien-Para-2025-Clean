// lib/presentation/widgets/common/feedback_message.dart
import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

/// Tipo de mensajes de retroalimentación
enum FeedbackType { success, error, warning, info }

/// Widget reutilizable para mostrar mensajes de retroalimentación consistentes
/// en toda la aplicación (éxito, error, advertencia, información)
class FeedbackMessage {
  /// Muestra un mensaje de retroalimentación usando SnackBar
  static void show(
    BuildContext context, {
    required String message,
    required FeedbackType type,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    // Definir colores y iconos según el tipo de mensaje
    IconData icon;
    Color darkPrimaryBackground;
    Color textColor = Colors.white;

    switch (type) {
      case FeedbackType.success:
        icon = Icons.check_circle_outline;
        darkPrimaryBackground = Colors.green.shade700;
        break;
      case FeedbackType.error:
        icon = Icons.error_outline;
        darkPrimaryBackground = Colors.red.shade700;
        break;
      case FeedbackType.warning:
        icon = Icons.warning_amber_outlined;
        darkPrimaryBackground = Colors.orange.shade700;
        break;
      case FeedbackType.info:
        icon = Icons.info_outline;
        darkPrimaryBackground = Colors.blue.shade700;
        break;
    }

    // Crear el SnackBar
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: TextStyle(color: textColor)),
          ),
        ],
      ),
      backgroundColor: darkPrimaryBackground,
      duration: duration,
      action: onAction != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textColor,
              onPressed: onAction,
            )
          : null,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
    );

    // Mostrar el SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Muestra un mensaje de éxito
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context,
      message: message,
      type: FeedbackType.success,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Muestra un mensaje de error
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context,
      message: message,
      type: FeedbackType.error,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Muestra un mensaje de advertencia
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context,
      message: message,
      type: FeedbackType.warning,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Muestra un mensaje informativo
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context,
      message: message,
      type: FeedbackType.info,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Muestra un diálogo de confirmación
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Sí',
    String cancelLabel = 'No',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isDangerous ? Icons.warning : Icons.help_outline,
              color: isDangerous ? Colors.red : AppColors.lightTextPrimary,
            ),
            SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            child: Text(cancelLabel),
            onPressed: () => context.closeScreen(false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDangerous
                  ? Colors.red
                  : AppColors.lightTextPrimary,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmLabel),
            onPressed: () => context.closeScreen(true),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
