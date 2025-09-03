import 'package:dio/dio.dart';
import 'package:gazobeton/core/services/secure_storage.dart';

/// Interceptor to handle authentication and token refreshing.
class AuthInterceptor extends Interceptor {
  final Dio _dio;

  AuthInterceptor(this._dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Get the token from secure storage
    final token = await SecureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        // Lock the dio instance to prevent other requests from failing
        // while we are refreshing the token.
        _dio.interceptors.requestLock.lock();
        _dio.interceptors.responseLock.lock();
        _dio.interceptors.errorLock.lock();

        // Get the stored credentials
        final credentials = await SecureStorage.getCredentials();
        final login = credentials['login'];
        final password = credentials['password'];

        if (login == null || password == null) {
          // If no credentials, we can't refresh. Logout.
          await SecureStorage.deleteAll();
          throw DioException(
            requestOptions: err.requestOptions,
            error: 'Authentication error: No credentials to refresh token.',
          );
        }

        // SECURITY WARNING: This is not a true "refresh token" flow.
        // It re-uses the user's login and password to get a new token.
        // A proper OAuth2 implementation with a dedicated refresh token is
        // highly recommended for better security.
        final refreshTokenDio = Dio(); // Use a new Dio instance for the refresh
        final response = await refreshTokenDio.post(
          '${_dio.options.baseUrl}/identity/login',
          data: {'phoneNumber': login, 'password': password},
        );

        if (response.statusCode == 200 && response.data['success'] == true) {
          final newToken = response.data['data']['token'] as String;
          await SecureStorage.saveToken(newToken);

          // Update the failed request's header with the new token
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

          // Unlock and retry the original request
          _dio.interceptors.requestLock.unlock();
          _dio.interceptors.responseLock.unlock();
          _dio.interceptors.errorLock.unlock();

          // Retry the request with the new token
          final retriedResponse = await _dio.fetch(err.requestOptions);
          return handler.resolve(retriedResponse);
        } else {
          // If refresh fails, logout the user and reject the error
          await SecureStorage.deleteAll();
          throw DioException(
            requestOptions: err.requestOptions,
            error: 'Failed to refresh token. Logging out.',
          );
        }
      } catch (e) {
        // Ensure we logout on any error during refresh
        await SecureStorage.deleteAll();
        _dio.interceptors.requestLock.unlock();
        _dio.interceptors.responseLock.unlock();
        _dio.interceptors.errorLock.unlock();
        return handler.reject(DioException(
          requestOptions: err.requestOptions,
          error: 'An unexpected error occurred during token refresh: $e',
        ));
      }
    }

    return handler.next(err);
  }
}
