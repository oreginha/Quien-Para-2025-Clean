import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/errors/user_friendly_error_handler.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';

/// Widget para mostrar errores con estilo consistente y animaciones
/// 
/// Este widget admite diferentes tipos de errores (Exception, Failure, String)
/// y muestra un mensaje contextual con animaciones y, opcionalmente, un botón
/// para reintentar la operación.
class ErrorDisplay extends StatelessWidget {
  final dynamic error;
  final VoidCallback? onRetry;
  final bool showRetryButton;
  
  const ErrorDisplay({
    super.key,
    required this.error,
    this.onRetry,
    this.showRetryButton = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final errorHandler = UserFriendlyErrorHandler();
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: errorHandler.buildErrorWidget(
        context,
        error,
        onRetry: showRetryButton ? onRetry : null,
        isDarkMode: themeProvider.isDarkMode,
      ),
    );
  }
}

/// Extensión para mostrar errores en un SnackBar con estilo consistente
extension ErrorSnackBarExtension on BuildContext {
  void showErrorSnackBar(dynamic error) {
    final errorHandler = UserFriendlyErrorHandler();
    errorHandler.showErrorSnackBar(this, error);
  }
}
