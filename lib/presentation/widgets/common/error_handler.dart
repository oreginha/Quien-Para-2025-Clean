// lib/presentation/widgets/common/error_handler.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quien_para/presentation/widgets/common/buttons/app_button_handler.dart';

/// Tipo de error para clasificarlos
enum ErrorType { connection, notFound, server, permission, validation, unknown }

/// Widget reutilizable para mostrar errores de manera consistente
/// y ofrecer acciones como reintentar
class ErrorHandler extends StatelessWidget {
  /// El mensaje de error a mostrar
  final String errorMessage;

  /// El tipo de error
  final ErrorType errorType;

  /// Función para reintentar la operación
  final VoidCallback? onRetry;

  /// Función para volver atrás
  final VoidCallback? onGoBack;

  /// Título personalizado para el error
  final String? title;

  /// Descripción adicional
  final String? description;

  /// Widget adicional a mostrar
  final Widget? additionalContent;

  const ErrorHandler({
    super.key,
    required this.errorMessage,
    this.errorType = ErrorType.unknown,
    this.onRetry,
    this.onGoBack,
    this.title,
    this.description,
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono según el tipo de error
            Icon(
              _getIconForErrorType(),
              color: _getColorForErrorType(),
              size: 64,
            ),
            const SizedBox(height: 16),

            // Título del error
            Text(
              title ?? _getTitleForErrorType(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: _getColorForErrorType(),
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Descripción del error
            Text(
              description ?? errorMessage,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[200]),
              textAlign: TextAlign.center,
            ),

            // Texto técnico en debug mode
            if (kDebugMode && errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Error técnico: $errorMessage',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),

            // Contenido adicional
            if (additionalContent != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: additionalContent!,
              ),

            const SizedBox(height: 24),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onGoBack != null)
                  AppButtonHandler(
                    label: 'Volver',
                    icon: Icons.arrow_back,
                    type: AppButtonType.outline,
                    onPressed: onGoBack,
                  ),
                if (onGoBack != null && onRetry != null)
                  const SizedBox(width: 16),
                if (onRetry != null)
                  AppButtonHandler(
                    label: 'Reintentar',
                    icon: Icons.refresh,
                    type: AppButtonType.primary,
                    onPressed: onRetry,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Obtiene el icono según el tipo de error
  IconData _getIconForErrorType() {
    switch (errorType) {
      case ErrorType.connection:
        return Icons.wifi_off_rounded;
      case ErrorType.notFound:
        return Icons.search_off_rounded;
      case ErrorType.server:
        return Icons.cloud_off_rounded;
      case ErrorType.permission:
        return Icons.no_accounts_rounded;
      case ErrorType.validation:
        return Icons.error_outline_rounded;
      case ErrorType.unknown:
        return Icons.warning_amber_rounded;
    }
  }

  /// Obtiene el color según el tipo de error
  Color _getColorForErrorType() {
    switch (errorType) {
      case ErrorType.connection:
        return Colors.orange;
      case ErrorType.notFound:
        return Colors.blue;
      case ErrorType.server:
        return Colors.red;
      case ErrorType.permission:
        return Colors.purple;
      case ErrorType.validation:
        return Colors.amber;
      case ErrorType.unknown:
        return Colors.red;
    }
  }

  /// Obtiene el título según el tipo de error
  String _getTitleForErrorType() {
    switch (errorType) {
      case ErrorType.connection:
        return 'Error de conexión';
      case ErrorType.notFound:
        return 'No encontrado';
      case ErrorType.server:
        return 'Error del servidor';
      case ErrorType.permission:
        return 'Sin permisos';
      case ErrorType.validation:
        return 'Error de validación';
      case ErrorType.unknown:
        return 'Error inesperado';
    }
  }
}
