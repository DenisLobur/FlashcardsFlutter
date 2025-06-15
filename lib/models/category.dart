class Category {
  final String id;
  final String name;
  final String description;
  final String userId;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 