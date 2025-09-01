import '../../../core/exports.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository _repo;

  CheckoutBloc({required CheckoutRepository repo}) : _repo = repo, super(CheckoutState.initial()) {
    on<CheckoutSubmitted>(_onLoad);
  }

  Future<void> _onLoad(CheckoutSubmitted event, Emitter<CheckoutState> emit) async {
    print(" CheckoutSubmitted event keldi: fullName=${event.fullName}, phoneNumber=${event.phoneNumber}, address=${event.address}, email=${event.email}, isDeliverable=${event.isDeliverable}");

    try {
      emit(state.copyWith(status: CheckoutStatus.loading));
      print(" Status: LOADING");

      final result = await _repo.fetchCheckout(
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        address: event.address,
        email: event.email,
        isDeliverable: event.isDeliverable,
      );

      emit(state.copyWith(status: CheckoutStatus.success));
      print(" Status: SUCCESS");
    } catch (e) {
      emit(state.copyWith(status: CheckoutStatus.error));
      print(" Status: ERROR: $e");
    }
  }
}
