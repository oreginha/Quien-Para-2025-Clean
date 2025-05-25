import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/provider/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = AppTheme.of(context);

    return GestureDetector(
      onTap: () {
        themeProvider.toggleTheme();
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.darkBackground.withAlpha((0.5 * 255).round()),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              theme.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: AppColors.lightTextPrimary,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              theme.isDarkMode ? 'Oscuro' : 'Claro',
              style: TextStyle(
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeModeIcon extends StatelessWidget {
  const ThemeModeIcon({
    super.key,
    this.size = 24,
    this.showBorder = false,
  });

  final double size;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = AppTheme.of(context);
    final iconColor = AppColors.lightTextPrimary;

    return GestureDetector(
      onTap: () {
        themeProvider.toggleTheme();
      },
      child: Container(
        width: size + 16,
        height: size + 16,
        decoration: showBorder
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      AppColors.lightTextPrimary.withAlpha((0.5 * 255).round()),
                  width: 1,
                ),
              )
            : null,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              theme.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              key: ValueKey<bool>(theme.isDarkMode),
              color: iconColor,
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}
