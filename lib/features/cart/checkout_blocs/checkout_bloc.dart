import 'package:gazobeton/core/exports.dart';
import 'package:gazobeton/features/cart/bloc/cart_bloc.dart';
import 'package:gazobeton/features/orders/blocs/orders_bloc.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository _repo;
  final CartBloc _cartBloc;
  final OrdersBloc _ordersBloc;

  CheckoutBloc({
    required CheckoutRepository repo,
    required CartBloc cartBloc,
    required OrdersBloc ordersBloc,
  })  : _repo = repo,
        _cartBloc = cartBloc,
        _ordersBloc = ordersBloc,
        super(CheckoutState.initial()) {
    on<CheckoutSubmitted>(_onCheckoutSubmitted);
  }

  Future<void> _onCheckoutSubmitted(
      CheckoutSubmitted event, Emitter<CheckoutState> emit) async {
    try {
      emit(CheckoutState(status: CheckoutStatus.loading));

      // 1) Checkout ma'lumotlarini yuborish
      await _repo.fetchCheckout(
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        address: event.address,
        email: event.email,
        isDeliverable: event.isDeliverable,
      );

      // 2) Yangi buyurtma yaratish
      _ordersBloc.add(OrdersCreate());

      emit(CheckoutState(status: CheckoutStatus.success));
    } catch (e) {
      // ✅ CheckoutState da errorMessage bo'lmasa, faqat status yuboramiz
      emit(CheckoutState(status: CheckoutStatus.error));
    }
  }
}
