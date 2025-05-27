// lib/presentation/widgets/compact_header.dart

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';

class CompactHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? iconAssetPath;
  final double progress;
  final Color? iconColor;
  final Color? progressColor;

  const CompactHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconAssetPath,
    this.progress = 0.0,
    this.iconColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Column(
        children: <Widget>[
          // Barra de progreso
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[700],
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? AppColors.success,
            ),
            minHeight: 4,
          ),
          const SizedBox(height: 12),

          // Ícono y texto compactos
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Ícono (se muestra o un asset o un IconData)
              if (iconAssetPath != null)
                Image.asset(
                  iconAssetPath!,
                  width: 30,
                  height: 30,
                  errorBuilder: (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                  ) =>
                      Icon(
                    icon ?? Icons.info_outline,
                    color: iconColor ?? AppColors.brandYellow,
                    size: 30,
                  ),
                )
              else if (icon != null)
                Icon(icon, color: iconColor ?? AppColors.brandYellow, size: 30),

              const SizedBox(width: 10),

              // Texto principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: AppTypography.bodyMedium(
                        Theme.of(context).brightness == Brightness.dark,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTypography.bodySmall(
                          Theme.of(context).brightness == Brightness.dark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
