import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

enum AuthStatus { initial, unauthenticated, onboarding, setup, authenticated }

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    User? user,
  }) = _AuthState;

  // Computed properties for convenience
  String? get userEmail => user?.email;
  String? get userName => user?.displayName;
  String? get userId => user?.uid;
  String? get photoURL => user?.photoURL;
}
