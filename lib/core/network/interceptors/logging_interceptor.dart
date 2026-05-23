import 'package:dio/dio.dart';
import '../../utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Don't log 400 errors
    if (!options.path.contains('dashboard-stats') &&
        !options.path.contains('latest-interests')) {
      AppLogger.debug('REQUEST[${options.method}] => PATH: ${options.path}');
      AppLogger.debug('Headers: ${options.headers}');
      if (options.data != null) {
        AppLogger.debug('Body: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Only log successful non-400 responses
    if (response.statusCode != 400) {
      AppLogger.debug(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
      if (response.data != null) {
        AppLogger.debug('Response Data: ${response.data}');
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Don't log 400 errors
    if (err.response?.statusCode != 400) {
      AppLogger.error(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
        err.message,
      );
      if (err.response?.data != null) {
        AppLogger.error('Error Data: ${err.response?.data}');
      }
    }
    super.onError(err, handler);
  }
}
