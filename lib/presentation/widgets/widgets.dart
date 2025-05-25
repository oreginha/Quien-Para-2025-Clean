// ignore_for_file: use_build_context_synchronously, duplicate_ignore, inference_failure_on_instance_creation, always_specify_types

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/theme_utils.dart';
import 'package:quien_para/presentation/routes/app_router.dart';
import 'package:quien_para/presentation/screens/num_verificacion.dart';
import "google_sign_in_button.dart";
export 'utils/custom_dropdown.dart';
export "utils/date_picker.dart";
export "utils/custom_time_picker.dart";

// #region widgets pantalla login
Widget fondoPantalla(final BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('lib/assets/fondo.png'), // Cambia por tu imagen
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget botonesInicioSesion(final BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 20), // Espaciado entre elementos
        iconosSesion(context),
      ],
    ),
  );
}

Widget titleTextLocal({
  required String text,
  Color? color,
  double fontSize = 28,
  TextAlign textAlign = TextAlign.center,
}) {
  // Usar el valor por defecto solo si no se proporciona
  color = ThemeUtils as Color?;
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'PlayfairDisplay',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    ),
    textAlign: textAlign,
  );
}

Widget iconosSesion(final BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0),
    child: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          const Text(
            'Inicia sesión con',
            style: TextStyle(
              color: Color.fromARGB(179, 24, 23, 23),
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 20),
          // Botón Google
          GoogleSignInButton(
            onSignInSuccess: (final user) {
              Navigator.pushReplacementNamed(
                  context, AppRouter.login); // Cambia por tu ruta
            },
          ),
          const SizedBox(height: 15),
          // Botón Facebook
          /*ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              darkPrimaryBackground: Colors.blue, // Color de Facebook
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: FaIcon(
              FontAwesomeIcons.facebook,
              color: Colors.white,
            ),
            label: Text(
              "Facebook",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              try {
                final user = await AuthRepository().signInWithFacebook();
                if (user != null) {
                  Navigator.pushReplacementNamed(
                      context, '/home'); // Cambia por tu ruta
                }
              } catch (e) {
                // Maneja errores de autenticación
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al iniciar sesión con Facebook: $e'),
                  ),
                );
              }
            },
          ),*/
          const SizedBox(height: 20),
          // Botón Teléfono
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final BuildContext context) =>
                      const NumVerificacion(), // Reemplaza con tu widget correcto
                ),
              );
            },
            child: const Text('Iniciar sesión con teléfono'),
          ),
        ],
      ),
    ),
  );
}
// #endregion
