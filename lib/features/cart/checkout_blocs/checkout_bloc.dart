import 'package:gazobeton/core/exports.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository _repo;

  CheckoutBloc({required CheckoutRepository repo}) : _repo = repo, super(CheckoutState.initial()) {
    on<CheckoutSubmitted>(_onLoad);
  }

  Future<void> _onLoad(CheckoutSubmitted event, Emitter<CheckoutState> emit) async {
    try {
      emit(state.copyWith(status: CheckoutStatus.loading));

      await _repo.fetchCheckout(
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        address: event.address,
        email: event.email,
        isDeliverable: event.isDeliverable,
      );

      emit(state.copyWith(status: CheckoutStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CheckoutStatus.error));
    }
  }
}