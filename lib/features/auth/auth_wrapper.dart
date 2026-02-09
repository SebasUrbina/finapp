import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';
import 'splash_screen.dart';
import 'onboarding_screen.dart';
import 'signup_screen.dart';
import 'setup_wrapper.dart';
import '../../core/navigation/app_shell.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authControllerProvider);

    return authStateAsync.when(
      data: (authState) {
        switch (authState.status) {
          case AuthStatus.initial:
            return const SplashScreen();
          case AuthStatus.onboarding:
            return const OnboardingScreen();
          case AuthStatus.unauthenticated:
            return const SignUpScreen();
          case AuthStatus.setup:
            return const SetupWrapper();
          case AuthStatus.authenticated:
            return const AppShell();
        }
      },
      loading: () => const SplashScreen(),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error de autenticación: $error'))),
    );
  }
}
