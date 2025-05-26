// lib/presentation/screens/Login/login_screen.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/theme_utils.dart';
import 'package:quien_para/presentation/widgets/buttons/theme_aware_button.dart';
import 'package:quien_para/presentation/widgets/theme/theme_switch.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';
import '../../../core/utils/auth_debugger.dart';
import '../../bloc/auth/auth_cubit.dart';
import '../../bloc/auth/auth_state.dart';
import '../../routes/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variable para controlar si el widget está montado
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _mounted = true;
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  // Método seguro para navegación que verifica si el widget está montado
  void _safeNavigate(BuildContext context, String route) {
    if (_mounted) {
      context.navigateTo(route);
    } else {
      AuthDebugger.log('LoginScreen: No se puede navegar, widget no montado');
    }
  }

  // Método seguro para autenticación con Google
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    AuthDebugger.log('LoginScreen: Botón de Google presionado');

    // Obtener referencia segura a AuthCubit antes de iniciar proceso asíncrono
    final authCubit = context.read<AuthCubit>();

    try {
      await authCubit.signInWithGoogle();

      // Verificar si el widget sigue montado
      if (!_mounted) {
        AuthDebugger.log(
          'LoginScreen: Widget no montado después de autenticación',
        );
        return;
      }

      // Verificar el estado actual
      final authState = authCubit.state;

      // Si la autenticación fue exitosa, navegar
      if (authState.status == AuthStatus.authenticated) {
        AuthDebugger.log('Login exitoso, navegando...');

        if (!authState.hasUserProfile) {
          // Si no tiene perfil, ir a onboarding
          _safeNavigate(context, AppRouter.userOnboarding);
        } else {
          // Si tiene perfil, ir a propuestas
          _safeNavigate(context, AppRouter.proposalsScreen);
        }
      }
    } catch (e) {
      // Mostrar error solo si el widget sigue montado
      if (_mounted) {
        AuthDebugger.log('Error en autenticación con Google: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de autenticación: $e'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    AuthDebugger.log('LoginScreen: build() llamado');

    // En la pantalla de login siempre usamos el fondo oscuro
    // independientemente del tema, ya que tenemos una imagen de fondo
    final darkPrimaryBackground = const Color(0xFF1A1B2E);

    // Creamos el contenido principal que será utilizado por NewResponsiveScaffold
    final content = Stack(
      children: <Widget>[
        // Background image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/images/a-login-screen.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Botón de cambio de tema en la esquina superior derecha
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ThemeModeIcon(size: 28, showBorder: true),
              ),
            ),

            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: ThemeAwareButton(
                          text: 'Continuar con Google',
                          iconLeft: Icons.login,
                          variant: ButtonVariant.primary,
                          isFullWidth: true,
                          onPressed: () => _handleGoogleSignIn(context),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Agregar botón de inicio con teléfono
                    Center(
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: ThemeAwareButton(
                          text: 'Ingresar con teléfono',
                          iconLeft: Icons.phone_android,
                          variant: ButtonVariant.outline,
                          isFullWidth: true,
                          onPressed: () {
                            // Navegación a pantalla de autenticación por teléfono usando GoRouter
                            if (_mounted) {
                              context.navigateTo(AppRouter.phoneAuth);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Error listener
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (AuthState previous, AuthState current) =>
              previous.status != current.status &&
              current.status == AuthStatus.error,
          listener: (BuildContext context, AuthState state) {
            AuthDebugger.log(
              'LoginScreen: Error detectado: ${state.errorMessage}',
            );

            if (_mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Error de autenticación'),
                  backgroundColor: AppColors.accentRed,
                ),
              );
            }
          },
          child: const SizedBox.shrink(), // Añadido child requerido
        ),

        // Loading overlay
        BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (AuthState previous, AuthState current) =>
              previous.status != current.status &&
              (current.status == AuthStatus.loading ||
                  previous.status == AuthStatus.loading),
          builder: (BuildContext context, AuthState state) {
            if (state.status == AuthStatus.loading) {
              AuthDebugger.log('LoginScreen: Mostrando indicador de carga');

              return Container(
                color: Colors.black.withAlpha(128), // 0.5 * 255 = 128
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ThemeUtils.brandYellow,
                    ),
                  ),
                ),
              );
            }
            AuthDebugger.log('LoginScreen: Estado normal (no cargando)');
            return const SizedBox.shrink();
          },
        ),
      ],
    );

    // Usar NewResponsiveScaffold para implementar la estrategia responsive
    return NewResponsiveScaffold(
      screenName: 'login',
      body: content,
      darkPrimaryBackground: darkPrimaryBackground,
      currentIndex: -1, // No está en la barra de navegación
      webTitle: 'Iniciar Sesión',
      // No usamos appBar para esta pantalla
      extendBodyBehindAppBar: true,
      extendBody: true,
    );
  }
}
