// Este archivo contiene las definiciones faltantes que deben ser incluidas
// en el archivo app_router.dart para corregir los errores

// Definir la clase AppRouter si no existe
import 'package:quien_para/presentation/bloc/auth/auth_cubit.dart';

class AppRouterHelper {
  // Referencia al AuthCubit que debe estar definida en la clase AppRouter
  static AuthCubit? authCubit;

  // Definición de rutas estáticas
  static const String root = '/';
  static const String proposalsScreen = '/proposalsScreen';
  static const String login = '/login';
  static const String home = '/home';
  static const String userOnboarding = '/user-onboarding';
}
