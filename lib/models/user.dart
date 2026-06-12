class User {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String? bio;
  final int? height;
  final int? weight;
  final double? lat;
  final double? lng;
  final bool isPremium;
  final bool isActive;
  final String? lastSeenAt;
  final String? mainPhotoUrl;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.bio,
    this.height,
    this.weight,
    this.lat,
    this.lng,
    required this.isPremium,
    required this.isActive,
    this.lastSeenAt,
    this.mainPhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      bio: json['bio'],
      height: json['height'],
      weight: json['weight'],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      isPremium: json['is_premium'] ?? false,
      isActive: json['is_active'] ?? true,
      lastSeenAt: json['last_seen_at'],
      mainPhotoUrl: json['main_photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'bio': bio,
      'height': height,
      'weight': weight,
      'lat': lat,
      'lng': lng,
      'is_premium': isPremium,
      'is_active': isActive,
      'last_seen_at': lastSeenAt,
      'main_photo_url': mainPhotoUrl,
    };
  }
}