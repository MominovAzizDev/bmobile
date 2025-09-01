// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutModel _$CheckoutModelFromJson(Map<String, dynamic> json) =>
    CheckoutModel(
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      isDeliverable: json['isDeliverable'] as bool,
    );

Map<String, dynamic> _$CheckoutModelToJson(CheckoutModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'email': instance.email,
      'isDeliverable': instance.isDeliverable,
    };
