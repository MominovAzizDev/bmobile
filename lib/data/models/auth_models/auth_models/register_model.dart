import 'package:freezed_annotation/freezed_annotation.dart';
part 'register_model.g.dart';

@JsonSerializable(createFactory: false)
class SignUpModel {
  final String username;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final DateTime birthDate;
  final String password;

  SignUpModel({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.birthDate,
    required this.password,
  });
  Map<String,dynamic>toJson()=>_$SignUpModelToJson(this);

}
