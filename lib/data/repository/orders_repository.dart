import 'package:gazobeton/core/client.dart';
import '../models/auth_models/orders_model.dart';

class OrdersRepository {
  final ApiClient client;

  OrdersRepository({required this.client});

  // GET orders list
  Future<List<OrdersModel>> fetchOrders({int? page, int? take}) async {
    try {
      final rawOrders = await client.fetchOrders(page: page, take: take);
      return rawOrders.map((e) => OrdersModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Repository: Orders olishda xatolik - $e');
    }
  }

  // POST create new order from cart
  Future<OrdersModel> createOrder() async {
    try {
      final response = await client.createOrder();
      return OrdersModel.fromJson(response);
    } catch (e) {
      throw Exception('Repository: Order yaratishda xatolik - $e');
    }
  }

  // PUT update order
  Future<OrdersModel> updateOrder({
    required String orderId,
    String? status,
    String? address,
    bool? isDeliverable,
  }) async {
    try {
      final response = await client.updateOrder(
        orderId: orderId,
        status: status,
        address: address,
        isDeliverable: isDeliverable,
      );
      return OrdersModel.fromJson(response);
    } catch (e) {
      throw Exception('Repository: Order yangilashda xatolik - $e');
    }
  }

  // Cancel order
  Future<OrdersModel> cancelOrder(String orderId) async {
    return updateOrder(orderId: orderId, status: 'bekor qilingan');
  }

  // Complete order  
  Future<OrdersModel> completeOrder(String orderId) async {
    return updateOrder(orderId: orderId, status: 'yakunlangan');
  }
}