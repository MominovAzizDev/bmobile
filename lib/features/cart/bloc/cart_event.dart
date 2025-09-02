sealed class CartEvent {}

class CartLoaded extends CartEvent {}

class CartItemAdded extends CartEvent {
  final String productId;
  final int quantity;
  
  CartItemAdded({required this.productId, required this.quantity});
}

class CartItemRemoved extends CartEvent {
  final String productId;
  
  CartItemRemoved({required this.productId});
}

class CartItemQuantityUpdated extends CartEvent {
  final String productId;
  final int quantity;
  
  CartItemQuantityUpdated({required this.productId, required this.quantity});
}