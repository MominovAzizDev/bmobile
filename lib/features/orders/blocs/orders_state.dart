import '../../../core/exports.dart';

part 'orders_state.freezed.dart';

enum OrdersStatus { error, loading, idle }

@freezed
abstract class OrdersState with _$OrdersState {
  const factory OrdersState({
    required List<OrdersModel> model,
    required OrdersStatus status,
    String? errorMessage,
  }) = _OrdersState;

  factory OrdersState.initial() {
    return const OrdersState(
      model: [],
      status: OrdersStatus.loading,
    );
  }
}