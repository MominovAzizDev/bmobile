import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  const AuthModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  factory AuthModel.fromJson(Map<String,dynamic>json)=>_$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}
