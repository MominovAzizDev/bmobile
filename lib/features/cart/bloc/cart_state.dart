// lib/features/cart/bloc/cart_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gazobeton/data/models/cart_item.dart';

part 'cart_state.freezed.dart';

enum CartStatus { idle, loading, success, error }

@freezed
abstract class CartState with _$CartState {
  const factory CartState({
    @Default(CartStatus.idle) CartStatus status,
    @Default(const <CartItem>[]) List<CartItem> items, // <- const qo'shildi
    @Default(0.0) double totalPrice,
    String? errorMessage,
  }) = _CartState;

  factory CartState.initial() => const CartState();
}
