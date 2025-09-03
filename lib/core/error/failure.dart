enum AuthError {
  userNotFound,
  wrongPassword,
  unknown, 
  userAlreadyExists, 
  serverError, 
  networkError, 
  invalidCredentials, 
  phoneNotVerified, 
  invalidCode,
  validationError,
  phoneFormatError,
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
      case AuthError.userAlreadyExists:
        return "Bu telefon raqami allaqachon ro'yxatdan o'tgan.";
      case AuthError.serverError:
        return "Server xatoligi yuz berdi. Qaytadan urinib ko'ring.";
      case AuthError.networkError:
        return "Internet aloqasini tekshiring va qaytadan urinib ko'ring.";
      case AuthError.invalidCredentials:
        return "Login ma'lumotlari noto'g'ri.";
      case AuthError.phoneNotVerified:
        return "Telefon raqami tasdiqlanmagan.";
      case AuthError.invalidCode:
        return "Tasdiqlash kodi noto'g'ri yoki muddati tugagan.";
      case AuthError.validationError:
        return "Kiritilgan ma'lumotlar noto'g'ri formatda.";
      case AuthError.phoneFormatError:
        return "Telefon raqami noto'g'ri formatda kiritilgan.";
    }
  }
}

class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException([this.message = "Foydalanuvchi topilmadi"]);

  @override
  String toString() => message;
}

// Phone number utility functions
class PhoneUtils {
  static String cleanPhoneNumber(String phone) {
    // Remove all non-digit characters
    return phone.replaceAll(RegExp(r'[^\d]'), '').trim();
  }

  static String formatPhoneNumber(String phone) {
    final cleaned = cleanPhoneNumber(phone);
    
    // If it's a 9-digit number, add Uzbekistan country code
    if (cleaned.length == 9 && !cleaned.startsWith('998')) {
      return '998$cleaned';
    }
    
    return cleaned;
  }

  static bool isValidPhoneNumber(String phone) {
    final cleaned = cleanPhoneNumber(phone);
    
    // Check if it's at least 9 digits
    if (cleaned.length < 9) return false;
    
    // Check if it starts with valid Uzbekistan codes
    if (cleaned.length == 12 && cleaned.startsWith('998')) {
      return true;
    }
    
    // Check if it's a 9-digit local number
    if (cleaned.length == 9) {
      return true;
    }
    
    return false;
  }
}