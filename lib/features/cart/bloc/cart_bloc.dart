import 'package:gazobeton/core/exports.dart';
import 'package:gazobeton/data/models/cart_item.dart';
import 'package:gazobeton/data/repository/cart_repository.dart';
import 'package:gazobeton/features/cart/bloc/cart_event.dart';
import 'package:gazobeton/features/cart/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repo;

  CartBloc({required CartRepository repo}) : _repo = repo, super(const CartState()) {
    on<CartLoaded>(_onCartLoaded);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartItemQuantityUpdated>(_onCartItemQuantityUpdated);
  }

  Future<void> _fetchAndEmitCart(Emitter<CartState> emit) async {
    try {
      final cartData = await _repo.getCart();
      final items = <CartItem>[];

      if (cartData is Map) {
        List? itemsList;

        // Turli formatlarni tekshirish
        if (cartData['items'] is List) {
          itemsList = cartData['items'] as List;
        } else if (cartData['data'] is Map && cartData['data']['items'] is List) {
          itemsList = cartData['data']['items'] as List;
        } else if (cartData['data'] is List) {
          itemsList = cartData['data'] as List;
        }

        if (itemsList != null) {
          for (final item in itemsList) {
            if (item is Map<String, dynamic>) {
              try {
                items.add(CartItem.fromJson(item));
              } catch (e) {
                print('Cart item parsing error: $e');
                // Invalid itemlarni skip qilish
              }
            }
          }
        }
      }

      final totalPrice = items.fold<double>(0.0, (sum, item) => sum + (item.price * item.quantity));

      emit(
        state.copyWith(
          status: CartStatus.success,
          items: items,
          totalPrice: totalPrice,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Cart ma\'lumotlarini yuklashda xatolik: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCartLoaded(CartLoaded event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));
    await _fetchAndEmitCart(emit);
  }

  Future<void> _onCartItemAdded(CartItemAdded event, Emitter<CartState> emit) async {
    // Validation
    if (event.quantity <= 0) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Miqdor 0 dan katta bo\'lishi kerak',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));
    try {
      await _repo.saveToCart(
        productId: event.productId,
        quantity: event.quantity,
        state: 'add',
      );
      await _fetchAndEmitCart(emit);
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Mahsulotni qo\'shishda xatolik: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCartItemRemoved(CartItemRemoved event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));
    try {
      await _repo.saveToCart(
        productId: event.productId,
        quantity: 0,
        state: 'remove',
      );
      await _fetchAndEmitCart(emit);
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Mahsulotni o\'chirishda xatolik: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCartItemQuantityUpdated(CartItemQuantityUpdated event, Emitter<CartState> emit) async {
    // Validation
    if (event.quantity <= 0) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Miqdor 0 dan katta bo\'lishi kerak',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));
    try {
      await _repo.saveToCart(
        productId: event.productId,
        quantity: event.quantity,
        state: 'update',
      );
      await _fetchAndEmitCart(emit);
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Miqdorni yangilashda xatolik: ${e.toString()}',
        ),
      );
    }
  }
}
