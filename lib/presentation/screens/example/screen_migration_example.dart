// lib/presentation/screens/example/screen_migration_example.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/core/utils/platform_utils.dart';
import 'package:quien_para/presentation/widgets/common/platform_aware_bottom_nav.dart';
import 'package:quien_para/presentation/widgets/responsive/responsive_layout.dart';

/// Este archivo muestra cómo migrar una pantalla existente al nuevo patrón responsive
///
/// Antes:
/// ```
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     appBar: AppBar(title: Text('Mi Pantalla')),
///     body: Column(
///       children: [
///         // contenido...
///       ],
///     ),
///     bottomNavigationBar: BottomNavBar(
///       currentIndex: _currentIndex,
///       onTap: (index) => setState(() => _currentIndex = index),
///     ),
///   );
/// }
/// ```
///
/// Después:
/// ```
/// @override
/// Widget build(BuildContext context) {
///   // 1. Extraer el contenido original de la pantalla
///   final Widget mobileContent = Scaffold(
///     appBar: AppBar(title: Text('Mi Pantalla')),
///     body: Column(
///       children: [
///         // contenido...
///       ],
///     ),
///     // 2. Reemplazar BottomNavBar por PlatformAwareBottomNav
///     bottomNavigationBar: PlatformAwareBottomNav(
///       currentIndex: _currentIndex,
///       onTap: (index) => setState(() => _currentIndex = index),
///     ),
///   );
///
///   // 3. Envolver con ResponsiveLayout.autoWrap
///   return ResponsiveLayout.autoWrap(
///     mobileLayout: mobileContent,
///     webTitle: 'Mi Pantalla',
///     currentIndex: _currentIndex,
///     onTap: (index) => setState(() => _currentIndex = index),
///   );
/// }
/// ```
class MigrationExampleScreen extends StatefulWidget {
  const MigrationExampleScreen({super.key});

  @override
  State<MigrationExampleScreen> createState() => _MigrationExampleScreenState();
}

class _MigrationExampleScreenState extends State<MigrationExampleScreen> {
  int _currentIndex = 2; // Índice para Home por defecto

  @override
  Widget build(BuildContext context) {
    // Obtener el tema actual
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // PASO 1: Extraer el contenido original de la pantalla
    final Widget mobileContent = Scaffold(
      appBar: AppBar(title: const Text('Ejemplo de Migración'), elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'Este es un ejemplo de cómo migrar una pantalla existente',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              PlatformUtils.isWeb
                  ? 'Estás viendo la versión WEB'
                  : 'Estás viendo la versión MÓVIL',
              style: TextStyle(
                color: isDarkMode ? Colors.amber : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Funcionó! La pantalla está migrada'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Comprobar migración'),
            ),
          ],
        ),
      ),
      // PASO 2: Reemplazar BottomNavBar por PlatformAwareBottomNav
      bottomNavigationBar: PlatformAwareBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );

    // PASO 3: Envolver con ResponsiveLayout.autoWrap
    return ResponsiveLayout.autoWrap(
      mobileLayout: mobileContent,
      webTitle: 'Ejemplo de Migración',
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
    );
  }
}
