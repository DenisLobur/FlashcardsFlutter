import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../models/category.dart';
import '../models/flashcard.dart';
import '../utils/color_utils.dart';
import '../widgets/flashcard_dialog.dart';
import '../widgets/flashcard_widget.dart';

class FlashcardsScreen extends StatefulWidget {
  final Category category;

  const FlashcardsScreen({
    super.key,
    required this.category,
  });

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FlashcardProvider>(context, listen: false)
          .fetchFlashcards(widget.category.id);
    });
  }

  Future<void> _showFlashcardDialog({Flashcard? flashcard}) async {
    showDialog(
      context: context,
      builder: (context) => FlashcardDialog(
        categoryId: widget.category.id,
        flashcard: flashcard,
      ),
    );
  }

  Future<void> _deleteFlashcard(Flashcard flashcard) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Flashcard'),
        content: const Text('Are you sure you want to delete this flashcard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final flashcardProvider = Provider.of<FlashcardProvider>(context, listen: false);
      await flashcardProvider.deleteFlashcard(flashcard.id);
      if (flashcardProvider.errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(flashcardProvider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: ColorUtils.hexToColor(widget.category.color),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, flashcardProvider, child) {
          if (flashcardProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (flashcardProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading flashcards',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    flashcardProvider.errorMessage!,
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      flashcardProvider.clearError();
                      flashcardProvider.fetchFlashcards(widget.category.id);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (flashcardProvider.flashcards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.credit_card,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No flashcards yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first flashcard for this category',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => flashcardProvider.fetchFlashcards(widget.category.id),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: flashcardProvider.flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = flashcardProvider.flashcards[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: FlashcardWidget(
                    flashcard: flashcard,
                    onEdit: () => _showFlashcardDialog(flashcard: flashcard),
                    onDelete: () => _deleteFlashcard(flashcard),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFlashcardDialog(),
        backgroundColor: ColorUtils.hexToColor(widget.category.color),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    // Clear flashcards when leaving the screen
    Provider.of<FlashcardProvider>(context, listen: false).clearFlashcards();
    super.dispose();
  }
} 