abstract class ProductEvent {}

class LoadProductsEvent extends ProductEvent {}

class LoadProductByIdEvent extends ProductEvent {
  final String productId;
  LoadProductByIdEvent(this.productId);
}

// YANGI: Kategoriya bo'yicha mahsulotlarni yuklash eventi
class LoadProductsByCategoryEvent extends ProductEvent {
  final String categoryId;
  LoadProductsByCategoryEvent(this.categoryId);
}