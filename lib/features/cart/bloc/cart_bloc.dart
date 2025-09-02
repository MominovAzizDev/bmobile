import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gazobeton/data/models/cart_item.dart';
import 'package:gazobeton/data/repository/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repo;

  CartBloc({required CartRepository repo}) : _repo = repo, super(CartState.initial()) {
    on<CartLoaded>(_onCartLoaded);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartItemQuantityUpdated>(_onCartItemQuantityUpdated);
  }

  Future<void> _onCartLoaded(CartLoaded event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final cartData = await _repo.getCart();

      // API response ni to'g'ri parse qiling
      final items = <CartItem>[];
      if (cartData.containsKey('items') && cartData['items'] is List) {
        final itemsList = cartData['items'] as List;
        items.addAll(itemsList.map((item) => CartItem.fromJson(item)).toList());
      }

      final totalPrice = items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

      emit(
        state.copyWith(
          status: CartStatus.success,
          items: items,
          totalPrice: totalPrice,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCartItemAdded(CartItemAdded event, Emitter<CartState> emit) async {
    try {
      await _repo.saveToCart(
        productId: event.productId,
        quantity: event.quantity,
        state: 'add',
      );
      add(CartLoaded()); // Cartni qayta yuklash
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCartItemRemoved(CartItemRemoved event, Emitter<CartState> emit) async {
    try {
      await _repo.saveToCart(
        productId: event.productId,
        quantity: 0,
        state: 'remove',
      );
      add(CartLoaded());
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCartItemQuantityUpdated(CartItemQuantityUpdated event, Emitter<CartState> emit) async {
    try {
      await _repo.saveToCart(
        productId: event.productId,
        quantity: event.quantity,
        state: 'update',
      );
      add(CartLoaded());
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
