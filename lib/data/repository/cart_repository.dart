import 'package:gazobeton/core/client.dart';

class CartRepository {
  final ApiClient _client;

  CartRepository({required ApiClient client}) : _client = client;

  Future<Map<String, dynamic>> getCart() async {
    try {
      return await _client.fetchCart();
    } catch (e) {
      throw Exception('Cart ma\'lumotlarini olishda xatolik: $e');
    }
  }

  Future<Map<String, dynamic>> saveToCart({
    required String productId,
    required int quantity,
    required String state,
  }) async {
    try {
      // Validation
      if (productId.trim().isEmpty) {
        throw Exception('Product ID bo\'sh bo\'lishi mumkin emas');
      }
      if (quantity < 0) {
        throw Exception('Miqdor manfiy bo\'lishi mumkin emas');
      }
      if (!['add', 'update', 'remove'].contains(state)) {
        throw Exception('Noto\'g\'ri state qiymati: $state');
      }

      final result = await _client.fetchSave(
        productId: productId,
        quantity: quantity,
        state: state,
      );
      
      return result is Map<String, dynamic> ? result : {};
    } catch (e) {
      throw Exception('Cart yangilashda xatolik: $e');
    }
  }
}