// lib/presentation/screens/phone_auth_screen.dart
import 'package:flutter/material.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _codeSent = false;

  @override
  Widget build(final BuildContext context) {
    // Definir el AppBar que se usará tanto en móvil como en web
    final appBar = AppBar(title: const Text('Verificación de teléfono'));

    // Definir el contenido principal
    final content = Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!_codeSent) ...<Widget>[
            const Text(
              'Ingresa tu número de teléfono',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
                hintText: '+54 11 1234-5678',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí implementar la lógica de envío de código
                  setState(() => _codeSent = true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Enviar código',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ] else ...<Widget>[
            const Text(
              'Ingresa el código de verificación',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Código de 6 dígitos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí implementar la verificación del código
                  // Si es exitoso, navegar al onboarding o al feed
                  Navigator.pushReplacementNamed(context, '/user-onboarding');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Verificar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    // Usar NewResponsiveScaffold para tener un diseño consistente
    return NewResponsiveScaffold(
      screenName: 'phone_auth',
      appBar: appBar,
      body: content,
      currentIndex: -1, // No está en la barra de navegación
      webTitle: 'Verificación de teléfono',
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}
