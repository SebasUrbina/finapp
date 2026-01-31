import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';
import 'splash_screen.dart';
import 'onboarding_screen.dart';
import 'signup_screen.dart';
import '../../core/navigation/app_shell.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    switch (authState.status) {
      case AuthStatus.initial:
        return const SplashScreen();
      case AuthStatus.onboarding:
        return const OnboardingScreen();
      case AuthStatus.unauthenticated:
        return const SignUpScreen();
      case AuthStatus.authenticated:
        return const AppShell();
    }
  }
}
