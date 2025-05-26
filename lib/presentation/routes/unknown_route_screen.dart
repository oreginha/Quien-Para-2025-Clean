// unknown_route_screen.dart
// Pantalla para mostrar cuando una ruta no se encuentra

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'app_routes.dart';

/// Pantalla de ruta desconocida
class UnknownRouteScreen extends StatelessWidget {
  final String routePath;
  final String? errorMessage;

  const UnknownRouteScreen({
    super.key,
    required this.routePath,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página no encontrada'),
        backgroundColor: AppColors.brandYellow,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: AppColors.success,
              ),
              const SizedBox(height: 24),
              Text(
                '¡Ruta no encontrada!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'La ruta "$routePath" a la que intentas acceder no existe.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Error: $errorMessage',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.success,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandYellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Ir a la pantalla principal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
