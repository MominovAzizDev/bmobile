sealed class AuthEvent {}

final class LoginSubmitted extends AuthEvent {
  final String login;
  final String password;

  LoginSubmitted({
    required this.login,
    required this.password,
  });
}

final class VerifySubmitted extends AuthEvent {
  final String phone;
  final String code;

  VerifySubmitted({
    required this.phone,
    required this.code,
  });
}

final class SignUpSubmitted extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String password;
  final String confirmPassword;

  SignUpSubmitted({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });
}
