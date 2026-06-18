// lib/models/user.dart
class User {
  final String id;
  final String email;
  final String? name;
  final int? age;
  final String? gender;
  final String? sexualOrientation;
  final String? bio;
  final int? height;
  final int? weight;
  final String? bodyType;
  final String? relationshipStatus;
  final String? livingSituation;
  final String? childrenStatus;
  final String? smoking;
  final String? drinking;
  final String? education;
  final String? workplace;
  final String? religion;
  final String? ethnicity;
  final String? politicalOrientation;
  final List<String>? languages;
  final String? country;
  final String? province;
  final String? city;
  final double? lat;
  final double? lng;
  final bool locationManual;
  final bool isPremium;
  final DateTime? premiumUntil;
  final bool isVerified;
  final bool isActive;
  final bool isProfileComplete;
  final DateTime createdAt;
  final DateTime? lastSeenAt;
  final bool hideLastSeen;
  final bool hideOnlineStatus;

  User({
    required this.id,
    required this.email,
    this.name,
    this.age,
    this.gender,
    this.sexualOrientation,
    this.bio,
    this.height,
    this.weight,
    this.bodyType,
    this.relationshipStatus,
    this.livingSituation,
    this.childrenStatus,
    this.smoking,
    this.drinking,
    this.education,
    this.workplace,
    this.religion,
    this.ethnicity,
    this.politicalOrientation,
    this.languages,
    this.country,
    this.province,
    this.city,
    this.lat,
    this.lng,
    this.locationManual = false,
    this.isPremium = false,
    this.premiumUntil,
    this.isVerified = false,
    this.isActive = true,
    this.isProfileComplete = false,
    required this.createdAt,
    this.lastSeenAt,
    this.hideLastSeen = false,
    this.hideOnlineStatus = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      sexualOrientation: json['sexual_orientation'],
      bio: json['bio'],
      height: json['height'],
      weight: json['weight'],
      bodyType: json['body_type'],
      relationshipStatus: json['relationship_status'],
      livingSituation: json['living_situation'],
      childrenStatus: json['children_status'],
      smoking: json['smoking'],
      drinking: json['drinking'],
      education: json['education'],
      workplace: json['workplace'],
      religion: json['religion'],
      ethnicity: json['ethnicity'],
      politicalOrientation: json['political_orientation'],
      languages: json['languages'] != null ? List<String>.from(json['languages']) : null,
      country: json['country'],
      province: json['province'],
      city: json['city'],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      locationManual: json['location_manual'] ?? false,
      isPremium: json['is_premium'] ?? false,
      premiumUntil: json['premium_until'] != null 
          ? DateTime.parse(json['premium_until']) 
          : null,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      isProfileComplete: json['is_profile_complete'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      lastSeenAt: json['last_seen_at'] != null 
          ? DateTime.parse(json['last_seen_at']) 
          : null,
      hideLastSeen: json['hide_last_seen'] ?? false,
      hideOnlineStatus: json['hide_online_status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'age': age,
      'gender': gender,
      'sexual_orientation': sexualOrientation,
      'bio': bio,
      'height': height,
      'weight': weight,
      'body_type': bodyType,
      'relationship_status': relationshipStatus,
      'living_situation': livingSituation,
      'children_status': childrenStatus,
      'smoking': smoking,
      'drinking': drinking,
      'education': education,
      'workplace': workplace,
      'religion': religion,
      'ethnicity': ethnicity,
      'political_orientation': politicalOrientation,
      'languages': languages,
      'country': country,
      'province': province,
      'city': city,
      'lat': lat,
      'lng': lng,
      'location_manual': locationManual,
      'is_premium': isPremium,
      'premium_until': premiumUntil?.toIso8601String(),
      'is_verified': isVerified,
      'is_active': isActive,
      'is_profile_complete': isProfileComplete,
      'created_at': createdAt.toIso8601String(),
      'last_seen_at': lastSeenAt?.toIso8601String(),
      'hide_last_seen': hideLastSeen,
      'hide_online_status': hideOnlineStatus,
    };
  }
}