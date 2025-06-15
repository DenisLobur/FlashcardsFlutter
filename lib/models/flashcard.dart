class Flashcard {
  final String id;
  final String categoryId;
  final String frontSide; // Term or word
  final String backSide;  // Explanation
  final DateTime createdAt;

  Flashcard({
    required this.id,
    required this.categoryId,
    required this.frontSide,
    required this.backSide,
    required this.createdAt,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      frontSide: json['frontSide'] ?? '',
      backSide: json['backSide'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'frontSide': frontSide,
      'backSide': backSide,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 