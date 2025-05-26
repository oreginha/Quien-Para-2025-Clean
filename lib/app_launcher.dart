// lib/app_launcher.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/config/firebase_options.dart'; // Importamos las opciones de Firebase

/// Esta aplicación es un selector que permite elegir entre diferentes modos
/// de inicialización para facilitar la depuración
class AppLauncher extends StatelessWidget {
  const AppLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selector de Modos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AppSelectorScreen(),
    );
  }
}

class AppSelectorScreen extends StatelessWidget {
  const AppSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selector de Modo de Aplicación'),
        backgroundColor: Colors.blue[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.app_settings_alt, size: 60, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Seleccione el modo de inicio de la aplicación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildModeButton(
              context,
              title: 'Modo Normal',
              description:
                  'Inicia la aplicación con todas las dependencias normales',
              color: Colors.green,
              icon: Icons.check_circle,
              onPressed: () => _launchNormalMode(context),
            ),
            const SizedBox(height: 16),
            _buildModeButton(
              context,
              title: 'Modo Progresivo',
              description:
                  'Inicia con servicios básicos y permite habilitar casos de uso gradualmente',
              color: Colors.orange,
              icon: Icons.settings,
              onPressed: () => _launchProgressiveMode(context),
            ),
            const SizedBox(height: 16),
            _buildModeButton(
              context,
              title: 'Modo Emergencia Extrema',
              description: 'Inicia sin ninguna dependencia (modo mínimo)',
              color: Colors.red,
              icon: Icons.warning,
              onPressed: () => _launchExtremeEmergencyMode(context),
            ),
            const SizedBox(height: 40),
            const Text(
              'Utilice este selector para diagnosticar y resolver problemas con la inicialización',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context, {
    required String title,
    required String description,
    required MaterialColor color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.shade50,
          foregroundColor: color.shade700,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: color.shade300),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, color: color.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchNormalMode(BuildContext context) async {
    _showLoadingDialog(context, 'Iniciando en Modo Normal');

    try {
      // Importamos dinámicamente para evitar problemas de inicialización temprana
      // Si se usa import directo, las clases se inicializan aunque no se usen
      await Future.delayed(const Duration(seconds: 1));
      if (kDebugMode) {
        print('🔵 Redirigiendo al Modo Normal');
      }

      // Sustituir este Navigator.pop y pushReplacement por la lógica real
      // para cargar main.dart en una implementación completa
      Navigator.pop(context); // Cerrar diálogo

      // Mostrar snackbar por ahora, ya que no podemos importar directamente aquí
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Para cambiar al modo normal, modifique flutter run para usar main.dart',
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Cerrar diálogo
      _showErrorDialog(context, e.toString());
    }
  }

  void _launchProgressiveMode(BuildContext context) async {
    _showLoadingDialog(context, 'Iniciando en Modo Progresivo');

    try {
      // Importamos dinámicamente
      await Future.delayed(const Duration(seconds: 1));
      if (kDebugMode) {
        print('🟠 Redirigiendo al Modo Progresivo');
      }

      // Sustituir este Navigator.pop y pushReplacement por la lógica real
      // para cargar main_progressive.dart en una implementación completa
      Navigator.pop(context); // Cerrar diálogo

      // Mostrar snackbar por ahora
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Para cambiar al modo progresivo, modifique flutter run para usar main_progressive.dart',
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Cerrar diálogo
      _showErrorDialog(context, e.toString());
    }
  }

  void _launchExtremeEmergencyMode(BuildContext context) async {
    _showLoadingDialog(context, 'Iniciando en Modo Emergencia Extrema');

    try {
      // Importamos dinámicamente
      await Future.delayed(const Duration(seconds: 1));
      if (kDebugMode) {
        print('🔴 Redirigiendo al Modo Emergencia Extrema');
      }

      // Sustituir este Navigator.pop y pushReplacement por la lógica real
      Navigator.pop(context); // Cerrar diálogo

      // Mostrar snackbar por ahora
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Para cambiar al modo emergencia extrema, utilice el main.dart actual',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Cerrar diálogo
      _showErrorDialog(context, e.toString());
    }
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error de Inicialización'),
        content: Text(
          'Ocurrió un error al iniciar la aplicación:\n$errorMessage',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Punto de entrada para el lanzador de la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inicializar Firebase (necesario para cualquier modo)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(const AppLauncher());
  } catch (e) {
    if (kDebugMode) {
      print('❌ Error inicializando AppLauncher: $e');
    }

    // Pantalla de error simple
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.blue[100],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                const Text(
                  'ERROR DEL LANZADOR',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  e.toString(),
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
