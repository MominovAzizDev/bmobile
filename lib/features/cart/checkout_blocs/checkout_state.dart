// lib/features/checkout/bloc/checkout_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'checkout_state.freezed.dart';

enum CheckoutStatus { idle, loading, success, error }

@freezed
abstract class CheckoutState with _$CheckoutState {
  const factory CheckoutState({
    @Default(CheckoutStatus.idle) CheckoutStatus status,
  }) = _CheckoutState;

  factory CheckoutState.initial() => const CheckoutState();
}
