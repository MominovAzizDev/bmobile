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
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(AuthInterceptor());

  // Auth metodlari - oldingi kabi qoladi
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
    try {
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
    } on DioException catch (e) {
      throw Exception("Login API xatoligi: ${e.message}");
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
        } else if (data["code"] == "Telefon raqami allaqachon tasdiqlangan") {
          return "already_verified";
        } else {
          return null;
        }
      }
      return null;
    } on DioException catch (e) {
      print('Verification error: $e');
      return null;
    }
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
    } on DioException catch (e) {
      throw Exception('Home API xatoligi: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    try {
      final response = await dio.get("/orders");
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['success'] == true && responseData.containsKey('data')) {
          final data = responseData['data'];
          if (data is Map<String, dynamic> && data.containsKey('list')) {
            final list = data['list'] as List;
            return list.cast<Map<String, dynamic>>();
          }
        }
      }
      throw Exception("Orders API format xatoligi");
    } on DioException catch (e) {
      throw Exception("Orders API xatoligi: ${e.message}");
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
    } on DioException catch (e) {
      throw Exception("Products API xatoligi: ${e.message}");
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
    } on DioException catch (e) {
      throw Exception("Category products API xatoligi: ${e.message}");
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
          // API response formatini tekshirish
          final data = responseData['data'];

          if (data == null) {
            return {'items': [], 'totalPrice': 0.0};
          }

          if (data is Map<String, dynamic>) {
            return {
              'items': data['items'] ?? [],
              'totalPrice': (data['totalPrice'] ?? 0).toDouble(),
            };
          } else if (data is List) {
            // Agar data to'g'ridan-to'g'ri list bo'lsa
            return {
              'items': data,
              'totalPrice': 0.0, // Har bir itemdan hisoblanadi
            };
          }
        }

        throw Exception("Cart API: ${responseData['message'] ?? 'Noto\'g\'ri format'}");
      }

      throw Exception("Cart API HTTP xatoligi: ${response.statusCode}");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Avtorizatsiya kerak");
      }
      throw Exception("Cart API xatoligi: ${e.message}");
    }
  }

  // TUZATILGAN: Cart ga saqlash
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
          return responseData;
        } else {
          throw Exception("Save API: ${responseData['message'] ?? 'Saqlashda xatolik'}");
        }
      }

      throw Exception("Save API HTTP xatoligi: ${response.statusCode}");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Avtorizatsiya kerak");
      }
      throw Exception("Save API xatoligi: ${e.message}");
    }
  }

  // TUZATILGAN: Checkout
  Future<Map<String, dynamic>> fetchCheckout({
    required String fullName,
    required String phoneNumber,
    required String address,
    required String email,
    required bool isDeliverable,
  }) async {
    try {
      final response = await dio.post(
        '/orders',
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
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Checkout da xatolik');
        }
      }

      throw Exception('Checkout HTTP xatoligi: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Checkout API xatoligi: ${e.message}');
    }
  }
}
