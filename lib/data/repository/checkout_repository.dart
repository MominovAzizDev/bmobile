import 'package:gazobeton/core/client.dart';
import 'package:gazobeton/data/models/auth_models/checkout_model.dart';

class CheckoutRepository {
  final ApiClient client;
  CheckoutRepository({required this.client});

  Future<dynamic> fetchCheckout({
    required String fullName,
    required String phoneNumber,
    required String address,
    required String email,
    required bool isDeliverable,
  }) async {
    final response = await client.fetchCheckout(
      fullName: fullName,
      phoneNumber: phoneNumber,
      address: address,
      email: email,
      isDeliverable: isDeliverable,
    );

    final responseData = response as Map<String, dynamic>;

    if (responseData['success'] == true) {

      return;
    } else {
      throw Exception(responseData['message'] ?? 'Xatolik yuz berdi');
    }
  }
}
