sealed class OrdersEvent {}

class OrdersLoad extends OrdersEvent {}

class OrdersRefresh extends OrdersEvent {}

class OrdersCreate extends OrdersEvent {}

class OrdersUpdate extends OrdersEvent {
  final String orderId;
  final String? status;
  final String? address;
  final bool? isDeliverable;

  OrdersUpdate({
    required this.orderId,
    this.status,
    this.address,
    this.isDeliverable,
  });
}

class OrdersCancel extends OrdersEvent {
  final String orderId;
  OrdersCancel(this.orderId);
}
