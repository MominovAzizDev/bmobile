import 'package:gazobeton/core/client.dart';

import '../models/auth_models/orders_model.dart';

class OrdersRepository {
  final ApiClient client;

  OrdersRepository({required this.client});

  Future<List<OrdersModel>> fetchOrders() async {
    final rawOrders = await client.fetchOrders();
    return rawOrders.map((e) => OrdersModel.fromJson(e)).toList();
  }

}
