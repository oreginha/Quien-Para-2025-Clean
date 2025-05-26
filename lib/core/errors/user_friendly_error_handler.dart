import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quien_para/core/errors/exceptions.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_spacing.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/domain/entities/failure.dart';

/// Manejador de errores amigable para el usuario
///
/// Proporciona mensajes de error contextuales y widgets visuales
/// para mejorar la experiencia de usuario cuando ocurren errores.
/// Integrado con la arquitectura Clean para trabajar con Failures y Exceptions.
class UserFriendlyErrorHandler {
  /// Obtiene un mensaje amigable basado en la excepción
  String getMessageForException(Exception error) {
    if (error is NetworkException) {
      return 'No pudimos conectarnos a Internet. Verifica tu conexión y vuelve a intentarlo.';
    }

    if (error is AuthException) {
      return 'No pudimos verificar tu identidad. Por favor, inicia sesión nuevamente.';
    }

    if (error is ValidationException) {
      return 'Hay un problema con la información proporcionada: ${error.message}';
    }

    if (error is FirebaseException) {
      return _getFirebaseErrorMessage(error.code);
    }

    if (error is TimeoutException) {
      return 'La operación ha tardado demasiado tiempo. Por favor, inténtalo de nuevo.';
    }

    return 'Ha ocurrido un error inesperado. Por favor, inténtalo de nuevo más tarde.';
  }

  /// Obtiene un mensaje amigable basado en el Failure (dominio Clean Architecture)
  String getMessageForFailure(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No pudimos conectarnos a Internet. Verifica tu conexión y vuelve a intentarlo.';
    }

    if (failure is AuthFailure) {
      return 'No pudimos verificar tu identidad. Por favor, inicia sesión nuevamente.';
    }

    if (failure is ValidationFailure) {
      return 'Hay un problema con la información proporcionada: ${failure.message}';
    }

    if (failure is TimeoutFailure) {
      return 'La operación ha tardado demasiado tiempo. Por favor, inténtalo de nuevo.';
    }

    return failure.message ??
        'Ha ocurrido un error inesperado. Por favor, inténtalo de nuevo más tarde.';
  }

  /// Construye un widget de error con animación y opciones contextuales
  Widget buildErrorWidget(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
    bool isDarkMode = false,
  }) {
    final errorMessage = error is Exception
        ? getMessageForException(error)
        : error is Failure
        ? getMessageForFailure(error)
        : error.toString();

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getIconForError(error), size: 48, color: AppColors.accentRed),
            const SizedBox(height: AppSpacing.m),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge(isDarkMode),
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.l),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.brandYellow,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                    vertical: AppSpacing.s,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Muestra un SnackBar de error contextual
  void showErrorSnackBar(BuildContext context, dynamic error) {
    final errorMessage = error is Exception
        ? getMessageForException(error)
        : error is Failure
        ? getMessageForFailure(error)
        : error.toString();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(_getIconForError(error), color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(errorMessage)),
          ],
        ),
        backgroundColor: AppColors.accentRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Determina el icono apropiado según el tipo de error
  IconData _getIconForError(dynamic error) {
    if (error is NetworkException || error is NetworkFailure) {
      return Icons.wifi_off;
    }

    if (error is AuthException || error is AuthFailure) {
      return Icons.lock_outline;
    }

    if (error is ValidationException || error is ValidationFailure) {
      return Icons.warning_amber_outlined;
    }

    if (error is TimeoutException || error is TimeoutFailure) {
      return Icons.timer_off_outlined;
    }

    return Icons.error_outline;
  }

  /// Obtiene un mensaje de error específico para errores de Firebase
  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este correo electrónico ya está en uso por otra cuenta.';
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'user-not-found':
        return 'No encontramos una cuenta con este correo electrónico.';
      case 'wrong-password':
        return 'La contraseña ingresada es incorrecta.';
      case 'weak-password':
        return 'La contraseña es demasiado débil. Utiliza una combinación de letras, números y símbolos.';
      case 'operation-not-allowed':
        return 'Esta operación no está permitida.';
      case 'account-exists-with-different-credential':
        return 'Ya existe una cuenta con el mismo correo electrónico pero con diferentes credenciales.';
      case 'invalid-credential':
        return 'Las credenciales proporcionadas son inválidas.';
      case 'permission-denied':
        return 'No tienes permiso para realizar esta acción.';
      case 'not-found':
        return 'No pudimos encontrar el recurso solicitado.';
      default:
        return 'Error de Firebase: $code';
    }
  }
}
