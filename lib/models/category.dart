class Category {
  final String id;
  final String name;
  final String description;
  final String userId;
  final DateTime createdAt;
  final String color;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    required this.createdAt,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      color: json['color'] ?? '#2196F3',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
    };
  }
}

// Custom exception classes for category operations
class CategoryError implements Exception {
  final String message;
  final String? categoryId;
  
  CategoryError(this.message, {this.categoryId});
  
  @override
  String toString() => message;
}

class CategoryNotFoundError extends CategoryError {
  CategoryNotFoundError(String categoryId) 
    : super('Category not found', categoryId: categoryId);
  
  @override
  String toString() => 'Category with ID $categoryId was not found';
}

class CategoryNotEmptyError extends CategoryError {
  CategoryNotEmptyError(String categoryId) 
    : super('Cannot delete category with flashcards', categoryId: categoryId);
  
  @override
  String toString() => 'Cannot delete category because it contains flashcards. Please delete all flashcards first.';
}

class CategoryPermissionError extends CategoryError {
  CategoryPermissionError() 
    : super('You do not have permission to perform this action');
  
  @override
  String toString() => 'You do not have permission to perform this action on this category';
}

class CategoryValidationError extends CategoryError {
  final Map<String, String> fieldErrors;
  
  CategoryValidationError(this.fieldErrors) 
    : super('Validation failed');
  
  @override
  String toString() {
    if (fieldErrors.isEmpty) return 'Invalid category data';
    return fieldErrors.values.join(', ');
  }

  // Helper methods for common validation errors
  static CategoryValidationError nameRequired() {
    return CategoryValidationError({'name': 'Category name is required'});
  }

  static CategoryValidationError nameTooLong() {
    return CategoryValidationError({'name': 'Category name is too long'});
  }

  static CategoryValidationError descriptionRequired() {
    return CategoryValidationError({'description': 'Category description is required'});
  }
} 