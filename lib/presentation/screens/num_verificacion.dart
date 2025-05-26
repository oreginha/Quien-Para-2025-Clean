// ignore_for_file: always_specify_types, prefer_final_locals, inference_failure_on_instance_creation

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';

class NumVerificacion extends StatefulWidget {
  const NumVerificacion({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NumVerificacionState createState() => _NumVerificacionState();
}

mixin NumVerificacionState {}

class _NumVerificacionState extends State<NumVerificacion> {
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _cityCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  // ignore: unused_field
  final TextEditingController _verificationCodeController =
      TextEditingController();

  String selectedCountryCode = '+54'; // Código de área predeterminado

  @override
  // #region verificacion de telefono
  Widget build(final BuildContext context) {
    // Definir el AppBar que se usará tanto en móvil como en web
    final appBar = AppBar(title: const Text('Verificación de Teléfono'));

    // Definir el contenido principal
    final content = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Desplegable para seleccionar el país
          DropdownButtonFormField<String>(
            value: selectedCountryCode,
            decoration: const InputDecoration(labelText: 'Selecciona tu país'),
            items: const [
              DropdownMenuItem(value: '+54', child: Text('Argentina (+54)')),
              DropdownMenuItem(value: '+1', child: Text('Estados Unidos (+1)')),
              DropdownMenuItem(value: '+34', child: Text('España (+34)')),
              // Agrega más países aquí
            ],
            onChanged: (final value) {
              setState(() {
                selectedCountryCode = value!;
                _countryCodeController.text = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Campo para ingresar el código de la ciudad
          TextField(
            controller: _cityCodeController,
            decoration: const InputDecoration(
              labelText: 'Código de área de la ciudad',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Campo para ingresar el número de teléfono
          TextField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(labelText: 'Número de teléfono'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          // Botón para enviar el código de verificación
          ElevatedButton(
            onPressed: () {
              if (_cityCodeController.text.isNotEmpty &&
                  _phoneNumberController.text.isNotEmpty) {
                String fullNumber =
                    '$selectedCountryCode${_cityCodeController.text}${_phoneNumberController.text}';
                // Simula el envío del código de verificación
                if (kDebugMode) {
                  print('Enviando código a $fullNumber');
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (final context) =>
                        VerificationScreen(phoneNumber: fullNumber),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Completa todos los campos correctamente.'),
                  ),
                );
              }
            },
            child: const Text('Enviar código de verificación'),
          ),
        ],
      ),
    );

    // Usar NewResponsiveScaffold para tener un diseño consistente
    return NewResponsiveScaffold(
      screenName: 'phone_verification',
      appBar: appBar,
      body: content,
      currentIndex: -1, // No está en la barra de navegación
      webTitle: 'Verificación de Teléfono',
    );
  }
} // #endregion verificacion de telefono

// #region verificationScreen
class VerificationScreen extends StatelessWidget {
  final String phoneNumber;

  VerificationScreen({super.key, required this.phoneNumber});

  final TextEditingController _verificationCodeController =
      TextEditingController();

  @override
  Widget build(final BuildContext context) {
    // Definir el AppBar que se usará tanto en móvil como en web
    final appBar = AppBar(title: const Text('Verificar Código'));

    // Definir el contenido principal
    final content = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Se ha enviado un código a $phoneNumber',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          // Campo para ingresar el código de verificación
          TextField(
            controller: _verificationCodeController,
            decoration: const InputDecoration(
              labelText: 'Código de verificación',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          // Botón para verificar el código
          ElevatedButton(
            onPressed: () {
              String code = _verificationCodeController.text;
              if (code.length == 6) {
                // Simula la verificación del código
                if (kDebugMode) {
                  print('Código ingresado: $code');
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Código verificado exitosamente.'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Código inválido. Intenta de nuevo.'),
                  ),
                );
              }
            },
            child: const Text('Verificar'),
          ),
        ],
      ),
    );

    // Usar NewResponsiveScaffold para tener un diseño consistente
    return NewResponsiveScaffold(
      screenName: 'verification_code',
      appBar: appBar,
      body: content,
      currentIndex: -1, // No está en la barra de navegación
      webTitle: 'Verificar Código',
    );
  }
}

// #endregion verificationScreen
