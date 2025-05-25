// lib/presentation/screens/example/responsive_example_screen.dart
import 'package:flutter/material.dart';
import 'package:quien_para/core/utils/platform_utils.dart';
import 'package:quien_para/presentation/widgets/common/platform_aware_bottom_nav.dart';
import 'package:quien_para/presentation/widgets/responsive/responsive_layout.dart';

/// Pantalla de ejemplo que muestra cómo implementar el nuevo enfoque responsive
class ResponsiveExampleScreen extends StatefulWidget {
  const ResponsiveExampleScreen({super.key});

  @override
  State<ResponsiveExampleScreen> createState() =>
      _ResponsiveExampleScreenState();
}

class _ResponsiveExampleScreenState extends State<ResponsiveExampleScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Este es el contenido real de la pantalla (contenido "móvil")
    // En la versión web, este contenido se mostrará embebido en el WebScreenWrapper
    final Widget mobileContent = Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo Responsive'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Esta es una pantalla de ejemplo',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              PlatformUtils.isWeb
                  ? 'Estás viendo la versión web embebida'
                  : 'Estás viendo la versión móvil',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Acción de ejemplo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Botón presionado!')),
                );
              },
              child: const Text('Botón de ejemplo'),
            ),
          ],
        ),
      ),
      // La barra de navegación inferior solo se mostrará en la versión móvil
      bottomNavigationBar: PlatformAwareBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );

    // Para pantallas que no necesitan una versión web muy personalizada,
    // podemos usar el constructor factory ResponsiveLayout.autoWrap
    return ResponsiveLayout.autoWrap(
      mobileLayout: mobileContent,
      webTitle: 'Ejemplo Responsive',
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );

    // Alternativamente, podríamos usar el constructor normal con más control:
    /*
    return ResponsiveLayout(
      mobileLayout: mobileContent,
      webLayout: WebScreenWrapper(
        child: mobileContent,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        title: 'Ejemplo Responsive',
      ),
    );
    */
  }
}
