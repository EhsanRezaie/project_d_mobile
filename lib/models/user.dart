// lib/models/user.dart
class User {
  final String id;
  final String email;
  final String name;
  final int age;
  final String gender;
  final String? bio;
  final int? height;
  final int? weight;
  final double? lat;
  final double? lng;
  final bool isPremium;
  final DateTime? premiumUntil;
  final bool isActive;
  final bool isProfileComplete;
  final DateTime createdAt;
  final DateTime? lastSeenAt;
  final bool hideLastSeen;
  final String? country;
  final String? province;
  final String? city;
  final bool locationManual;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.gender,
    this.bio,
    this.height,
    this.weight,
    this.lat,
    this.lng,
    this.isPremium = false,
    this.premiumUntil,
    this.isActive = true,
    this.isProfileComplete = false,
    required this.createdAt,
    this.lastSeenAt,
    this.hideLastSeen = false,
    this.country,
    this.province,
    this.city,
    this.locationManual = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      bio: json['bio'],
      height: json['height'],
      weight: json['weight'],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      isPremium: json['is_premium'] ?? false,
      premiumUntil: json['premium_until'] != null 
          ? DateTime.parse(json['premium_until']) 
          : null,
      isActive: json['is_active'] ?? true,
      isProfileComplete: json['is_profile_complete'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      lastSeenAt: json['last_seen_at'] != null 
          ? DateTime.parse(json['last_seen_at']) 
          : null,
      hideLastSeen: json['hide_last_seen'] ?? false,
      country: json['country'],
      province: json['province'],
      city: json['city'],
      locationManual: json['location_manual'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'age': age,
      'gender': gender,
      'bio': bio,
      'height': height,
      'weight': weight,
      'lat': lat,
      'lng': lng,
      'is_premium': isPremium,
      'premium_until': premiumUntil?.toIso8601String(),
      'is_active': isActive,
      'is_profile_complete': isProfileComplete,
      'created_at': createdAt.toIso8601String(),
      'last_seen_at': lastSeenAt?.toIso8601String(),
      'hide_last_seen': hideLastSeen,
      'country': country,
      'province': province,
      'city': city,
      'location_manual': locationManual,
    };
  }
}