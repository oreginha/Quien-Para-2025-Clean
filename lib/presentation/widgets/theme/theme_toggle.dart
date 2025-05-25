import 'package:flutter/material.dart' hide ThemeMode;
import 'package:provider/provider.dart';
import '../../../core/theme/provider/theme_provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 16.0),
          child: Text(
            'Apariencia',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),

        // Theme options
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Light mode option
              _buildThemeOption(
                context,
                title: 'Modo claro',
                icon: Icons.light_mode,
                isSelected: themeProvider.themeMode == ThemeMode.light,
                onTap: () => themeProvider.setThemeMode(ThemeMode.light),
              ),

              const Divider(height: 1, indent: 56),

              // Dark mode option
              _buildThemeOption(
                context,
                title: 'Modo oscuro',
                icon: Icons.dark_mode,
                isSelected: themeProvider.themeMode == ThemeMode.dark,
                onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
              ),

              const Divider(height: 1, indent: 56),

              // System mode option
              _buildThemeOption(
                context,
                title: 'Automático (sistema)',
                icon: Icons.settings_suggest,
                isSelected: themeProvider.themeMode == ThemeMode.system,
                onTap: () => themeProvider.setThemeMode(ThemeMode.system),
              ),
            ],
          ),
        ),

        // Description
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'El modo automático se ajusta según la configuración de tu dispositivo.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? theme.colorScheme.primary : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isSelected ? theme.colorScheme.primary : null,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
