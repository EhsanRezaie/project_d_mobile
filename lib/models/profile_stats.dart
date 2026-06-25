// lib/models/profile_stats.dart

class ProfileStats {
  final int likesSent;
  final int matches;
  final int messages;
  final int likesRemainingToday;

  ProfileStats({
    this.likesSent = 0,
    this.matches = 0,
    this.messages = 0,
    this.likesRemainingToday = 0,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      likesSent: json['total_likes_sent'] ?? 0,
      matches: json['total_matches'] ?? 0,
      messages: json['total_messages'] ?? 0,
      likesRemainingToday: json['likes_remaining_today'] ?? 0,
    );
  }
}