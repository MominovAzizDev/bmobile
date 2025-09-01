import 'package:freezed_annotation/freezed_annotation.dart';

part 'orders_model.g.dart';

@JsonSerializable()
class OrdersModel {
  final String orderId;
  final String fullname;
  final String phoneNumber;
  final String address;
  final String email;
  final bool isDeliverable;
  final DateTime? orderDate;
  final String status;
  final String userId;

  OrdersModel({
    required this.orderId,
    required this.fullname,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.isDeliverable,
    this.orderDate,
    required this.status,
    required this.userId,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) => _$OrdersModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersModelToJson(this);
}
