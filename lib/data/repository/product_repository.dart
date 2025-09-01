import 'package:gazobeton/core/client.dart';
import 'package:gazobeton/data/models/auth_models/product_model.dart';

class ProductRepository{
  final ApiClient client;
  ProductRepository({required this.client});

  Future<List<ProductModel>>fetchProduct()async{
    final rawProduct = await client.fetchProducts();
    return rawProduct.map((e)=> ProductModel.fromJson(e)).toList();
  }
}