// test/setup_test.dart
// ignore_for_file: always_specify_types

import 'package:flutter_test/flutter_test.dart';
import 'helpers/firebase_test_utils.dart';

/// Este archivo debe ser importado en todos los archivos de prueba que requieran Firebase
/// Ejemplo: import '../setup_test.dart' as setup;
///
/// Y luego en el setUp de cada prueba:
/// setUp(() async {
///   await setup.setupFirebaseForTesting();
///   // Resto del código de configuración
/// });

/// Configura Firebase para pruebas
Future<void> setupFirebaseForTesting() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await FirebaseTestUtils.initializeFirebase();
}
