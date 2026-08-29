// lib/models/interest.dart
class Interest {
  final String id;
  final String name;
  final String? nameLocalized;
  final String category;
  final String? categoryLocalized;
  final String? icon;

  Interest({
    required this.id,
    required this.name,
    this.nameLocalized,
    required this.category,
    this.categoryLocalized,
    this.icon,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'],
      name: json['name'],
      nameLocalized: json['name_localized'],
      category: json['category'] ?? '',
      categoryLocalized: json['category_localized'],
      icon: json['icon'],
    );
  }

  /// Display label — localized when available, stable key otherwise.
  String get label => nameLocalized?.isNotEmpty == true ? nameLocalized! : name;

  /// Display category — localized when available, raw key otherwise.
  String get categoryLabel =>
      categoryLocalized?.isNotEmpty == true ? categoryLocalized! : category;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_localized': nameLocalized,
      'category': category,
      'category_localized': categoryLocalized,
      if (icon != null) 'icon': icon,
    };
  }
}
