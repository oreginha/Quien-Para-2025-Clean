// lib/core/errors/error_handler.dart
// ignore_for_file: always_specify_types

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/logger/logger.dart';
import 'app_exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  static Failure handleError(final dynamic error) {
    logger.e('Error occurred:', error: error);

    if (error is AppException) {
      return _handleAppException(error);
    } else if (error is FirebaseAuthException) {
      return _handleFirebaseAuthError(error);
    } else if (error is DioException) {
      return _handleDioError(error);
    } else {
      return UnexpectedFailure(error.toString());
    }
  }

  static Failure _handleAppException(final AppException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(exception.message, code: exception.code);
    } else if (exception is AuthException) {
      return AuthFailure(exception.message, code: exception.code);
    } else if (exception is DataException) {
      return DataFailure(exception.message, code: exception.code);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message, code: exception.code);
    } else {
      return ServerFailure(
        exception.message,
        code: exception.code,
        originalError: exception,
      );
    }
  }

  static Failure _handleFirebaseAuthError(final FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-email':
        return AuthFailure(
          error.message ?? 'Authentication failed',
          code: error.code,
        );
      case 'user-disabled':
        return AuthFailure('This user has been disabled', code: error.code);
      case 'too-many-requests':
        return RateLimitFailure(
          'Too many unsuccessful login attempts',
          code: error.code,
        );
      case 'operation-not-allowed':
        return AuthFailure('Operation not allowed', code: error.code);
      case 'email-already-in-use':
        return AuthFailure('Email already in use', code: error.code);
      case 'weak-password':
        return ValidationFailure('The password is too weak', code: error.code);
      case 'requires-recent-login':
        return AuthFailure(
          'Please log in again before retrying this request',
          code: error.code,
        );
      default:
        return AuthFailure(
          error.message ?? 'Authentication error',
          code: error.code,
        );
    }
  }

  static Failure _handleDioError(final DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(
          'Connection timeout',
          code: error.type.toString(),
        );
      case DioExceptionType.badResponse:
        return _handleDioResponseError(error);
      case DioExceptionType.cancel:
        return RequestCancelledFailure('Request was cancelled');
      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return NetworkFailure(
            'No internet connection',
            code: 'SOCKET_EXCEPTION',
          );
        }
        return ServerFailure(
          'Unexpected error occurred',
          code: 'DIO_ERROR_OTHER',
          originalError: Exception,
        );
      default:
        return ServerFailure(
          'Server error',
          code: 'SERVER_ERROR',
          originalError: Exception,
        );
    }
  }

  static Failure _handleDioResponseError(final DioException error) {
    final int? statusCode = error.response?.statusCode;
    final data = error.response?.data;

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          'Bad request',
          code: 'BAD_REQUEST',
          data: data,
        );
      case 401:
        return AuthFailure('Unauthorized', code: 'UNAUTHORIZED', data: data);
      case 403:
        return AuthFailure('Forbidden', code: 'FORBIDDEN', data: data);
      case 404:
        return NotFoundFailure(
          'Resource not found',
          code: 'NOT_FOUND',
          data: data,
        );
      case 409:
        return ConflictFailure(
          'Conflict occurred',
          code: 'CONFLICT',
          data: data,
        );
      case 422:
        return ValidationFailure(
          'Validation failed',
          code: 'UNPROCESSABLE_ENTITY',
          data: data,
        );
      case 429:
        return RateLimitFailure(
          'Too many requests',
          code: 'TOO_MANY_REQUESTS',
          data: data,
        );
      case 500:
      case 501:
      case 503:
        return ServerFailure(
          'Server error',
          code: 'SERVER_ERROR_$statusCode',
          data: data,
          originalError: Exception,
        );
      default:
        return ServerFailure(
          'Server error with status: $statusCode',
          code: 'SERVER_ERROR',
          data: data,
          originalError: Exception,
        );
    }
  }
}
