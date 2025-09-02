import 'package:freezed_annotation/freezed_annotation.dart';
part 'checkout_state.freezed.dart';

enum CheckoutStatus { idle, loading, success, submit,error }

@freezed
abstract class CheckoutState with _$CheckoutState {
  const factory CheckoutState({
    required CheckoutStatus status,

  }) = _CheckoutState;

  factory CheckoutState.initial() {
    return const CheckoutState(
      status: CheckoutStatus.idle,
    );
  }
}
