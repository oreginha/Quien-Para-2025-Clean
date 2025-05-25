import 'package:equatable/equatable.dart';

/// Clase base para todos los fallos en la capa de dominio
/// 
/// En Clean Architecture, los Failures representan errores del dominio
/// que son independientes de la implementación y pueden ser manejados
/// por los casos de uso.
abstract class Failure extends Equatable {
  final String? message;
  
  const Failure([this.message]);
  
  @override
  List<Object?> get props => [message];
  
  @override
  String toString() => message ?? runtimeType.toString();
}

/// Fallo cuando hay problemas de red
class NetworkFailure extends Failure {
  const NetworkFailure([String super.message = 'Error de conexión a la red']);
}

/// Fallo cuando hay problemas de autenticación
class AuthFailure extends Failure {
  const AuthFailure([String super.message = 'Error de autenticación']);
}

/// Fallo cuando hay problemas de validación
class ValidationFailure extends Failure {
  const ValidationFailure([String super.message = 'Datos inválidos']);
}

/// Fallo cuando una operación tarda demasiado
class TimeoutFailure extends Failure {
  const TimeoutFailure([String super.message = 'La operación tardó demasiado']);
}

/// Fallo cuando hay problemas con el servidor
class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure([this.statusCode, String? message]) 
      : super(message ?? 'Error del servidor${statusCode != null ? " (Código: $statusCode)" : ""}');
  
  @override
  List<Object?> get props => [message, statusCode];
}

/// Fallo cuando hay problemas con el caché local
class CacheFailure extends Failure {
  const CacheFailure([String super.message = 'Error en el almacenamiento local']);
}

/// Fallo cuando se requieren permisos que no se tienen
class PermissionFailure extends Failure {
  const PermissionFailure([String super.message = 'No tienes permiso para realizar esta acción']);
}

/// Fallo cuando no se encuentra un recurso
class NotFoundFailure extends Failure {
  const NotFoundFailure([String super.message = 'El recurso solicitado no fue encontrado']);
}

/// Fallo general para errores inesperados
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String super.message = 'Ha ocurrido un error inesperado']);
}
