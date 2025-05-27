// lib/presentation/widgets/responsive/side_menu.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

/// Menú lateral para la versión web de la aplicación
/// Inspirado en el diseño de Bumble
class SideMenu extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const SideMenu({super.key, required this.currentIndex, this.onTap});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  // Lista de rutas correspondientes a cada icono de navegación
  final List<String> _routes = [
    AppRouter.conversationsList, // Messages
    AppRouter.proposalsScreen, // Propuestas
    AppRouter.home, // Home
    AppRouter.profile, // Perfil
    AppRouter.notifications, // Notificaciones
  ];

  // Lista de títulos para cada elemento del menú
  final List<String> _titles = [
    'Mensajes',
    'Planes',
    'Inicio',
    'Perfil',
    'Notificaciones',
  ];

  // Lista de iconos para cada elemento del menú
  final List<IconData> _icons = [
    Icons.message,
    Icons.visibility,
    Icons.home,
    Icons.person,
    Icons.notifications,
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
      return widget.currentIndex;
    }
  }

  // Maneja la navegación cuando se toca un ítem
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
          // Usar go en lugar de push para prevenir acumulación de historial
          context.go(targetPath);

          // Llamar a la función onTap proporcionada si existe
          if (widget.onTap != null) {
            widget.onTap!(index);
          }
        }
      }
    } catch (e) {
      // Manejar errores de navegación
    }
  }

  @override
  Widget build(BuildContext context) {
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
    final Color textColor =
        isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Container(
      width: 250,
      color: navBackground,
      child: Column(
        children: [
          // Perfil del usuario (avatar y nombre)
          _buildUserProfile(context, isDarkMode, textColor),

          const Divider(height: 1),

          // Elementos del menú
          Expanded(
            child: ListView.builder(
              itemCount: _routes.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final bool isSelected = _getCurrentIndex == index;
                return ListTile(
                  leading: Icon(
                    _icons[index],
                    color: isSelected ? activeIconColor : inactiveIconColor,
                    size: 24,
                  ),
                  title: Text(
                    _titles[index],
                    style: TextStyle(
                      color: isSelected ? activeIconColor : textColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor:
                      isDarkMode ? Colors.black12 : Colors.white10,
                  onTap: () => _handleNavigation(context, index),
                );
              },
            ),
          ),

          // Sección inferior para configuración y cerrar sesión
          const Divider(height: 1),

          ListTile(
            leading: Icon(Icons.settings, color: inactiveIconColor, size: 24),
            title: Text('Configuración', style: TextStyle(color: textColor)),
            onTap: () => context.push(AppRouter.settings),
          ),

          ListTile(
            leading: Icon(Icons.logout, color: inactiveIconColor, size: 24),
            title: Text('Cerrar sesión', style: TextStyle(color: textColor)),
            onTap: () {
              // Mostrar diálogo de confirmación
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Cerrar sesión'),
                    content: const Text(
                      '¿Estás seguro de que quieres cerrar sesión?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          // Cerrar sesión de forma simple: navegar al login
                          try {
                            context.go(AppRouter.login);
                          } catch (e) {
                            if (kDebugMode) {
                              print('Error navegando a login: $e');
                            }
                          }
                        },
                        child: const Text('Cerrar sesión'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget para mostrar el perfil del usuario en la parte superior
  Widget _buildUserProfile(
    BuildContext context,
    bool isDarkMode,
    Color textColor,
  ) {
    // En lugar de intentar acceder al AuthCubit, mostramos siempre un perfil genérico
    // Esto evita completamente el error de Provider
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(Icons.account_circle, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            '¿Quién Para?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              try {
                context.go(AppRouter.profile);
              } catch (e) {
                if (kDebugMode) {
                  print('Error navegando al perfil: $e');
                }
              }
            },
            child: Text(
              'Ver perfil',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.brandYellow),
            ),
          ),
        ],
      ),
    );
  }
}
