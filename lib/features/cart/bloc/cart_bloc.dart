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
      final items = <CartItem>[];
      
      // API response ni to'g'ri parse qilish
      if (cartData.containsKey('items') && cartData['items'] is List) {
        final itemsList = cartData['items'] as List;
        for (final item in itemsList) {
          if (item is Map<String, dynamic>) {
            try {
              items.add(CartItem.fromJson(item));
            } catch (e) {
              print('CartItem parse xatoligi: $e, item: $item');
            }
          }
        }
      }

      final totalPrice = items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

      emit(
        state.copyWith(
          status: CartStatus.success,
          items: items,
          totalPrice: totalPrice,
          errorMessage: null,
        ),
      );
    } catch (e) {
      print('Cart yuklashda xatolik: $e');
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Cart ma\'lumotlarini yuklashda xatolik: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCartItemAdded(CartItemAdded event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      
      await _repo.saveToCart(
        productId: event.productId,
        quantity: event.quantity,
        state: 'add',
      );
      
      // Cartni qayta yuklash
      add(CartLoaded());
    } catch (e) {
      print('Cart ga qo\'shishda xatolik: $e');
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Mahsulotni qo\'shishda xatolik: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCartItemRemoved(CartItemRemoved event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      
      await _repo.saveToCart(
        productId: event.productId,
        quantity: 0,
        state: 'remove',
      );
      
      // Cartni qayta yuklash
      add(CartLoaded());
    } catch (e) {
      print('Cart dan o\'chirishda xatolik: $e');
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Mahsulotni o\'chirishda xatolik: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCartItemQuantityUpdated(CartItemQuantityUpdated event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      
      await _repo.saveToCart(
        productId: event.productId,
        quantity: event.quantity,
        state: 'update',
      );
      
      // Cartni qayta yuklash
      add(CartLoaded());
    } catch (e) {
      print('Cart miqdorini yangilashda xatolik: $e');
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Miqdorni yangilashda xatolik: ${e.toString()}',
        ),
      );
    }
  }
}