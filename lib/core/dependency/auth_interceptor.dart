import 'package:dio/dio.dart';
import '../exports.dart';

class AuthInterceptor extends Interceptor {
  static bool _isRefreshing = false;
  static List<({RequestOptions options, ErrorInterceptorHandler handler})> _pendingRequests = [];

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await SecureStorage.getToken();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } catch (e) {
      handler.reject(DioException(
        requestOptions: options,
        error: 'Token olishda xatolik: $e',
      ));
    }
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _handleTokenRefresh(err, handler);
    } else {
      handler.next(err);
    }
  }

  Future<void> _handleTokenRefresh(DioException err, ErrorInterceptorHandler handler) async {
    // Agar allaqachon refresh bo'layotgan bo'lsa, kutish ro'yxatiga qo'shamiz
    if (_isRefreshing) {
      _pendingRequests.add((options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;

    try {
      final credentials = await SecureStorage.getCredentials();
      final login = credentials['login'];
      final password = credentials['password'];

      if (login == null || password == null) {
        await _clearTokensAndRedirect();
        handler.next(err);
        return;
      }

      // Yangi token olish
      final newToken = await _refreshToken(login, password);
      
      if (newToken != null) {
        // Original request ni retry qilish
        final response = await _retryRequest(err.requestOptions, newToken);
        handler.resolve(response);

        // Kutayotgan requestlarni ham qayta ishlash
        await _processPendingRequests(newToken);
      } else {
        await _clearTokensAndRedirect();
        handler.next(err);
        _rejectPendingRequests(err);
      }
    } catch (e) {
      await _clearTokensAndRedirect();
      handler.next(err);
      _rejectPendingRequests(err);
    } finally {
      _isRefreshing = false;
      _pendingRequests.clear();
    }
  }

  Future<String?> _refreshToken(String login, String password) async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: "https://api.bsgazobeton.uz/api",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ));

      final response = await dio.post(
        "/identity/login",
        data: {
          "phoneNumber": login,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        if (data?["success"] == true && data?["data"] != null) {
          final newToken = data!["data"]["token"];
          if (newToken != null && newToken.toString().isNotEmpty) {
            await SecureStorage.saveToken(newToken.toString());
            return newToken.toString();
          }
        }
      }
    } catch (e) {
      print('Token yangilashda xatolik: $e');
    }
    return null;
  }

  Future<Response> _retryRequest(RequestOptions options, String token) async {
    final dio = Dio(BaseOptions(
      baseUrl: "https://api.bsgazobeton.uz/api",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    // Yangi token bilan header yangilash
    final headers = Map<String, dynamic>.from(options.headers);
    headers['Authorization'] = 'Bearer $token';

    return await dio.request(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: headers,
        contentType: options.contentType,
        responseType: options.responseType,
      ),
    );
  }

  Future<void> _processPendingRequests(String newToken) async {
    for (final pending in _pendingRequests) {
      try {
        final response = await _retryRequest(pending.options, newToken);
        pending.handler.resolve(response);
      } catch (e) {
        pending.handler.next(DioException(
          requestOptions: pending.options,
          error: e,
        ));
      }
    }
  }

  void _rejectPendingRequests(DioException originalError) {
    for (final pending in _pendingRequests) {
      pending.handler.next(DioException(
        requestOptions: pending.options,
        error: 'Token yangilanmadi',
      ));
    }
  }

  Future<void> _clearTokensAndRedirect() async {
    await SecureStorage.deleteToken();
    await SecureStorage.deleteCredentials();
    
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.go(Routes.login);
    }
  }
}