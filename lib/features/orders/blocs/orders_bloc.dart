import 'package:gazobeton/core/exports.dart';
import 'package:gazobeton/data/repository/orders_repository.dart';
import 'package:gazobeton/features/orders/blocs/orders_event.dart';
import 'package:gazobeton/features/orders/blocs/orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository _repo;
  
  OrdersBloc({required OrdersRepository repo}) 
      : _repo = repo, 
        super(OrdersState.initial()) {
    on<OrdersLoad>(_onLoad);
    on<OrdersRefresh>(_onRefresh);
    on<OrdersCreate>(_onCreate);
    on<OrdersUpdate>(_onUpdate);
    on<OrdersCancel>(_onCancel);
    
    // Initial load
    add(OrdersLoad());
  }

  Future<void> _onLoad(OrdersLoad event, Emitter<OrdersState> emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.loading));
      
      final orders = await _repo.fetchOrders();
      
      emit(state.copyWith(
        status: OrdersStatus.idle,
        model: orders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefresh(OrdersRefresh event, Emitter<OrdersState> emit) async {
    try {
      // Refresh qilganda loading ko'rsatmaymiz
      final orders = await _repo.fetchOrders();
      
      emit(state.copyWith(
        status: OrdersStatus.idle,
        model: orders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCreate(OrdersCreate event, Emitter<OrdersState> emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.loading));
      
      // Cart dan order yaratish
      final newOrder = await _repo.createOrder();
      
      // Orderlar ro'yxatini yangilash
      final updatedOrders = [newOrder, ...state.model];
      
      emit(state.copyWith(
        status: OrdersStatus.idle,
        model: updatedOrders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdate(OrdersUpdate event, Emitter<OrdersState> emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.loading));
      
      // Order yangilash
      final updatedOrder = await _repo.updateOrder(
        orderId: event.orderId,
        status: event.status,
        address: event.address,
        isDeliverable: event.isDeliverable,
      );
      
      // Local state da ham yangilash
      final updatedOrders = state.model.map((order) {
        if (order.orderId == event.orderId) {
          return updatedOrder;
        }
        return order;
      }).toList();
      
      emit(state.copyWith(
        status: OrdersStatus.idle,
        model: updatedOrders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCancel(OrdersCancel event, Emitter<OrdersState> emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.loading));
      
      // Order bekor qilish
      final cancelledOrder = await _repo.cancelOrder(event.orderId);
      
      // Local state da ham yangilash
      final updatedOrders = state.model.map((order) {
        if (order.orderId == event.orderId) {
          return cancelledOrder;
        }
        return order;
      }).toList();
      
      emit(state.copyWith(
        status: OrdersStatus.idle,
        model: updatedOrders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}