// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';

class ProfileErrorWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final IconData icon;
  final bool showButton;

  const ProfileErrorWidget({
    super.key,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonPressed,
    this.icon = Icons.error_outline,
    this.showButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: AppColors.lightTextPrimary,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                color: AppColors.lightTextPrimary,
                fontSize: 24,
                fontWeight: AppTypography.heading2(false).fontWeight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                description,
                style: TextStyle(
                  color: AppColors.lightTextPrimary,
                  fontSize: 24,
                  fontWeight: AppTypography.heading2(false).fontWeight,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
            if (showButton) ...[
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightTextPrimary,
                ),
                child: Text(buttonText ?? 'Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
