import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';

/// Widget para mostrar un indicador de carga sobre una pantalla o widget
///
/// Puede ser utilizado de dos formas:
/// 1. Como un overlay completo (estilo Scaffold)
/// 2. Como un widget que muestra carga o contenido según el estado
class LoadingOverlay extends StatelessWidget {
  /// Mensaje opcional a mostrar debajo del indicador de carga
  final String? message;

  /// Si el estado está cargando o no (para modo 2)
  final bool isLoading;

  /// Widget hijo que se mostrará cuando no esté cargando (para modo 2)
  final Widget? child;

  const LoadingOverlay({
    super.key,
    this.message,
    this.isLoading = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Si no está cargando y hay un hijo, mostrar el hijo
    if (!isLoading) {
      return child ?? const SizedBox.shrink();
    }

    // Construir el indicador de carga
    final loadingIndicator = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightTextPrimary),
        ),
        if (message != null)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.s),
            child: Text(
              message!,
              style: AppTypography.bodyMedium(false),
              textAlign: TextAlign.center,
            ),
          ),
        if (child != null) const SizedBox(height: 16),
        if (child != null) child!,
      ],
    );

    // Devolver un Scaffold para overlay completo
    return Scaffold(
      backgroundColor: AppColors.getSecondaryBackground(Theme.of(context).brightness == Brightness.dark),
      body: Center(child: loadingIndicator),
    );
  }
}

/// Extensión para mostrar un mensaje de carga sobre cualquier BuildContext
extension LoadingExtension on BuildContext {
  /// Muestra un overlay de carga
  ///
  /// @param message Mensaje opcional a mostrar
  void showLoading({String? message}) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: LoadingOverlay(message: message),
      ),
    );
  }

  /// Oculta el overlay de carga actual
  void hideLoading() {
    if (Navigator.canPop(this)) {
      Navigator.pop(this);
    }
  }
}

/// SnackBar personalizado para mostrar mensajes
class CustomSnackbar extends SnackBar {
  CustomSnackbar({
    super.key,
    required String message,
    super.duration = const Duration(seconds: 3),
    bool isSuccess = true,
    required BuildContext context,
  }) : super(
          content: Row(
            children: <Widget>[
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.getSecondaryBackground(Theme.of(context).brightness == Brightness.dark),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
}

/// Extensión para mostrar un SnackBar personalizado
extension SnackBarExtension on BuildContext {
  /// Muestra un SnackBar de éxito
  void showSuccessSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      CustomSnackbar(
        message: message,
        duration: duration ?? const Duration(seconds: 3),
        isSuccess: true,
        context: this,
      ),
    );
  }

  /// Muestra un SnackBar de error
  void showErrorSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      CustomSnackbar(
        message: message,
        duration: duration ?? const Duration(seconds: 3),
        isSuccess: false,
        context: this,
      ),
    );
  }
}
