// lib/core/errors/app_exceptions.dart
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic data;

  AppException(this.message, {this.code, this.data});

  @override
  String toString() => 'AppException: $message (Code: $code)';
}

// Errores de Network
class NetworkException extends AppException {
  NetworkException(super.message, {final String? code, super.data})
    : super(code: code ?? 'NETWORK_ERROR');
}

class ServerException extends NetworkException {
  ServerException(super.message, {final String? code, super.data})
    : super(code: code ?? 'SERVER_ERROR');
}

class ConnectionException extends NetworkException {
  ConnectionException(super.message, {final String? code, super.data})
    : super(code: code ?? 'CONNECTION_ERROR');
}

// Errores de Auth
class AuthException extends AppException {
  AuthException(super.message, {final String? code, super.data})
    : super(code: code ?? 'AUTH_ERROR');
}

class UnauthorizedException extends AuthException {
  UnauthorizedException(super.message, {final String? code, super.data})
    : super(code: code ?? 'UNAUTHORIZED');
}

class TokenExpiredException extends AuthException {
  TokenExpiredException(super.message, {final String? code, super.data})
    : super(code: code ?? 'TOKEN_EXPIRED');
}

// Errores de Data
class DataException extends AppException {
  DataException(super.message, {final String? code, super.data})
    : super(code: code ?? 'DATA_ERROR');
}

class ValidationException extends DataException {
  ValidationException(super.message, {final String? code, super.data})
    : super(code: code ?? 'VALIDATION_ERROR');
}

class NotFoundException extends DataException {
  NotFoundException(super.message, {final String? code, super.data})
    : super(code: code ?? 'NOT_FOUND');
}

// Errores de Cache
class CacheException extends AppException {
  CacheException(super.message, {final String? code, super.data})
    : super(code: code ?? 'CACHE_ERROR');
}
