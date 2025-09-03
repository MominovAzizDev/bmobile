import 'package:dio/dio.dart';
import 'package:gazobeton/core/servises/interseptors.dart';
import 'package:gazobeton/data/models/auth_models/auth_model.dart';
import '../data/models/auth_models/home_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => "ApiException: $message (Status: $statusCode)";
}

class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException(this.message);

  @override
  String toString() => "UserNotFoundException: $message";
}

class ApiClient {
  final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: "https://api.bsgazobeton.uz/api",
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
          ),
        )
        ..interceptors.addAll([
          AuthInterceptor(),
          LogInterceptor(
            requestBody: true,
            responseBody: true,
            logPrint: (obj) => print(obj),
          ),
        ]);

  // ================= AUTH METHODS =================
  Future<String> signUp(AuthModel model) async {
    try {
      final response = await dio.post(
        "/identity/register",
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final success = data["success"] == true;
        final code = data["code"]?.toString() ?? "";
        final message = data["message"]?.toString() ?? "";

        if (success) {
          return "success";
        } else if (code.contains("allaqachon") || message.contains("allaqachon") || code.contains("Foydalanuvchi topilmadi")) {
          return "already_registered";
        } else {
          throw ApiException(
            message.isNotEmpty ? message : "Ro'yxatdan o'tishda xatolik",
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          "Ro'yxatdan o'tishda HTTP xatoligi",
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data != null && data is Map<String, dynamic>) {
        final code = data["code"]?.toString() ?? "";
        final message = data["message"]?.toString() ?? "";

        if (e.response?.statusCode == 409 || e.response?.statusCode == 400 || code.contains("allaqachon") || message.contains("allaqachon")) {
          return "already_registered";
        }
      }

      throw ApiException(
        e.response?.data?["message"] ?? e.message ?? "Tarmoq xatoligi",
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<String> login(String login, String password) async {
    try {
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
          final token = data["data"]["token"];
          if (token != null && token.toString().isNotEmpty) {
            return token.toString();
          }
        }

        final errorCode = data["code"]?.toString() ?? "";
        final errorMessage = data["message"]?.toString() ?? "";

        if (errorCode.contains("noto'g'ri") || errorCode.contains("Telefon raqami yoki parol noto'g'ri") || errorMessage.contains("noto'g'ri")) {
          throw UserNotFoundException("Login yoki parol noto'g'ri");
        } else if (errorCode.contains("tasdiqlanmagan") || errorCode.contains("Telefon raqami tasdiqlanmagan")) {
          throw ApiException("Telefon raqami tasdiqlanmagan", statusCode: 403);
        }

        throw ApiException("Login xatoligi: $errorCode", statusCode: response.statusCode);
      } else {
        throw ApiException("HTTP xatoligi", statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data != null && data is Map<String, dynamic>) {
        final code = data["code"]?.toString() ?? "";
        final message = data["message"]?.toString() ?? "";

        if (code.contains("noto'g'ri") || message.contains("noto'g'ri")) {
          throw UserNotFoundException("Login yoki parol noto'g'ri");
        } else if (code.contains("tasdiqlanmagan") || message.contains("tasdiqlanmagan")) {
          throw ApiException("Telefon raqami tasdiqlanmagan", statusCode: 403);
        }
      }

      throw ApiException(
        e.response?.data?["message"] ?? e.message ?? "Tarmoq xatoligi",
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<String?> verification(String phone, String code) async {
    try {
      final response = await dio.post(
        "/identity/verify-phone",
        data: {
          "phoneNumber": phone,
          "code": code,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data["success"] == true) {
          return "verified";
        } else {
          final errorCode = data["code"]?.toString() ?? "";
          if (errorCode.contains("allaqachon tasdiqlangan") || errorCode.contains("Telefon raqami allaqachon tasdiqlangan")) {
            return "already_verified";
          }
          return null;
        }
      }
      return null;
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?["message"] ?? e.message ?? "Tasdiqlash xatoligi",
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ================= HOME =================
  Future<HomeResponse> fetchHome() async {
    try {
      final response = await dio.get(
        '/products/categories/getall?take=10',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Accept-Language': 'uz_UZ',
          },
        ),
      );

      if (response.data != null && response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['success'] == true && responseData.containsKey('data')) {
          final data = responseData['data'] as Map<String, dynamic>;
          return HomeResponse.fromJson(data);
        } else {
          throw Exception('API dan xatolik: ${responseData['message'] ?? 'Noma\'lum xatolik'}');
        }
      }
      throw Exception('Noto\'g\'ri API response formati');
    } catch (e) {
      rethrow;
    }
  }

  // ================= ORDERS =================
  Future<List<Map<String, dynamic>>> fetchOrders({
    int? page,
    int? take,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (take != null) queryParams['take'] = take;

      final response = await dio.get(
        "/orders",
        queryParameters: queryParams,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Accept-Language': 'uz_UZ',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['success'] == true && responseData.containsKey('data')) {
          final data = responseData['data'];
          if (data is Map<String, dynamic> && data.containsKey('list')) {
            final list = data['list'] as List;
            return list.cast<Map<String, dynamic>>();
          } else if (data is List) {
            return data.cast<Map<String, dynamic>>();
          }
        }
        throw ApiException('Orders ma\'lumotlari noto\'g\'ri formatda', statusCode: response.statusCode);
      } else {
        throw ApiException("Orders olishda HTTP xatoligi", statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?["message"] ?? e.message ?? "Orderlarni olishda tarmoq xatoligi",
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> createOrder() async {
    try {
      final response = await dio.post(
        "/orders",
        options: Options(
          headers: {
            'accept': 'application/json',
            'Accept-Language': 'uz_UZ',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['success'] == true) {
          return responseData['data'] ?? {};
        } else {
          throw ApiException(responseData['message'] ?? 'Order yaratishda xatolik', statusCode: response.statusCode);
        }
      } else {
        throw ApiException("Order yaratishda HTTP xatoligi", statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?["message"] ?? e.message ?? "Order yaratishda tarmoq xatoligi",
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> updateOrder({
    required String orderId,
    String? status,
    String? address,
    bool? isDeliverable,
  }) async {
    try {
      final Map<String, dynamic> updateData = {};
      if (status != null) updateData['status'] = status;
      if (address != null) updateData['address'] = address;
      if (isDeliverable != null) updateData['isDeliverable'] = isDeliverable;

      final response = await dio.put(
        "/orders/$orderId",
        data: updateData,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Accept-Language': 'uz_UZ',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['success'] == true) {
          return responseData['data'] ?? {};
        } else {
          throw ApiException(responseData['message'] ?? 'Order yangilashda xatolik', statusCode: response.statusCode);
        }
      } else {
        throw ApiException("Order yangilashda HTTP xatoligi", statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?["message"] ?? e.message ?? "Order yangilashda tarmoq xatoligi",
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final response = await dio.get(
        "/products/getall?take=30",
        options: Options(
          headers: {
            'accept': 'application/json',
            'Accept-Language': 'uz_UZ',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['success'] == true && responseData.containsKey('data')) {
          final data = responseData['data'];
          if (data is List) {
            return data.cast<Map<String, dynamic>>();
          } else if (data is Map<String, dynamic> && data.containsKey('list')) {
            final list = data['list'] as List;
            return list.cast<Map<String, dynamic>>();
          }
        }
        throw Exception('API dan noto\'g\'ri format: ${responseData}');
      } else {
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Productlarni olib kelishda hatolik: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchProductsByCategory(String categoryId) async {
    try {
      final response = await dio.get(
        "/products/getall?categoryId=$categoryId&take=50",
        options: Options(
          headers: {
            'accept': 'application/json',
            'Accept-Language': 'uz_UZ',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['success'] == true && responseData.containsKey('data')) {
          final data = responseData['data'];
          if (data is List) {
            return data.cast<Map<String, dynamic>>();
          } else if (data is Map<String, dynamic> && data.containsKey('list')) {
            final list = data['list'] as List;
            return list.cast<Map<String, dynamic>>();
          }
        }
        throw Exception('API dan noto\'g\'ri format: ${responseData}');
      } else {
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Kategoriya mahsulotlarini olishda xatolik: $e");
    }
  }

  Future<Map<String, dynamic>> fetchSave({
    required String productId,
    required int quantity,
    required String state,
  }) async {
    try {
      final response = await dio.post(
        "/orders/save",
        data: {
          'productId': productId,
          'quantity': quantity,
          'state': state,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Accept-Language': 'uz_UZ',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['success'] == true) {
          return responseData['data'] ?? {};
        } else {
          throw ApiException(responseData['message'] ?? 'Cart yangilashda xatolik', statusCode: response.statusCode);
        }
      } else {
        throw ApiException('HTTP Error: ${response.statusCode}', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data as Map<String, dynamic>;
        throw ApiException(errorData['message'] ?? 'Server xatoligi', statusCode: e.response?.statusCode);
      }
      throw ApiException('Tarmoq xatoligi: ${e.message}', statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> fetchCart() async {
    try {
      final response = await dio.get(
        "/orders/cart",
        options: Options(
          headers: {
            'accept': 'application/json',
            'Accept-Language': 'uz_UZ',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['success'] == true) {
          return responseData['data'] ?? {};
        }
      }
      throw ApiException("Cart ma'lumotlarini olishda xatolik");
    } catch (e) {
      throw ApiException("Cart API xatoligi: $e");
    }
  }

  Future<Map<String, dynamic>> fetchCheckout({
    required String fullName,
    required String phoneNumber,
    required String address,
    required String email,
    required bool isDeliverable,
  }) async {
    try {
      final response = await dio.post(
        "/orders/checkout",
        data: {
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'address': address,
          'email': email,
          'isDeliverable': isDeliverable,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Accept-Language': 'uz_UZ',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['success'] == true) {
          return responseData['data'] ?? {};
        } else {
          throw ApiException(
            responseData['message'] ?? 'Checkout jarayonida xatolik',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          'Checkout HTTP xatoligi',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?["message"] ?? e.message ?? "Checkout tarmoq xatoligi",
        statusCode: e.response?.statusCode,
      );
    }
  }
}
