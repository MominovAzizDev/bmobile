import 'package:dio/dio.dart';
import '../exports.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        // Get credentials from secure storage
        final credentials = await SecureStorage.getCredentials();
        final login = credentials['login'];
        final password = credentials['password'];

        if (login != null && password != null) {
          // Create new Dio instance WITHOUT interceptors to avoid circular loop
          final dio = Dio(BaseOptions(
            baseUrl: "https://api.bsgazobeton.uz/api",
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
          ));

          // Try to refresh token by re-login
          final response = await dio.post(
            "/identity/login",
            data: {
              "phoneNumber": login,
              "password": password,
            },
          );

          if (response.statusCode == 200) {
            final data = response.data as Map<String, dynamic>;
            if (data["success"] == true && data["data"] != null) {
              final newToken = data["data"]["token"];
              if (newToken != null && newToken.toString().isNotEmpty) {
                // Save new token
                await SecureStorage.saveToken(newToken.toString());
                
                // Retry original request with new token
                err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                
                final cloneReq = await dio.request(
                  err.requestOptions.path,
                  options: Options(
                    method: err.requestOptions.method,
                    headers: err.requestOptions.headers,
                  ),
                  data: err.requestOptions.data,
                  queryParameters: err.requestOptions.queryParameters,
                );

                return handler.resolve(cloneReq);
              }
            }
          }
        }

        // If refresh fails, clear tokens and redirect to login
        await SecureStorage.deleteToken();
        await SecureStorage.deleteCredentials();
        
        // Navigate to login if possible
        if (navigatorKey.currentContext != null) {
          navigatorKey.currentContext!.go(Routes.login);
        }
        
        return handler.next(err);
      } catch (e) {
        // If any error occurs during refresh, clear tokens
        await SecureStorage.deleteToken();
        await SecureStorage.deleteCredentials();
        return handler.next(err);
      }
    } else {
      return handler.next(err);
    }
  }
}