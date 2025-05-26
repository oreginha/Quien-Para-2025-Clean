// lib/core/network/api_interceptors.dart
// ignore_for_file: always_specify_types

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quien_para/presentation/widgets/errors/app_exceptions.dart';
import '../logger/logger.dart';
import '../storage/storage_helper.dart';

class ApiInterceptors extends Interceptor {
  final StorageHelper _storageHelper;
  final Map<String, RateLimitTracker> _rateLimitTrackers =
      <String, RateLimitTracker>{};

  ApiInterceptors(this._storageHelper);

  @override
  void onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    // Verificar rate limiting
    final String endpointKey = '${options.method}:${options.path}';
    final RateLimitTracker tracker = _getOrCreateTracker(endpointKey);

    if (!tracker.canMakeRequest()) {
      logger.w('Rate limit exceeded for $endpointKey');
      return handler.reject(
        DioException(
          requestOptions: options,
          error: RateLimitException(
            'Too many requests. Please try again later.',
          ),
        ),
      );
    }

    tracker.trackRequest();

    // Añadir token de autenticación si existe
    final String? token = await _storageHelper.getAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Añadir información adicional
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    if (kDebugMode) {
      logger.d(
        'API Request: ${options.method} ${options.uri}\n'
        'Headers: ${options.headers}\n'
        'Data: ${options.data}',
      );
    }

    return handler.next(options);
  }

  @override
  void onResponse(
    final Response<dynamic> response,
    final ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      logger.d(
        'API Response: ${response.statusCode} ${response.requestOptions.uri}\n'
        'Data: ${response.data}',
      );
    }

    return handler.next(response);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    logger.e(
      'API Error: ${err.response?.statusCode} ${err.requestOptions.uri}\n'
      'Message: ${err.message}\n'
      'Data: ${err.response?.data}',
    );

    // Transformar errores de Dio a nuestras excepciones personalizadas
    final AppException error = _handleDioError(err);

    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: error,
        response: err.response,
        type: err.type,
      ),
    );
  }

  AppException _handleDioError(final DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ConnectionException('Connection timeout occurred');

      case DioExceptionType.connectionError:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return RequestCancelledException('Request was cancelled');

      case DioExceptionType.unknown:
        if (error.error is RateLimitException) {
          return error.error as RateLimitException;
        }

        if (error.error.toString().contains('SocketException')) {
          return NetworkException('No internet connection');
        }

        return ServerException('Unexpected error occurred');

      default:
        return ServerException('Server error');
    }
  }

  AppException _handleResponseError(final DioException error) {
    final int? statusCode = error.response?.statusCode;
    final data = error.response?.data;

    switch (statusCode) {
      case 400:
        return ValidationException('Bad request', data: data);
      case 401:
        return UnauthorizedException('Unauthorized', data: data);
      case 403:
        return UnauthorizedException('Forbidden', data: data);
      case 404:
        return NotFoundException('Resource not found', data: data);
      case 409:
        return ConflictException('Conflict occurred', data: data);
      case 422:
        return ValidationException('Validation failed', data: data);
      case 429:
        return RateLimitException('Too many requests', data: data);
      case 500:
      case 501:
      case 503:
        return ServerException('Server error', data: data);
      default:
        return ServerException(
          'Server error with status: $statusCode',
          data: data,
        );
    }
  }

  RateLimitTracker _getOrCreateTracker(final String key) {
    if (!_rateLimitTrackers.containsKey(key)) {
      _rateLimitTrackers[key] = RateLimitTracker();
    }
    return _rateLimitTrackers[key]!;
  }
}

class RateLimitTracker {
  final int _maxRequests = 30; // Máximo número de solicitudes
  final Duration _timeWindow = const Duration(minutes: 1); // Ventana de tiempo
  final List<DateTime> _requestTimestamps = <DateTime>[];

  bool canMakeRequest() {
    _cleanOldRequests();
    return _requestTimestamps.length < _maxRequests;
  }

  void trackRequest() {
    _requestTimestamps.add(DateTime.now());
  }

  void _cleanOldRequests() {
    final DateTime now = DateTime.now();
    _requestTimestamps.removeWhere(
      (final DateTime timestamp) => now.difference(timestamp) > _timeWindow,
    );
  }
}

class RequestCancelledException extends NetworkException {
  RequestCancelledException(super.message, {final String? code, super.data})
    : super(code: code ?? 'REQUEST_CANCELLED');
}

class RateLimitException extends NetworkException {
  RateLimitException(super.message, {final String? code, super.data})
    : super(code: code ?? 'RATE_LIMIT_EXCEEDED');
}

class ConflictException extends DataException {
  ConflictException(super.message, {final String? code, super.data})
    : super(code: code ?? 'CONFLICT');
}
