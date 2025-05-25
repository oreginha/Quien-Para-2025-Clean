// lib/presentation/widgets/common/loading_indicator.dart

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';

/// Indicador de carga reutilizable que respeta el sistema de temas de la aplicación
class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.color,
    this.size = 40.0,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.brandYellow,
        ),
        strokeWidth: strokeWidth,
      ),
    );
  }
}
