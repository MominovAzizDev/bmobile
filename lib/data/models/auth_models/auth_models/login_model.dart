import "package:json_annotation/json_annotation.dart" show JsonSerializable;

part 'login_model.g.dart';

@JsonSerializable(createFactory: false)
class LoginModel {
  final String login;
  final String password;

 const LoginModel({
    required this.login,
    required this.password,
  });

 Map<String,dynamic>toJson()=>_$LoginModelToJson(this);
}
