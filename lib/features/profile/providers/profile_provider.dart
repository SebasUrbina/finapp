import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/user_profile.dart';
import '../../auth/auth_controller.dart';

// Provider that watches auth state and provides user profile
final profileProvider = Provider<UserProfile>((ref) {
  final authState = ref.watch(authControllerProvider);

  // If user is authenticated, return profile from Firebase Auth data
  if (authState.status == AuthStatus.authenticated) {
    return UserProfile(
      name: authState.userName ?? 'Usuario',
      email: authState.userEmail ?? '',
      profileImageUrl: authState.photoURL,
      isPremium: false,
    );
  }

  // Default profile for unauthenticated users
  return const UserProfile(
    name: 'Usuario',
    email: '',
    profileImageUrl: null,
    isPremium: false,
  );
});
