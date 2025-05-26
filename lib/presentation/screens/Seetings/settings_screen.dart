// lib/presentation/screens/settings/settings_screen.dart
// ignore_for_file: deprecated_member_use, inference_failure_on_function_invocation, strict_raw_type, always_specify_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';
import 'package:quien_para/presentation/widgets/theme/theme_toggle.dart';
import '../../bloc/auth/auth_cubit.dart';
import '../../routes/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:quien_para/presentation/widgets/buttons/theme_aware_button.dart';
import 'package:quien_para/presentation/widgets/cards/theme_aware_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Método para mostrar diálogo de confirmación de eliminación de cuenta
  void _showDeleteAccountConfirmation(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Eliminar cuenta', style: TextStyle(color: textColor)),
          content: const Text(
            '¿Estás seguro que deseas eliminar tu cuenta? Esta acción no se puede deshacer y perderás todos tus datos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Llamar al método de eliminación de cuenta
                // Usar el método logout() ya que deleteAccount() no está implementado
                // En una implementación completa, aquí iría el código para eliminar la cuenta
                context.read<AuthCubit>().logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad en desarrollo')),
                );
              },
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Método para mostrar diálogo de información de la aplicación
  void _showAboutDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AboutDialog(
          applicationName: 'Quien Para',
          applicationVersion: '1.0.0',
          applicationIcon: Image.asset(
            'assets/images/app_icon.png',
            width: 48,
            height: 48,
          ),
          applicationLegalese:
              '© 2025 Quien Para. Todos los derechos reservados.',
          children: [
            const SizedBox(height: 24),
            Text(
              'Quien Para es una aplicación para encontrar compañía para tus actividades y planes.',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Determinar colores basados en el tema
    final Color backgroundColor = isDarkMode
        ? const Color(0xFF1E293B) // Fondo para tema oscuro
        : const Color(0xFFF7FAFC); // Fondo para tema claro

    return NewResponsiveScaffold(
      screenName: AppRouter.settings,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Configuración',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      darkPrimaryBackground: backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // Sección para cambiar el tema
          const ThemeToggle(),

          // Sección de desarrollo con ThemeAwareCard
          ThemeAwareCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Desarrollo',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ThemeAwareButton(
                  iconLeft: Icons.color_lens,
                  text: 'Demostración de Temas',
                  onPressed: () {
                    context.push(AppRouter.themeShowcase);
                  },
                ),
              ],
            ),
          ),

          // Configuración de cuenta
          ThemeAwareCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cuenta', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                ThemeAwareButton(
                  iconLeft: Icons.edit,
                  text: 'Editar perfil',
                  onPressed: () {
                    context.push(AppRouter.editProfile);
                  },
                ),
                const SizedBox(height: 8),
                ThemeAwareButton(
                  iconLeft: Icons.notifications,
                  text: 'Preferencias de notificaciones',
                  onPressed: () {
                    // Añadir funcionalidad de configuración de notificaciones
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente disponible')),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ThemeAwareButton(
                  iconLeft: Icons.logout,
                  text: 'Cerrar Sesión',
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                  },
                ),
                const SizedBox(height: 8),
                ThemeAwareButton(
                  iconLeft: Icons.delete_forever,
                  text: 'Eliminar cuenta',
                  // Usando un estilo diferente con color rojo para indicar acción destructiva
                  onPressed: () {
                    _showDeleteAccountConfirmation(context);
                  },
                ),
              ],
            ),
          ),

          // Configuración de privacidad
          ThemeAwareCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacidad y seguridad',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ThemeAwareButton(
                  iconLeft: Icons.privacy_tip,
                  text: 'Política de privacidad',
                  onPressed: () {
                    // Añadir navegación a la política de privacidad
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente disponible')),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ThemeAwareButton(
                  iconLeft: Icons.security,
                  text: 'Términos y condiciones',
                  onPressed: () {
                    // Añadir navegación a los términos y condiciones
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente disponible')),
                    );
                  },
                ),
              ],
            ),
          ),

          // Soporte y ayuda
          ThemeAwareCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Soporte', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                ThemeAwareButton(
                  iconLeft: Icons.help,
                  text: 'Centro de ayuda',
                  onPressed: () {
                    // Añadir navegación al centro de ayuda
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente disponible')),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ThemeAwareButton(
                  iconLeft: Icons.feedback,
                  text: 'Enviar comentarios',
                  onPressed: () {
                    // Añadir funcionalidad de envío de comentarios
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente disponible')),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ThemeAwareButton(
                  iconLeft: Icons.info,
                  text: 'Acerca de',
                  onPressed: () {
                    _showAboutDialog(context, isDarkMode);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      currentIndex: -1, // No está en la barra de navegación
      webTitle: 'Configuración',
    );
  }
}
