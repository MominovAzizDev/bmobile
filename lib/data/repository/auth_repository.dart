import 'package:dartz/dartz.dart';
import 'package:gazobeton/core/exports.dart';

import '../models/auth_models/auth_model.dart';

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
    final result = await client.signUp(AuthModel(
      firstName: firstname,
      lastName: lastName,
      phoneNumber: phone,
      password: password,
      confirmPassword: confirmPassword,
    ));

    if (result == "success") {
      return const Right(true);
    } else if (result == "already_registered") {
      return const Left(AuthError.userNotFound);
    } else {
      return const Left(AuthError.unknown);
    }
  }


  Future<Either<AuthError, String>> login(String login, String password) async {
    await SecureStorage.deleteToken();
    await SecureStorage.deleteCredentials();
    try {
      final token = await client.login(login, password);
      jwt = token;
      await SecureStorage.saveToken(token);
      await SecureStorage.saveCredentials(login, password);
      return Right(token);
    } on UserNotFoundException {
      return const Left(AuthError.userNotFound);
    } catch (e) {
      return const Left(AuthError.unknown);
    }
  }

  Future<String?> verification(String phone, String code) async {
    return await client.verification(phone, code);
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    await SecureStorage.deleteCredentials();
  }

  Future<Either<AuthError, bool>> refreshToken() async {
    final credentials = await SecureStorage.getCredentials();

    final login = credentials['login'];
    final password = credentials['password'];

    if (login == null || password == null) {
      return const Left(AuthError.userNotFound);
    }

    try {
      jwt = await client.login(login, password);
      await SecureStorage.saveToken(jwt!);
      return const Right(true);
    } on UserNotFoundException {
      return const Left(AuthError.userNotFound);
    } catch (e) {
      return const Left(AuthError.unknown);
    }
  }
}
