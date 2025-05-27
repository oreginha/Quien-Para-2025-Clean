// lib/presentation/widgets/responsive/web_layout.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/responsive/side_menu.dart';

/// Layout para la versión web de la aplicación
/// Muestra un menú lateral y el contenido principal en una disposición horizontal
class WebLayout extends StatefulWidget {
  final Widget body;
  final int currentIndex;
  final Function(int)? onTap;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const WebLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    this.onTap,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  @override
  Widget build(BuildContext context) {
    // Obtener el tema actual
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Colores basados en el tema activo
    final Color backgroundColor =
        isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;

    Widget scaffold = Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          // Menú lateral
          SideMenu(currentIndex: widget.currentIndex, onTap: widget.onTap),
          // Contenido principal
          Expanded(
            child: Scaffold(
              appBar: widget.appBar,
              body: widget.body,
              floatingActionButton: widget.floatingActionButton,
              floatingActionButtonLocation: widget.floatingActionButtonLocation,
              // No mostramos bottomNavigationBar en la versión web
            ),
          ),
        ],
      ),
    );
    return scaffold;
  }
}
