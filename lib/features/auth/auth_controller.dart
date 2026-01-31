import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/firebase_auth_service.dart';

enum AuthStatus { initial, unauthenticated, onboarding, authenticated }

class AuthState {
  final AuthStatus status;
  final String? userEmail;
  final String? userName;
  final String? userId;
  final String? photoURL;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.userEmail,
    this.userName,
    this.userId,
    this.photoURL,
    this.isLoading = false,
    this.errorMessage,
  });

  factory AuthState.initial() =>
      AuthState(status: AuthStatus.initial, isLoading: true);

  AuthState copyWith({
    AuthStatus? status,
    String? userEmail,
    String? userName,
    String? userId,
    String? photoURL,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
      photoURL: photoURL ?? this.photoURL,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  AuthState clearError() {
    return copyWith(errorMessage: null, isLoading: false);
  }
}

class AuthController extends StateNotifier<AuthState> {
  final FirebaseAuthService _authService;

  AuthController(this._authService) : super(AuthState.initial()) {
    _init();
  }

  Future<void> _init() async {
    // Check if onboarding has been completed
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding =
        prefs.getBool('hasCompletedOnboarding') ?? false;

    // Listen to Firebase auth state changes
    _authService.authStateChanges.listen((User? user) {
      if (user != null) {
        // User is signed in
        state = state.copyWith(
          status: AuthStatus.authenticated,
          userEmail: user.email,
          userName: user.displayName,
          userId: user.uid,
          photoURL: user.photoURL,
          isLoading: false,
        );
      } else {
        // User is signed out
        if (hasCompletedOnboarding) {
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            userEmail: null,
            userName: null,
            userId: null,
            isLoading: false,
          );
        } else {
          // Show onboarding for first-time users
          state = state.copyWith(
            status: AuthStatus.onboarding,
            isLoading: false,
          );
        }
      }
    });
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential == null) {
        // User cancelled the sign-in
        state = state.copyWith(isLoading: false);
        return;
      }

      // Auth state listener will handle the state update
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.signOut();
      // Auth state listener will handle the state update
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void clearError() {
    state = state.clearError();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final authService = ref.watch(firebaseAuthServiceProvider);
    return AuthController(authService);
  },
);
