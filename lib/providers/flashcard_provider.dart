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

  List<Category> get categories => _categories;
  List<Flashcard> get flashcards => _flashcards;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Category operations
  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createCategory(String name, String description) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newCategory = await _apiService.createCategory(name, description);
      _categories.add(newCategory);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCategory(String id, String name, String description) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedCategory = await _apiService.updateCategory(id, name, description);
      final index = _categories.indexWhere((category) => category.id == id);
      if (index != -1) {
        _categories[index] = updatedCategory;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteCategory(id);
      _categories.removeWhere((category) => category.id == id);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Flashcard operations
  Future<void> fetchFlashcards(String categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _flashcards = await _apiService.getFlashcards(categoryId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createFlashcard(String categoryId, String frontSide, String backSide) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newFlashcard = await _apiService.createFlashcard(categoryId, frontSide, backSide);
      _flashcards.add(newFlashcard);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateFlashcard(String id, String frontSide, String backSide) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedFlashcard = await _apiService.updateFlashcard(id, frontSide, backSide);
      final index = _flashcards.indexWhere((flashcard) => flashcard.id == id);
      if (index != -1) {
        _flashcards[index] = updatedFlashcard;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteFlashcard(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteFlashcard(id);
      _flashcards.removeWhere((flashcard) => flashcard.id == id);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearFlashcards() {
    _flashcards.clear();
    notifyListeners();
  }
} 