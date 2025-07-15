import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus { idle, success, loading, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  AuthState({required this.status, this.user, this.error});

  factory AuthState.idle() => AuthState(status: AuthStatus.idle);
  factory AuthState.loading() => AuthState(status: AuthStatus.loading);
  factory AuthState.success(User user) =>
      AuthState(status: AuthStatus.success, user: user);
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, error: message);
}
