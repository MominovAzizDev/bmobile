enum AuthError {
  userNotFound,
  wrongPassword,
  unknown,
}

extension AuthErrorMessage on AuthError {
  String get message {
    switch (this) {
      case AuthError.userNotFound:
        return "Foydalanuvchi topilmadi.";
      case AuthError.wrongPassword:
        return "Parol noto'g'ri.";
      case AuthError.unknown:
      return "Noma'lum xatolik yuz berdi.";
    }
  }
}


class UserNotFoundException implements Exception  {
  final String message;

  UserNotFoundException([this.message = "Foydalanuvchi topilmadi"]);

  @override
  String toString() => message;
}
