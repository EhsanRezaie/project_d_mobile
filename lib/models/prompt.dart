// lib/models/prompt.dart
class Prompt {
  final String id;
  final String question;
  final String? category;
  final bool isActive;

  Prompt({
    required this.id,
    required this.question,
    this.category,
    this.isActive = true,
  });

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['id'],
      question: json['question'],
      category: json['category'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'category': category,
      'is_active': isActive,
    };
  }
}