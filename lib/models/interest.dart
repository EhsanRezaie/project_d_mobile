// lib/models/interest.dart
class Interest {
  final String id;
  final String name;
  final String category;
  final String? icon;

  Interest({
    required this.id,
    required this.name,
    required this.category,
    this.icon,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'],
      name: json['name'],
      category: json['category'] ?? '',
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      if (icon != null) 'icon': icon,
    };
  }
}