import 'package:gazobeton/core/client.dart';

class CartRepository {
  final ApiClient _client;
  
  CartRepository({required ApiClient client}) : _client = client;
  
  Future<Map<String, dynamic>> getCart() async {
    try {
      return await _client.fetchCart();
    } catch (e) {
      throw Exception('CartRepository getCart xatoligi: $e');
    }
  }
  
  Future<Map<String, dynamic>> saveToCart({
    required String productId,
    required int quantity,
    required String state,
  }) async {
    try {
      return await _client.fetchSave(
        productId: productId,
        quantity: quantity,
        state: state,
      );
    } catch (e) {
      throw Exception('CartRepository saveToCart xatoligi: $e');
    }
  }
}
