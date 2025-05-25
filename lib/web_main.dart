// Punto de entrada para la versión web de la aplicación - MODO EMERGENCIA EXTREMA
import 'package:flutter/material.dart';

// Aplicación de emergencia extrema sin dependencias

// Punto de entrada web extremadamente simplificado
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Pantalla de error absolutamente mínima
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.red[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  ));
}
