import 'package:gazobeton/core/client.dart';

class SaveRepository {
  final ApiClient client;

  SaveRepository({required this.client});

  Future<List<dynamic>> fetchSave({
    required String productId,
    required int quantity,
    required String state,
  }) async {
    final response = await client.fetchSave(
      productId: productId,
      quantity: quantity,
      state: state,
    );

    final responseData = response as Map<String, dynamic>;

    if (responseData['success'] == true) {
      return responseData['data'] as List<dynamic>;
    } else {
      throw Exception(responseData['message'] ?? 'Xatolik yuz berdi');
    }
  }

}
