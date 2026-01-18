class UserProfile {
  final String name;
  final String email;
  final String? profileImageUrl;
  final bool isPremium;

  const UserProfile({
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.isPremium = false,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? profileImageUrl,
    bool? isPremium,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
