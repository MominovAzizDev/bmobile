import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gazobeton/data/models/cart_item.dart';

enum CartStatus { idle, loading, success, error }

@freezed
class CartState with _$CartState {
  const factory CartState({
    @Default(CartStatus.idle) CartStatus status,
    @Default([]) List<CartItem> items,
    @Default(0.0) double totalPrice,
    String? errorMessage,
  }) = _CartState;

  factory CartState.initial() {
    return const CartState();
  }
}