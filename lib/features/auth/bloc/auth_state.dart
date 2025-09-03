import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_state.freezed.dart';

enum AuthStatus { error, loading, idle, submit, verify, alreadyExists, userNotFound }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({required AuthStatus status}) = _AuthState;
  factory AuthState.initial() {
    return AuthState(status: AuthStatus.idle);
  }
}
