// lib/models/blocked_user.dart
class BlockedUser {
  final String id;
  final String userId;
  final String? name;
  final int? age;
  final String? mainPhotoUrl;
  final String? blockedAt;

  BlockedUser({
    required this.id,
    required this.userId,
    this.name,
    this.age,
    this.mainPhotoUrl,
    this.blockedAt,
  });

  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    return BlockedUser(
      id: json['id'] ?? '',
      userId: json['blocked_user_id'] ?? '',
      name: json['blocked_user_name'],
      age: json['blocked_user_age'],
      mainPhotoUrl: json['main_photo_url'],
      blockedAt: json['blocked_at'],
    );
  }
}
