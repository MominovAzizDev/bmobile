// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersModel _$OrdersModelFromJson(Map<String, dynamic> json) => OrdersModel(
  orderId: json['orderId'] as String,
  fullname: json['fullname'] as String,
  phoneNumber: json['phoneNumber'] as String,
  address: json['address'] as String,
  email: json['email'] as String,
  isDeliverable: json['isDeliverable'] as bool,
  orderDate: json['orderDate'] == null
      ? null
      : DateTime.parse(json['orderDate'] as String),
  status: json['status'] as String,
  userId: json['userId'] as String,
);

Map<String, dynamic> _$OrdersModelToJson(OrdersModel instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'fullname': instance.fullname,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'email': instance.email,
      'isDeliverable': instance.isDeliverable,
      'orderDate': instance.orderDate?.toIso8601String(),
      'status': instance.status,
      'userId': instance.userId,
    };
