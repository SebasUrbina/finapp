import 'dart:async';

import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/auth/domain/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/providers/finance_providers.dart';

// Export AuthState for easy access
export 'domain/auth_state.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  Future<AuthState> _checkUserStatus(User user) async {
    try {
      // Check if user needs setup (no accounts)
      final accounts = await ref
          .read(financeRepositoryProvider)
          .getAccounts(user.uid);
      final needsSetup = accounts.isEmpty;

      return AuthState(
        status: needsSetup ? AuthStatus.setup : AuthStatus.authenticated,
        user: user,
      );
    } catch (e) {
      // If error checking accounts, default to authenticated to let user retry or see dashboard error
      return AuthState(status: AuthStatus.authenticated, user: user);
    }
  }

  Future<AuthState> _handleSignOut() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding =
        prefs.getBool('hasCompletedOnboarding') ?? false;

    return AuthState(
      status: hasCompletedOnboarding
          ? AuthStatus.unauthenticated
          : AuthStatus.onboarding,
      user: null,
    );
  }

  @override
  FutureOr<AuthState> build() async {
    final authService = ref.watch(firebaseAuthServiceProvider);

    // Subscribe to auth changes
    final sub = authService.authStateChanges.listen((user) async {
      // Avoid updating state if the notifier is disposed
      // (Though keepAlive=true prevents early disposal, it's good practice)

      if (user != null) {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => _checkUserStatus(user));
      } else {
        state = await AsyncValue.guard(() => _handleSignOut());
      }
    });

    ref.onDispose(() => sub.cancel());

    // Initial check for current user
    final currentUser = authService.currentUser;
    if (currentUser != null) {
      return _checkUserStatus(currentUser);
    }

    return _handleSignOut();
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(firebaseAuthServiceProvider);
      final credential = await authService.signInWithGoogle();
      if (credential?.user == null) {
        // User cancelled or error, revert to unauthenticated
        return _handleSignOut();
      }
      return _checkUserStatus(credential!.user!);
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(firebaseAuthServiceProvider);
      await authService.signOut();
      return _handleSignOut();
    });
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);

    // Update state to unauthenticated explicitly if currently onboarding
    if (state.value?.status == AuthStatus.onboarding) {
      state = AsyncValue.data(
        state.value!.copyWith(status: AuthStatus.unauthenticated),
      );
    }
  }

  Future<void> completeSetup() async {
    // Just update the status locally, strict check will happen on next app launch/login
    if (state.value != null) {
      state = AsyncValue.data(
        state.value!.copyWith(status: AuthStatus.authenticated),
      );
    }
  }
}
