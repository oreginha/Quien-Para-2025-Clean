/// Base para todas las excepciones de la aplicación
abstract class AppException implements Exception {
  final String message;
  
  AppException(this.message);
  
  @override
  String toString() => message;
}

/// Excepción para problemas de red
class NetworkException extends AppException {
  NetworkException([super.message = 'Problema de conexión a la red']);
}

/// Excepción para problemas de autenticación
class AuthException extends AppException {
  AuthException([super.message = 'Error de autenticación']);
}

/// Excepción para problemas de validación
class ValidationException extends AppException {
  ValidationException([super.message = 'Datos de entrada inválidos']);
}

/// Excepción para operaciones que tardan demasiado
class TimeoutException extends AppException {
  TimeoutException([super.message = 'La operación tardó demasiado']);
}

/// Excepción para errores de Firebase
class AppFirebaseException extends AppException {
  final String code;
  
  AppFirebaseException(this.code, [String? message]) 
      : super(message ?? 'Error de Firebase: $code');
}

/// Excepción para errores de caché
class CacheException extends AppException {
  CacheException([super.message = 'Error al acceder a datos en caché']);
}

/// Excepción para errores de servidor
class ServerException extends AppException {
  final int? statusCode;
  
  ServerException([this.statusCode, String? message]) 
      : super(message ?? 'Error del servidor${statusCode != null ? " (Código: $statusCode)" : ""}');
}

/// Excepción para operaciones no permitidas
class PermissionException extends AppException {
  PermissionException([super.message = 'No tienes permiso para realizar esta acción']);
}

/// Excepción para recursos no encontrados
class NotFoundException extends AppException {
  NotFoundException([super.message = 'El recurso solicitado no fue encontrado']);
}
