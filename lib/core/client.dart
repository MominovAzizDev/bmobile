import 'package:dio/dio.dart';
import 'package:gazobeton/core/exports.dart';
import 'package:gazobeton/core/servises/interseptors.dart';
import 'package:gazobeton/data/models/auth_models/auth_model.dart';

import '../data/models/auth_models/home_model.dart';
import '../data/models/auth_models/product_model.dart';

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://api.1000kitob.uz/api",
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
    final response = await dio.get(
      '/products/categories/getall?take=10',
      options: Options(
        headers: {
          'accept': 'text/plain',
          'Accept-Language': 'ru_RU',
          // tokenni avtomatik qo‘shsa ham bo‘ladi
        },
      ),
    );

    final data = response.data['data'];
    return HomeResponse.fromJson(data);
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



  Future<List<dynamic>> fetchProducts() async {
    final response = await dio.get("/products");
    if (response.statusCode == 200) {
      final data = response.data;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("Productlarni olib kelishda hatolik bor");
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
  Future<dynamic>fetchSave({required String productId, required int quantity, required String state,})async{
    final response = await dio.post("/orders/save",data: {
      'productId': productId,
      'quantity': quantity,
      'state':state
    });
    return response.data;
  }
}
