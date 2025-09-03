import 'package:gazobeton/core/client.dart';

class CheckoutRepository {
  final ApiClient client;
  
  CheckoutRepository({required this.client});

  Future<Map<String, dynamic>> fetchCheckout({
    required String fullName,
    required String phoneNumber,
    required String address,
    required String email,
    required bool isDeliverable,
  }) async {
    try {
      final response = await client.fetchCheckout(
        fullName: fullName,
        phoneNumber: phoneNumber,
        address: address,
        email: email,
        isDeliverable: isDeliverable,
      );

       return response;
    } catch (e) {
      rethrow;
    }
  }
}