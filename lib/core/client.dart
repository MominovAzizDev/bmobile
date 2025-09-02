import 'package:dio/dio.dart';
import 'package:gazobeton/core/exports.dart';
import 'package:gazobeton/core/servises/interseptors.dart';
import 'package:gazobeton/data/models/auth_models/auth_model.dart';

import '../data/models/auth_models/home_model.dart';

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.bsgazobeton.uz/api",
      headers: {
        "Content-Type": "application/json-patch+json",
        "Accept": "application/json",
      },
    ),
  )..interceptors.add(AuthInterceptor());

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

        if (success) {
          return "success";
        } else if (code.contains("Foydalanuvchi topilmadi")) {
          return "already_registered";
        } else {
          return "error";
        }
      } else {
        return "error";
      }
    } on DioException catch (e) {
      final code = e.response?.data["code"]?.toString() ?? "";
      if (e.response?.statusCode == 409 || e.response?.statusCode == 400) {
        if (code.contains("Foydalanuvchi topilmadi")) {
          return "already_registered";
        }
      }
      return "error";
    }
  }

  Future<String> login(String login, String password) async {
    final response = await dio.post(
      "/identity/login",
      data: {
        "phoneNumber": login,
        "password": password,
      },
    );

    final data = response.data as Map<String, dynamic>;

    if (response.statusCode == 200) {
      if (data["success"] == true && data["data"] != null) {
        return data["data"]["token"];
      } else {
        final errorCode = data["code"];
        if (errorCode == "Telefon raqami yoki parol noto'g'ri" || errorCode == "Telefon raqami tasdiqlanmagan") {
          throw UserNotFoundException();
        }
        throw Exception("Login xatoligi: $errorCode");
      }
    } else {
      throw Exception("HTTP xatoligi: ${response.statusCode}");
    }
  }

  Future<String?> verification(String phone, String code) async {
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
      } else if (data["code"] == "Telefon raqami allaqachon tasdiqlangan") {
        return "already_verified";
      } else {
        return null;
      }
    }
    return null;
  }

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

      print('API Response: ${response.data}'); // Debug uchun

      // API response strukturasi: {"success": true, "data": {"list": [...], "pagination": {...}}}
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
      print('API Error: $e'); // Debug uchun
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final response = await dio.get("/orders");
    if (response.statusCode == 200) {
      final list = response.data['data']['list'] as List;
      return list.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Ordersni olib kelishda hatolik bor");
    }
  }

  // Barcha mahsulotlarni olish
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

  // YANGI: Kategoriya bo'yicha mahsulotlarni olish
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

      print('Category Products Response: ${response.data}'); // Debug uchun

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

  Future<void> fetchCheckout({
    required String fullName,
    required String phoneNumber,
    required String address,
    required String email,
    required bool isDeliverable,
  }) async {
    final response = await dio.post(
      '/orders',
      data: {
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'address': address,
        'email': email,
        'isDeliverable': isDeliverable,
      },
    );

    final responseData = response.data as Map<String, dynamic>;

    if (responseData['success'] == true) {
      return;
    } else {
      throw Exception(responseData['message'] ?? 'Xatolik yuz berdi');
    }
  }

  Future<dynamic> fetchSave({
    required String productId,
    required int quantity,
    required String state,
  }) async {
    final response = await dio.post("/orders/save", data: {'productId': productId, 'quantity': quantity, 'state': state});
    return response.data;
  }

  // Cart ma'lumotlarini olish
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
      throw Exception("Cart ma'lumotlarini olishda xatolik");
    } catch (e) {
      throw Exception("Cart API xatoligi: $e");
    }
  }
}
