import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gazobeton/core/error/failure.dart';
import 'package:gazobeton/data/repository/auth_repository.dart';
import 'package:gazobeton/features/auth/bloc/auth_event.dart';
import 'package:gazobeton/features/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({required AuthRepository repository}) : _repository = repository, super(AuthState.initial()) {
    
    on<LoginSubmitted>(_login);
    on<SignUpSubmitted>(_signUp);
    on<VerifySubmitted>(_verify);
    on<LogoutSubmitted>(_logout);
    on<CheckAuthStatus>(_checkAuthStatus);
  }

  Future<void> _signUp(SignUpSubmitted event, Emitter<AuthState> emit) async {
    // Validate inputs first
    if (event.firstName.trim().isEmpty || 
        event.lastName.trim().isEmpty || 
        event.phone.trim().isEmpty || 
        event.password.trim().isEmpty ||
        event.confirmPassword.trim().isEmpty) {
      emit(state.copyWith(status: AuthStatus.error));
      return;
    }

    if (event.password != event.confirmPassword) {
      emit(state.copyWith(status: AuthStatus.error));
      return;
    }

    if (event.password.length < 6) {
      emit(state.copyWith(status: AuthStatus.error));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _repository.signUp(
      firstname: event.firstName.trim(),
      lastName: event.lastName.trim(),
      phone: event.phone.trim(),
      password: event.password.trim(),
      confirmPassword: event.confirmPassword.trim(),
    );

    result.fold(
      (error) {
        switch (error) {
          case AuthError.userAlreadyExists:
            emit(state.copyWith(status: AuthStatus.alreadyExists));
            break;
          case AuthError.invalidCredentials:
            emit(state.copyWith(status: AuthStatus.error));
            break;
          case AuthError.networkError:
            emit(state.copyWith(status: AuthStatus.error));
            break;
          default:
            emit(state.copyWith(status: AuthStatus.error));
        }
      },
      (success) {
        emit(state.copyWith(status: AuthStatus.verify)); // Go to verification
      },
    );
  }

  Future<void> _login(LoginSubmitted event, Emitter<AuthState> emit) async {
    // Validate inputs first
    if (event.login.trim().isEmpty || event.password.trim().isEmpty) {
      emit(state.copyWith(status: AuthStatus.error));
      return;
    }

    if (event.password.length < 6) {
      emit(state.copyWith(status: AuthStatus.error));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _repository.login(
      event.login.trim(), 
      event.password.trim(),
    );

    result.fold(
      (error) {
        switch (error) {
          case AuthError.userNotFound:
            emit(state.copyWith(status: AuthStatus.error));
            break;
          case AuthError.invalidCredentials:
            emit(state.copyWith(status: AuthStatus.error));
            break;
          case AuthError.phoneNotVerified:
            emit(state.copyWith(status: AuthStatus.verify));
            break;
          case AuthError.networkError:
            emit(state.copyWith(status: AuthStatus.error));
            break;
          default:
            emit(state.copyWith(status: AuthStatus.error));
        }
      },
      (token) {
        if (token.isNotEmpty) {
          emit(state.copyWith(status: AuthStatus.submit));
        } else {
          emit(state.copyWith(status: AuthStatus.error));
        }
      },
    );
  }

  Future<void> _verify(VerifySubmitted event, Emitter<AuthState> emit) async {
    // Validate inputs first
    if (event.phone.trim().isEmpty || event.code.trim().isEmpty) {
      emit(state.copyWith(status: AuthStatus.error));
      return;
    }

    if (event.code.trim().length != 6) {
      emit(state.copyWith(status: AuthStatus.error));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _repository.verification(
      event.phone.trim(), 
      event.code.trim(),
    );

    result.fold(
      (error) {
        switch (error) {
          case AuthError.invalidCode:
            emit(state.copyWith(status: AuthStatus.error));
            break;
          case AuthError.networkError:
            emit(state.copyWith(status: AuthStatus.error));
            break;
          default:
            emit(state.copyWith(status: AuthStatus.error));
        }
      },
      (verificationResult) {
        if (verificationResult == "verified") {
          emit(state.copyWith(status: AuthStatus.submit));
        } else if (verificationResult == "already_verified") {
          emit(state.copyWith(status: AuthStatus.alreadyExists));
        } else {
          emit(state.copyWith(status: AuthStatus.error));
        }
      },
    );
  }

  Future<void> _logout(LogoutSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await _repository.logout();
    emit(AuthState.initial());
  }

  Future<void> _checkAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    final isLoggedIn = await _repository.isLoggedIn();
    if (isLoggedIn) {
      emit(state.copyWith(status: AuthStatus.submit));
    } else {
      emit(state.copyWith(status: AuthStatus.idle));
    }
  }
}