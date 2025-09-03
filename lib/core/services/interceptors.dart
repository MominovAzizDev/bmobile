import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../../data/repository/auth_repository.dart';
import '../exports.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio = Dio();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final jwt = await SecureStorage.getToken();
    if (jwt != null) {
      options.headers['Authorization'] = "Bearer $jwt";
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final result = await navigatorKey.currentContext!.read<AuthRepository>().refreshToken();

      return result.fold(
        (error) async {
          await navigatorKey.currentContext!.read<AuthRepository>();
          navigatorKey.currentContext!.go(Routes.login);
          return handler.reject(err);
        },
        (newToken) async {
          err.requestOptions.headers['Authorization'] = "Bearer $newToken";
          return handler.resolve(
            await _dio.request(
              err.requestOptions.baseUrl + err.requestOptions.path,
              options: Options(
                method: err.requestOptions.method,
                headers: err.requestOptions.headers,
              ),
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
            ),
          );
        },
      );
    }

    return handler.next(err);
  }
}
