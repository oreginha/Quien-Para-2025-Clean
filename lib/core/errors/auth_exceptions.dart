// lib/core/errors/auth_exceptions.dart

/// Excepción base para errores de autenticación
class AuthException implements Exception {
  final String message;
  
  const AuthException(this.message);
  
  @override
  String toString() => message;
}

/// Excepción para errores generales de autenticación
class AuthenticationException extends AuthException {
  const AuthenticationException(super.message);
}

/// Excepción para cuando el usuario cancela el proceso de autenticación
class AuthCancelledException extends AuthException {
  const AuthCancelledException(super.message);
}

/// Excepción para problemas de red durante la autenticación
class NetworkException extends AuthException {
  const NetworkException(super.message);
}

/// Excepción para errores de validación de datos del usuario
class UserDataException extends AuthException {
  const UserDataException(super.message);
}

/// Excepción para errores de permisos
class PermissionException extends AuthException {
  const PermissionException(super.message);
}
