import '../../../core/exports.dart';
part 'checkout_model.g.dart';

@JsonSerializable()
class CheckoutModel {
  final String fullName;
  final String phoneNumber;
  final String address;
  final String email;
  final bool isDeliverable;

  CheckoutModel({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.isDeliverable,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) => _$CheckoutModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutModelToJson(this);
}
