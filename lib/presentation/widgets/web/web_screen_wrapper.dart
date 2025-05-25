// lib/presentation/widgets/web/web_screen_wrapper.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/responsive/side_menu.dart';

/// Componente wrapper para la versión web que embebe pantallas móviles
/// Mantiene una barra lateral consistente y muestra las pantallas móviles en el área principal
/// con un ancho limitado similar a un dispositivo móvil, como en Bumble
class WebScreenWrapper extends StatefulWidget {
  /// Contenido principal (pantalla móvil a embeber)
  final Widget child;

  /// Índice actual de navegación
  final int currentIndex;

  /// Callback cuando cambia la navegación
  final Function(int)? onTap;

  /// AppBar opcional (normalmente null para mantener consistencia)
  final PreferredSizeWidget? appBar;

  /// Título de la pantalla embebida (se mostrará en la AppBar del contenedor web)
  final String title;

  /// Floating action button opcional
  final Widget? floatingActionButton;

  /// Posición del floating action button
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const WebScreenWrapper({
    super.key,
    required this.child,
    required this.currentIndex,
    this.onTap,
    this.appBar,
    this.title = '',
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  State<WebScreenWrapper> createState() => _WebScreenWrapperState();
}

class _WebScreenWrapperState extends State<WebScreenWrapper> {
  // Creamos nuestra propia instancia de ThemeProvider como fallback
  late ThemeProvider _fallbackThemeProvider;

  @override
  void initState() {
    super.initState();
    _fallbackThemeProvider = ThemeProvider();
  }

  @override
  Widget build(BuildContext context) {
    // Intentar obtener el tema del Provider general, con fallback a nuestro provider local
    ThemeProvider themeProvider;

    try {
      // Intentar obtener el ThemeProvider desde el contexto
      themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    } catch (e) {
      // Si falla, usar nuestro provider fallback
      themeProvider = _fallbackThemeProvider;

      // Solo para debug, mostrar que estamos usando el fallback
      if (kDebugMode) {
        print('WebScreenWrapper: Usando ThemeProvider fallback');
      }
    }

    final isDarkMode = themeProvider.isDarkMode;

    // Colores basados en el tema activo
    final Color backgroundColor =
        isDarkMode ? AppColors.darkBackground : Colors.white;
    final Color textColor =
        isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    // Ancho máximo para el contenido de la pantalla móvil (similar a Bumble)
    const double mobileContentWidth = 450.0;

    // Ancho de la barra lateral
    const double sidebarWidth = 250.0;

    // Envolver en un ChangeNotifierProvider para asegurar que el tema esté disponible
    // para los widgets hijos, incluso si el Provider principal no está disponible
    Widget scaffold = ChangeNotifierProvider<ThemeProvider>.value(
      value: themeProvider,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menú lateral fijo para la versión web
            SizedBox(
              width: sidebarWidth,
              child: SideMenu(
                currentIndex: widget.currentIndex,
                onTap: widget.onTap,
              ),
            ),
            // Contenido principal (ocupa todo el espacio restante)
            Expanded(
              child: Scaffold(
                appBar: widget.appBar ??
                    (widget.title.isNotEmpty
                        ? AppBar(
                            title: Text(
                              widget.title,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor:
                                backgroundColor, // Usar backgroundColor definido
                            elevation: 0,
                          )
                        : null),
                body: Center(
                  child: Container(
                    width: mobileContentWidth,
                    height: double.infinity,
                    color: backgroundColor,
                    child: widget.child,
                  ),
                ),
                backgroundColor: backgroundColor,
                floatingActionButton: widget.floatingActionButton,
                floatingActionButtonLocation:
                    widget.floatingActionButtonLocation,
              ),
            ),
          ],
        ),
      ),
    );
    return scaffold;
  }
}
