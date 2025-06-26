import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/flashcard.dart';
import '../services/api_service.dart';

class FlashcardProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Category> _categories = [];
  List<Flashcard> _flashcards = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _errorType; // Track what operation caused the error

  List<Category> get categories => _categories;
  List<Flashcard> get flashcards => _flashcards;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get errorType => _errorType;
  
  // Helper getters for specific error types
  bool get hasFetchCategoriesError => _errorType == 'fetchCategories';
  bool get hasFetchFlashcardsError => _errorType == 'fetchFlashcards';

  // Category operations
  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      _errorType = 'fetchCategories';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createCategory(String name, String description, String color) async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      final newCategory = await _apiService.createCategory(name, description, color);
      _categories.insert(0, newCategory);
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      _errorType = 'createCategory';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCategory(String id, String name, String description, String color) async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      final updatedCategory = await _apiService.updateCategory(id, name, description, color);
      final index = _categories.indexWhere((category) => category.id == id);
      if (index != -1) {
        _categories[index] = updatedCategory;
      }
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      _errorType = 'updateCategory';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      // First, call the API to delete the category
      await _apiService.deleteCategory(id);
      
      // Only remove from list if API call succeeded (no exception thrown)
      _categories.removeWhere((category) => category.id == id);
    } catch (e) {
      // If API call fails, set error message but don't remove from list
      _errorMessage = _getErrorMessage(e);
      _errorType = 'deleteCategory';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Helper method to convert exceptions to user-friendly messages
  String _getErrorMessage(Object error) {
    if (error is CategoryNotFoundError) {
      return error.toString();
    } else if (error is CategoryNotEmptyError) {
      return error.toString();
    } else if (error is CategoryPermissionError) {
      return error.toString();
    } else if (error is CategoryValidationError) {
      return error.toString();
    } else if (error is CategoryError) {
      return error.toString();
    } else {
      return error.toString();
    }
  }

  // Flashcard operations
  Future<void> fetchFlashcards(String categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      _flashcards = await _apiService.getFlashcards(categoryId);
    } catch (e) {
      _errorMessage = e.toString();
      _errorType = 'fetchFlashcards';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createFlashcard(String categoryId, String frontSide, String backSide) async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      final newFlashcard = await _apiService.createFlashcard(categoryId, frontSide, backSide);
      _flashcards.insert(0, newFlashcard);
    } catch (e) {
      _errorMessage = e.toString();
      _errorType = 'createFlashcard';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateFlashcard(String id, String frontSide, String backSide) async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      final updatedFlashcard = await _apiService.updateFlashcard(id, frontSide, backSide);
      final index = _flashcards.indexWhere((flashcard) => flashcard.id == id);
      if (index != -1) {
        _flashcards[index] = updatedFlashcard;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _errorType = 'updateFlashcard';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteFlashcard(String id) async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      // First, call the API to delete the flashcard
      await _apiService.deleteFlashcard(id);
      
      // Only remove from list if API call succeeded (no exception thrown)
      _flashcards.removeWhere((flashcard) => flashcard.id == id);
    } catch (e) {
      // If API call fails, set error message but don't remove from list
      _errorMessage = e.toString();
      _errorType = 'deleteFlashcard';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _errorType = null;
    notifyListeners();
  }

  void clearFlashcards() {
    _flashcards.clear();
    notifyListeners();
  }
} 