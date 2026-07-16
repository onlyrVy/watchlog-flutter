/// Represents an authenticated user. Mirrors the `users` table fields
/// that the Laravel API will expose (see backend `UserResource`,
/// built in Phase 2) — id, username, email, join date.
class UserModel {
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.joinDate,
  });

  final int id;
  final String username;
  final String email;
  final DateTime joinDate;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      joinDate: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'created_at': joinDate.toIso8601String(),
    };
  }
}
