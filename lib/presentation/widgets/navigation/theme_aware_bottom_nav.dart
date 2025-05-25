import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/provider/theme_provider.dart';

class BottomNavItem {
  final IconData icon;
  final String label;
  final String route;

  BottomNavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class ThemeAwareBottomNav extends StatelessWidget {
  final List<BottomNavItem> items;
  final int currentIndex;
  final Function(int) onTap;

  const ThemeAwareBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Colores según especificaciones
    final Color darkNavBackground = const Color(0xFF161F2E);
    final Color lightNavBackground = Colors.white;

    final Color inactiveIconColor = const Color(0xFFA0AEC0);
    final Color activeColor = const Color(0xFFFFC107); // Amarillo brand

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? darkNavBackground : lightNavBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icono con fondo circular si está activo
                      Container(
                        width: 40,
                        height: 40,
                        decoration: isSelected
                            ? BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    activeColor.withAlpha((0.2 * 255).round()),
                              )
                            : null,
                        child: Center(
                          child: Icon(
                            item.icon,
                            color: isSelected ? activeColor : inactiveIconColor,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Etiqueta
                      Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? activeColor : inactiveIconColor,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      // Punto indicador para ítem activo (para modo claro)
                      if (isSelected && !isDarkMode)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: activeColor.withValues(
                                red: 255, green: 193, blue: 7, alpha: 51),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
