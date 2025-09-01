import 'package:gazobeton/core/exports.dart';


class OrdersBloc extends Bloc<OrdersEvent, OrdersState>{
  final OrdersRepository _repo;
  OrdersBloc({required OrdersRepository repo}): _repo = repo, super(OrdersState.initial()){
    on<OrdersLoad>(_onLoad);
    add(OrdersLoad());
  }

  Future<void>_onLoad(OrdersEvent event, Emitter<OrdersState> emit)async{
    final detail = await _repo.fetchOrders();
    emit(state.copyWith(status: OrdersStatus.idle,model: detail));
  }
}