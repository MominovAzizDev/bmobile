import '../../../core/exports.dart';
part 'orders_state.freezed.dart';

enum OrdersStatus { error, loading, idle }

@freezed
abstract class OrdersState with _$OrdersState {
  const factory OrdersState({
    required List<OrdersModel> model,
    required OrdersStatus status,
  }) = _OrdersState;

  factory OrdersState.initial() {
    return OrdersState(model: [], status: OrdersStatus.loading);
  }
}
