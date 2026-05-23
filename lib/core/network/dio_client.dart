import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import '../utils/logger.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        ApiConstants.contentType: ApiConstants.applicationJson,
      },
      // Custom validateStatus to NOT throw on 400
      validateStatus: (status) {
        // Don't throw for 400 - treat as success (silent failure)
        // Throw for all other error status codes (500, 401, 403, etc.)
        return status != null && (status < 400 || status == 400);
      },
    ));

    // Add interceptors
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(LoggingInterceptor());

    return dio;
  }

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await instance.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      // Only log non-400 errors
      if (e.response?.statusCode != 400) {
        AppLogger.error('GET request failed: $path', e);
      }
      rethrow;
    }
  }

  static Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await instance.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      // Only log non-400 errors
      if (e.response?.statusCode != 400) {
        AppLogger.error('POST request failed: $path', e);
      }
      rethrow;
    }
  }

  static Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await instance.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      // Only log non-400 errors
      if (e.response?.statusCode != 400) {
        AppLogger.error('PUT request failed: $path', e);
      }
      rethrow;
    }
  }

  static Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await instance.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      // Only log non-400 errors
      if (e.response?.statusCode != 400) {
        AppLogger.error('PATCH request failed: $path', e);
      }
      rethrow;
    }
  }

  static Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await instance.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      // Only log non-400 errors
      if (e.response?.statusCode != 400) {
        AppLogger.error('DELETE request failed: $path', e);
      }
      rethrow;
    }
  }
}
