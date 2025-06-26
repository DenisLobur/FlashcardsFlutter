import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/flashcard.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1'; // Replace with your actual API URL
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    return await _authService.getAuthHeaders();
  }

  // Category CRUD operations
  Future<List<Category>> getCategories() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw CategoryPermissionError();
      } else {
        throw CategoryError('Failed to fetch categories: ${response.body}');
      }
    } catch (e) {
      if (e is CategoryError) rethrow;
      throw CategoryError('Error fetching categories: $e');
    }
  }

  Future<Category> createCategory(String name, String description, String color) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'description': description,
          'color': color,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Category.fromJson(data);
      } else if (response.statusCode == 400) {
        // Try to parse validation errors
        try {
          final errorData = jsonDecode(response.body);
          if (errorData is Map && errorData.containsKey('errors')) {
            final errors = Map<String, String>.from(errorData['errors']);
            throw CategoryValidationError(errors);
          }
        } catch (_) {
          // Fallback if parsing fails
        }
        throw CategoryValidationError({'general': 'Invalid category data'});
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw CategoryPermissionError();
      } else {
        throw CategoryError('Failed to create category: ${response.body}');
      }
    } catch (e) {
      if (e is CategoryError) rethrow;
      throw CategoryError('Error creating category: $e');
    }
  }

  Future<Category> updateCategory(String id, String name, String description, String color) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/categories/$id'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'description': description,
          'color': color,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Category.fromJson(data);
      } else if (response.statusCode == 404) {
        throw CategoryNotFoundError(id);
      } else if (response.statusCode == 400) {
        // Try to parse validation errors
        try {
          final errorData = jsonDecode(response.body);
          if (errorData is Map && errorData.containsKey('errors')) {
            final errors = Map<String, String>.from(errorData['errors']);
            throw CategoryValidationError(errors);
          }
        } catch (_) {
          // Fallback if parsing fails
        }
        throw CategoryValidationError({'general': 'Invalid category data'});
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw CategoryPermissionError();
      } else {
        throw CategoryError('Failed to update category: ${response.body}');
      }
    } catch (e) {
      if (e is CategoryError) rethrow;
      throw CategoryError('Error updating category: $e');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/categories/$id'),
        headers: headers,
      );

      switch(response.statusCode) {
        case 204:
          // Successfully deleted
          break;
        case 400:
          throw CategoryNotEmptyError(id);
        case 404:
          throw CategoryNotFoundError(id);
        case 401:
        case 403:
          throw CategoryPermissionError();
        default:
          throw CategoryError('Failed to delete category: ${response.body}');
      }
    } catch (e) {
      if (e is CategoryError) rethrow;
      throw CategoryError('Error deleting category: $e');
    }
  }

  // Flashcard CRUD operations
  Future<List<Flashcard>> getFlashcards(String categoryId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/flashcards?category_id=$categoryId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Flashcard.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch flashcards: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching flashcards: $e');
    }
  }

  Future<Flashcard> createFlashcard(String categoryId, String frontSide, String backSide) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/flashcards'),
        headers: headers,
        body: jsonEncode({
          'frontside': frontSide,
          'backside': backSide,
          'category_id': categoryId,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Flashcard.fromJson(data);
      } else {
        throw Exception('Failed to create flashcard: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating flashcard: $e');
    }
  }

  Future<Flashcard> updateFlashcard(String id, String frontSide, String backSide) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/flashcards/$id'),
        headers: headers,
        body: jsonEncode({
          'frontside': frontSide,
          'backside': backSide,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Flashcard.fromJson(data);
      } else {
        throw Exception('Failed to update flashcard: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating flashcard: $e');
    }
  }

  Future<void> deleteFlashcard(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/flashcards/$id'),
        headers: headers,
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete flashcard: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting flashcard: $e');
    }
  }
} 