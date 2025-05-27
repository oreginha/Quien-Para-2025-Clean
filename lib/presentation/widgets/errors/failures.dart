// lib/core/errors/failures.dart
abstract class Failure {
  final String message;
  final String? code;
  final dynamic data;

  Failure(this.message, {this.code, this.data});

  @override
  String toString() => 'Failure: $message (Code: $code)';
}

class ServerFailure extends Failure {
  ServerFailure(
    super.message, {
    final String? code,
    super.data,
    required Object originalError,
  }) : super(code: code ?? 'SERVER_FAILURE');
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message, {final String? code, super.data})
      : super(code: code ?? 'NETWORK_FAILURE');
}

class CacheFailure extends Failure {
  CacheFailure(super.message, {final String? code, super.data})
      : super(code: code ?? 'CACHE_FAILURE');
}

class ValidationFailure extends Failure {
  ValidationFailure(super.message, {final String? code, super.data})
      : super(code: code ?? 'VALIDATION_FAILURE');
}

class AuthFailure extends Failure {
  AuthFailure(super.message, {final String? code, super.data})
      : super(code: code ?? 'AUTH_FAILURE');
}

class NotFoundFailure extends Failure {
  NotFoundFailure(super.message, {final String? code, super.data})
      : super(code: code ?? 'NOT_FOUND_FAILURE');
}

class ConflictFailure extends Failure {
  ConflictFailure(super.message, {final String? code, super.data})
      : super(code: code ?? 'CONFLICT_FAILURE');
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure(super.message, {final String? code, super.data})
      : super(code: code ?? 'UNEXPECTED_FAILURE');
}

class RateLimitFailure extends Failure {
  RateLimitFailure(super.message, {final String? code, super.data})
      : super(code: code ?? 'RATE_LIMIT_FAILURE');
}

class RequestCancelledFailure extends Failure {
  RequestCancelledFailure(super.message, {final String? code, super.data})
      : super(code: code ?? 'REQUEST_CANCELLED');
}

class DataFailure extends Failure {
  DataFailure(super.message, {final String? code, super.data})
      : super(code: code ?? 'DATA_FAILURE');
}
