// lib/presentation/screens/auth/auth_wrapper.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/presentation/bloc/auth/auth_cubit.dart';
import 'package:quien_para/presentation/bloc/auth/auth_state.dart';
import 'package:quien_para/presentation/screens/Login/login_screen.dart';
import 'package:quien_para/presentation/screens/user_onboarding/user_onboarding_screen.dart';
import 'package:quien_para/presentation/screens/home/home_screen.dart';
import 'package:quien_para/core/theme/app_colors.dart';

/// AuthWrapper sirve como punto de entrada principal a la aplicación
/// y maneja la lógica de redirección basada en el estado de autenticación
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('🔄 AuthWrapper: Verifying authentication status');
    }

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Depuracion
        if (kDebugMode) {
          print('🔐 AuthWrapper: Auth state - ${state.status}');
        }

        // Mostrar indicador de carga mientras se verifica el estado
        if (state.status == AuthStatus.initial ||
            state.status == AuthStatus.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.brandYellow),
              ),
            ),
          );
        }

        // Si el usuario no está autenticado, mostrar la pantalla de login
        if (state.status == AuthStatus.unauthenticated ||
            state.status == AuthStatus.error) {
          return const LoginScreen();
        }

        // Si el usuario está autenticado pero no tiene perfil, ir a onboarding
        if (state.status == AuthStatus.authenticated && !state.hasUserProfile) {
          return const UserOnboardingScreen();
        }

        // Si el usuario está autenticado y tiene perfil, ir a la pantalla principal
        return const HomeScreen();
      },
    );
  }
}
