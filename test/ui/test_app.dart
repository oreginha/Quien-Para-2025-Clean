// test/ui/test_app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:get_it/get_it.dart';
import 'mock_theme_provider.dart';

// Mock de toda la aplicación para pruebas de UI aisladas
class TestApp extends StatelessWidget {
  final Widget child;

  const TestApp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<ThemeProvider>(
        create: (_) => MockThemeProvider(isDarkMode: false),
        child: Scaffold(body: child),
      ),
    );
  }
}

// Setup para pruebas que no usen la inyección de dependencias
Future<void> setupIsolatedTestEnvironment() async {
  // No usamos GetIt.instance (sl) para evitar conflictos con la app real
  final GetIt testLocator = GetIt.asNewInstance();

  // Configurar preferentemente variables de entorno para indicar que estamos en modo test
  testLocator.registerSingleton<bool>(true, instanceName: 'isTestEnvironment');

  // Puedes agregar configuraciones adicionales aquí si es necesario

  // Esta configuración no interactúa con la instancia global de GetIt
  // utilizada por la aplicación real
}

// Limpiar el entorno de prueba
Future<void> tearDownIsolatedTestEnvironment() async {
  // Limpiar recursos si es necesario
}
