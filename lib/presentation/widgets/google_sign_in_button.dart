import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quien_para/data/datasources/auth_data_source.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key, required this.onSignInSuccess});

  final Function(UserEntity user) onSignInSuccess;

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  // Utilizar el AuthDataSource para manejar la autenticación
  final AuthDataSource _authDataSource = GetIt.instance<AuthDataSource>();
  bool _isLoading = false;

  Future<void> _handleSignIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Usar el método de autenticación con Google
      final user = await _authDataSource.signInWithGoogle();

      // Llamar al callback de éxito
      widget.onSignInSuccess(user);
    } catch (error) {
      // ignore: avoid_print
      print('Error en el inicio de sesión: $error');

      // Mostrar un mensaje de error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return ElevatedButton(
      onPressed:
          _isLoading ? null : _handleSignIn, // Deshabilitar durante la carga
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Iniciar sesión con Google'),
    );
  }
}
