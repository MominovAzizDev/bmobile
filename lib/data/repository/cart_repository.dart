import 'package:gazobeton/core/client.dart';

class CartRepository {
  final ApiClient _client;
  
  CartRepository({required ApiClient client}) : _client = client;
  
  Future<Map<String, dynamic>> getCart() async {
    return await _client.fetchCart();
  }
  
  Future<void> saveToCart({
    required String productId,
    required int quantity,
    required String state,
  }) async {
    return await _client.fetchSave(
      productId: productId,
      quantity: quantity,
      state: state,
    );
  }
}