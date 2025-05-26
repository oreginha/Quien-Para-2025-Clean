// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import '../logger/logger.dart';
import '../storage/storage_helper.dart';
import 'api_interceptors.dart';

class ApiClient {
  late final Dio dio; // Proporcionar acceso público a dio
  final String baseUrl;

  ApiClient({
    required this.baseUrl,
    required final StorageHelper storageHelper,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );

    // Añadir interceptores
    dio.interceptors.add(ApiInterceptors(storageHelper));

    // Logging en modo debug
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (final Object obj) => logger.d(obj.toString()),
      ),
    );
  }

  // Método GET
  Future<Response<dynamic>> get(
    final String path, {
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
  }) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      logger.e('GET request error: $path', error: e);
      rethrow;
    }
  }

  // Método POST
  Future<Response<dynamic>> post(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
  }) async {
    try {
      return await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      logger.e('POST request error: $path', error: e);
      rethrow;
    }
  }

  // Método DELETE
  Future<Response<dynamic>> delete(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
  }) async {
    try {
      return await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      logger.e('DELETE request error: $path', error: e);
      rethrow;
    }
  }
}
