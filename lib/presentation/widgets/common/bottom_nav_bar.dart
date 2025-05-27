// ignore_for_file: inference_failure_on_function_return_type, use_key_in_widget_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

/// Barra de navegación inferior mejorada con integración GoRouter
///
/// Esta barra detecta automáticamente la ruta actual y sincroniza
/// el índice seleccionado con la navegación del usuario.
class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavBar({final Key? key, required this.currentIndex, this.onTap});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // Lista de rutas correspondientes a cada icono de navegación
  final List<String> _routes = [
    AppRouter.conversationsList, // Messages
    AppRouter.proposalsScreen, // Propuestas
    AppRouter.home, // Home
    AppRouter.profile, // Perfil
    AppRouter.notifications, // Notificaciones
  ];

  // Determina el índice actual basado en la ruta de GoRouter de manera segura
  int get _getCurrentIndex {
    try {
      final String currentLocation = GoRouterState.of(context).path ?? '/';

      // Mapear rutas a índices
      switch (currentLocation) {
        case '/conversations':
          return 0;
        case '/proposalsScreen':
          return 1;
        case '/':
        case '/home':
          return 2;
        case '/profile':
          return 3;
        case '/notifications':
          return 4;
        default:
          return 2; // Default to home
      }
    } catch (e) {
      // En caso de error, usar el índice proporcionado como fallback
      if (kDebugMode) {
        print('⚠️ [BottomNavBar] Error al determinar índice actual: $e');
      }
      return widget.currentIndex;
    }
  }

  // Maneja la navegación cuando se toca un ítem - Versión mejorada con manejo de errores
  void _handleNavigation(final BuildContext context, final int index) {
    try {
      // Proporcionar feedback táctil de manera segura
      HapticFeedback.lightImpact();

      // Validar que el índice sea válido
      if (index >= 0 && index < _routes.length) {
        // Obtener la ruta actual para evitar navegación redundante
        final String currentPath = GoRouterState.of(context).path ?? '/';
        final String targetPath = _routes[index];

        // Solo navegar si la ruta destino es diferente de la actual
        if (currentPath != targetPath) {
          try {
            // Usar go en lugar de push para prevenir acumulación de historial
            context.go(targetPath);
          } catch (e) {
            // Si falla go, intentar con push como alternativa
            if (kDebugMode) {
              print('⚠️ [BottomNavBar] Error en go(), intentando push(): $e');
            }
            context.push(targetPath);
          }

          // Llamar a la función onTap proporcionada si existe
          if (widget.onTap != null) {
            widget.onTap!(index);
          }
        } else if (kDebugMode) {
          print('🔄 [BottomNavBar] Ya estamos en la ruta $targetPath');
        }
      } else if (kDebugMode) {
        print('❌ [BottomNavBar] Índice de navegación inválido: $index');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ [BottomNavBar] Error durante la navegación: $e');
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    // Obtener el tema actual
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Colores basados en el tema activo
    final Color navBackground = isDarkMode
        ? AppColors.darkBottomNavBackground
        : AppColors.lightBottomNavBackground;
    final Color activeIconColor = AppColors.brandYellow;
    final Color inactiveIconColor =
        isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: navBackground,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        onTap: (final int index) => _handleNavigation(context, index),
        currentIndex: _getCurrentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: navBackground,
        selectedItemColor: activeIconColor,
        unselectedItemColor: inactiveIconColor,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: <BottomNavigationBarItem>[
          _buildNavItem(
            context,
            icon: Icons.message,
            label: 'Messages',
            isSelected: _getCurrentIndex == 0,
          ),
          _buildNavItem(
            context,
            icon: Icons.visibility,
            label: 'Planes',
            isSelected: _getCurrentIndex == 1,
          ),
          _buildNavItem(
            context,
            icon: Icons.home,
            label: 'Home',
            isSelected: _getCurrentIndex == 2,
          ),
          _buildNavItem(
            context,
            icon: Icons.person,
            label: 'Perfil',
            isSelected: _getCurrentIndex == 3,
          ),
          _buildNavItem(
            context,
            icon: Icons.notifications,
            label: 'Notificaciones',
            isSelected: _getCurrentIndex == 4,
          ),
        ],
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    final BuildContext context, {
    required final IconData icon,
    required final String label,
    required final bool isSelected,
  }) {
    // Obtener el tema actual
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color activeColor = AppColors.brandYellow;
    final Color inactiveColor =
        isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    // Determinar el widget del icono según el estado
    Widget iconWidget;

    if (isSelected) {
      iconWidget = Icon(icon, size: 28, color: activeColor);
    } else {
      iconWidget = Icon(icon, size: 28, color: inactiveColor);
    }

    return BottomNavigationBarItem(
      icon: iconWidget,
      label: label,
      backgroundColor: Colors.transparent,
    );
  }
}
