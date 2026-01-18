import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/user_profile.dart';

class ProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    // Initial mock data - In the future this will come from Firebase
    return const UserProfile(
      name: 'Ethan Cole',
      email: 'ethancoleux@gmail.com',
      profileImageUrl: 'https://i.pravatar.cc/150?u=ethancole',
      isPremium: false,
    );
  }

  void updateProfile({String? name, String? email, String? profileImageUrl}) {
    state = state.copyWith(
      name: name,
      email: email,
      profileImageUrl: profileImageUrl,
    );
  }

  void setPremium(bool isPremium) {
    state = state.copyWith(isPremium: isPremium);
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile>(() {
  return ProfileNotifier();
});
