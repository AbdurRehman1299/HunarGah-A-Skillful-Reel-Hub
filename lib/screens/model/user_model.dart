class UserModel {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final String? profileImageUrl;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.bio = "No bio yet. Tap edit to add one!",
    this.profileImageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      username: map['username'] ?? 'HunarGah User',
      email: map['email'] ?? '',
      bio: map['bio'] ?? "No bio yet. Tap edit to add one!",
      profileImageUrl: map['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }
}
