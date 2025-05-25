// lib/scripts/firebase_initializer_cli.dart
// ignore_for_file: avoid_print

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'initialize_firebase_collections.dart';

/// Script para inicializar Firebase desde la línea de comandos
///
/// Este script permite crear automáticamente las colecciones en Firebase
/// con la estructura definida en los modelos de datos.
///
/// Uso: dart run lib/scripts/firebase_initializer_cli.dart
Future<void> main() async {
  print('=== Inicializador de Colecciones de Firebase ===');
  print('Inicializando Firebase...');

  try {
    // Inicializar Firebase
    await Firebase.initializeApp();

    print('Firebase inicializado correctamente.');
    print('Creando colecciones y documentos de ejemplo...');

    // Inicializar colecciones
    await initializeFirebaseCollections();

    print('\n=== Proceso completado con éxito ===');
    print('Las colecciones han sido creadas en Firebase.');
    print(
        'Se ha generado un archivo JSON con la estructura en la carpeta firebase_export.');
  } catch (e) {
    print('\n=== ERROR ===');
    print('Ocurrió un error durante la inicialización: $e');
  } finally {
    // Salir del programa
    exit(0);
  }
}
