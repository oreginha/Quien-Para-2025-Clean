// lib/core/widgets/onboarding_button.dart
import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/theme_constants.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;
  final bool isPrimary;
  final bool isSmall;
  final IconData? icon;

  const OnboardingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.isPrimary = true,
    this.isSmall = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = isEnabled && !isLoading;

    final Color darkPrimaryBackground =
        isPrimary ? AppColors.lightTextPrimary : AppColors.lightBackground;

    final Color textColor =
        isPrimary ? AppColors.lightTextPrimary : AppColors.lightTextPrimary;

    final double horizontalPadding = isSmall ? 16.0 : 24.0;
    final double verticalPadding = isSmall ? 10.0 : 16.0;
    final double fontSize = isSmall ? 14.0 : 16.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: isSmall ? 42.0 : 54.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: isActive && isPrimary
            ? [
                BoxShadow(
                  color: AppColors.lightTextPrimary.withAlpha(
                    (255 * 0.3).round(),
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isActive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive
              ? darkPrimaryBackground
              : AppColors.lightTextPrimary.withAlpha((255 * 0.5).round()),
          foregroundColor: textColor,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.l),
          ),
          elevation: isActive ? 2 : 0,
          disabledBackgroundColor: AppColors.lightTextPrimary.withAlpha(
            (255 * 0.4).round(),
          ),
          disabledForegroundColor: AppColors.lightTextPrimary.withAlpha(
            (255 * 0.6).round(),
          ),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: isSmall ? 16 : 20),
                    SizedBox(width: isSmall ? 8 : 12),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: isActive
                          ? textColor
                          : AppColors.lightTextPrimary.withAlpha(
                              (255 * 0.7).round(),
                            ),
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Botón secundario para onboarding
class OnboardingSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isSmall;
  final IconData? icon;

  const OnboardingSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
    this.isSmall = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double fontSize = isSmall ? 14.0 : 15.0;

    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 12.0 : 16.0,
          vertical: isSmall ? 8.0 : 12.0,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        foregroundColor: AppColors.lightTextPrimary,
        backgroundColor: Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isSmall ? 16 : 18),
            SizedBox(width: isSmall ? 4 : 8),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: isEnabled
                  ? AppColors.lightTextPrimary
                  : AppColors.lightTextPrimary.withAlpha((255 * 0.6).round()),
            ),
          ),
        ],
      ),
    );
  }
}
