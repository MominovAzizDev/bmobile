import 'package:gazobeton/data/models/auth_models/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  ProductLoaded(this.products);
}

class ProductDetailLoaded extends ProductState {
  final ProductModel product;
  ProductDetailLoaded(this.product);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}