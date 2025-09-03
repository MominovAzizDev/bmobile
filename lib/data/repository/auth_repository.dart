import 'package:dartz/dartz.dart';
import 'package:gazobeton/core/client.dart';
import 'package:gazobeton/core/error/failure.dart' hide UserNotFoundException;
import 'package:gazobeton/core/services/secure_storage.dart';
import 'package:gazobeton/data/models/auth_models/auth_model.dart';

class AuthRepository {
  final ApiClient client;

  AuthRepository({required this.client});

  String? jwt;

  Future<Either<AuthError, bool>> signUp({
    required String firstname,
    required String lastName,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final cleanPhone = phone
          .replaceAll(RegExp(r'[^\d]'), '') // Keep only digits
          .trim();

      // Validate phone number format
      if (cleanPhone.length < 9) {
        return const Left(AuthError.invalidCredentials);
      }

      // Ensure phone starts with country code (998 for Uzbekistan)
      String formattedPhone = cleanPhone;
      if (!cleanPhone.startsWith('998') && cleanPhone.length == 9) {
        formattedPhone = '998$cleanPhone';
      }

      final result = await client.signUp(AuthModel(
        firstName: firstname.trim(),
        lastName: lastName.trim(),
        phoneNumber: formattedPhone,
        password: password,
        confirmPassword: confirmPassword,
      ));

      switch (result) {
        case "success":
          return const Right(true);
        case "already_registered":
          return const Left(AuthError.userAlreadyExists);
        default:
          return const Left(AuthError.serverError);
      }
    } on ApiException catch (e) {
      if (e.statusCode == 409) {
        return const Left(AuthError.userAlreadyExists);
      } else if (e.statusCode == 400) {
        // Check error message for specific validation errors
        if (e.message.contains("parol") || e.message.contains("password")) {
          return const Left(AuthError.invalidCredentials);
        } else if (e.message.contains("telefon") || e.message.contains("phone")) {
          return const Left(AuthError.invalidCredentials);
        }
        return const Left(AuthError.invalidCredentials);
      }
      return const Left(AuthError.serverError);
    } catch (e) {
      return const Left(AuthError.networkError);
    }
  }

  Future<Either<AuthError, String>> login(String login, String password) async {
    try {
      // Clear old data first
      await SecureStorage.deleteToken();
      await SecureStorage.deleteCredentials();
      
      // Clean phone number - remove any spaces, brackets, dashes
      final cleanPhone = login
          .replaceAll(RegExp(r'[^\d]'), '') // Keep only digits
          .trim();

      // Validate inputs
      if (cleanPhone.isEmpty || password.trim().isEmpty) {
        return const Left(AuthError.invalidCredentials);
      }

      // Validate phone number format
      if (cleanPhone.length < 9) {
        return const Left(AuthError.invalidCredentials);
      }

      // Ensure phone starts with country code (998 for Uzbekistan)
      String formattedPhone = cleanPhone;
      if (!cleanPhone.startsWith('998') && cleanPhone.length == 9) {
        formattedPhone = '998$cleanPhone';
      }
      
      final token = await client.login(formattedPhone, password.trim());
      
      if (token.isNotEmpty) {
        jwt = token;
        await SecureStorage.saveToken(token);
        await SecureStorage.saveCredentials(formattedPhone, password.trim());
        return Right(token);
      } else {
        return const Left(AuthError.invalidCredentials);
      }
    } on UserNotFoundException {
      return const Left(AuthError.userNotFound);
    } on ApiException catch (e) {
      if (e.statusCode == 400) {
        // Parse specific 400 errors
        if (e.message.contains("noto'g'ri") || 
            e.message.contains("wrong") || 
            e.message.toLowerCase().contains("incorrect")) {
          return const Left(AuthError.invalidCredentials);
        } else if (e.message.contains("topilmadi") || 
                   e.message.toLowerCase().contains("not found")) {
          return const Left(AuthError.userNotFound);
        }
        return const Left(AuthError.invalidCredentials);
      } else if (e.statusCode == 401) {
        return const Left(AuthError.invalidCredentials);
      } else if (e.statusCode == 403) {
        return const Left(AuthError.phoneNotVerified);
      }
      return const Left(AuthError.serverError);
    } catch (e) {
      return const Left(AuthError.networkError);
    }
  }

  Future<Either<AuthError, String>> verification(String phone, String code) async {
    try {
      // Clean phone number
      final cleanPhone = phone
          .replaceAll(RegExp(r'[^\d]'), '') // Keep only digits
          .trim();

      // Ensure phone starts with country code
      String formattedPhone = cleanPhone;
      if (!cleanPhone.startsWith('998') && cleanPhone.length == 9) {
        formattedPhone = '998$cleanPhone';
      }

      final result = await client.verification(formattedPhone, code.trim());
      
      switch (result) {
        case "verified":
          return const Right("verified");
        case "already_verified":
          return const Right("already_verified");
        default:
          return const Left(AuthError.invalidCode);
      }
    } on ApiException catch (e) {
      if (e.statusCode == 400) {
        return const Left(AuthError.invalidCode);
      }
      return const Left(AuthError.serverError);
    } catch (e) {
      return const Left(AuthError.networkError);
    }
  }

  Future<Either<AuthError, bool>> refreshToken() async {
    try {
      final credentials = await SecureStorage.getCredentials();

      final login = credentials['login'];
      final password = credentials['password'];

      if (login == null || password == null) {
        return const Left(AuthError.userNotFound);
      }

      final token = await client.login(login, password);
      if (token.isNotEmpty) {
        jwt = token;
        await SecureStorage.saveToken(token);
        return const Right(true);
      } else {
        return const Left(AuthError.invalidCredentials);
      }
    } on UserNotFoundException {
      return const Left(AuthError.userNotFound);
    } on ApiException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 401) {
        return const Left(AuthError.invalidCredentials);
      }
      return const Left(AuthError.serverError);
    } catch (e) {
      return const Left(AuthError.networkError);
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await SecureStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getCurrentToken() async {
    return await SecureStorage.getToken();
  }

  Future<void> logout() async {
    try {
      // Clear all stored data
      await SecureStorage.deleteToken();
      await SecureStorage.deleteCredentials();
      jwt = null;
    } catch (e) {
      // Even if there's an error, we clear the local jwt
      jwt = null;
    }
  }
}