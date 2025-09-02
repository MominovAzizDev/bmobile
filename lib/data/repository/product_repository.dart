import 'package:gazobeton/core/client.dart';
import 'package:gazobeton/data/models/auth_models/product_model.dart';

class ProductRepository {
  final ApiClient client;
  ProductRepository({required this.client});

  // Barcha mahsulotlarni olish
  Future<List<ProductModel>> fetchProduct() async {
    final rawProduct = await client.fetchProducts();
    return rawProduct.map((e) => ProductModel.fromJson(e)).toList();
  }

  // YANGI: Kategoriya bo'yicha mahsulotlarni olish
  Future<List<ProductModel>> fetchProductsByCategory(String categoryId) async {
    final rawProducts = await client.fetchProductsByCategory(categoryId);
    return rawProducts.map((e) => ProductModel.fromJson(e)).toList();
  }
}