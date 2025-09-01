import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gazobeton/core/exports.dart';
import 'package:gazobeton/data/repository/auth_repository.dart';
import 'package:gazobeton/features/auth/bloc/auth_event.dart';

import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({
    required AuthRepository repository,
  }) : _repository = repository,
       super(AuthState.initial()) {
    on<LoginSubmitted>(_login);
    on<SignUpSubmitted>(_signUp);
    on<VerifySubmitted>(_verify);
  }

  Future<void> _signUp(SignUpSubmitted event, Emitter<AuthState> emit) async {
    final result = await _repository.signUp(
      firstname: event.firstName,
      lastName: event.lastName,
      phone: event.phone,
      password: event.password,
      confirmPassword: event.confirmPassword,
    );

    result.fold(
      (error) {
        if (error == AuthError.userNotFound) {
          emit(state.copyWith(status: AuthStatus.userNotFound));
        } else {
          emit(state.copyWith(status: AuthStatus.error));
        }
      },
      (success) {
        emit(state.copyWith(status: AuthStatus.submit));
      },
    );
  }

  Future<void> _login(LoginSubmitted event, Emitter<AuthState> emit) async {
    final result = await _repository.login(event.login, event.password);

    result.fold(
      (error) {
        if (error == AuthError.userNotFound) {
          emit(state.copyWith(status: AuthStatus.userNotFound));
        } else {
          emit(state.copyWith(status: AuthStatus.error));
        }
      },
      (token) {
        emit(state.copyWith(status: AuthStatus.submit));
      },
    );
  }

  Future<void> _verify(VerifySubmitted event, Emitter<AuthState> emit) async {
    try {
      final result = await _repository.verification(event.phone, event.code);

      if (result == "verified") {
        emit(state.copyWith(status: AuthStatus.submit)); // Yangi user
      } else if (result == "already_verified") {
        emit(state.copyWith(status: AuthStatus.alreadyExists)); // Login yoki Homega otkaz
      } else {
        emit(state.copyWith(status: AuthStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }
}
