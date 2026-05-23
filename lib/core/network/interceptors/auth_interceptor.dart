import 'package:dio/dio.dart';
import '../../utils/secure_storage.dart';
import '../../utils/logger.dart';
import '../../constants/api_constants.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Try to get token from secure storage
    String? token = await SecureStorage.getMainToken();

    // If no main token, try role-specific tokens based on endpoint
    if (token == null) {
      if (options.path.contains('/startups') ||
          options.path.contains('/intros/startup')) {
        token = await SecureStorage.getStartupToken();
      } else if (options.path.contains('/investor/')) {
        token = await SecureStorage.getInvestorToken();
      }
    }

    if (token != null) {
      options.headers[ApiConstants.authorization] =
          '${ApiConstants.bearer} $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      AppLogger.warning('Unauthorized request - token may be expired');
      // Token expired - should trigger logout
    }
    super.onError(err, handler);
  }
}
