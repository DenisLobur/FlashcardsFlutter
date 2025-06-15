import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../models/flashcard.dart';

class FlashcardDialog extends StatefulWidget {
  final String categoryId;
  final Flashcard? flashcard;

  const FlashcardDialog({
    super.key,
    required this.categoryId,
    this.flashcard,
  });

  @override
  State<FlashcardDialog> createState() => _FlashcardDialogState();
}

class _FlashcardDialogState extends State<FlashcardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _frontSideController = TextEditingController();
  final _backSideController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.flashcard != null) {
      _frontSideController.text = widget.flashcard!.frontSide;
      _backSideController.text = widget.flashcard!.backSide;
    }
  }

  @override
  void dispose() {
    _frontSideController.dispose();
    _backSideController.dispose();
    super.dispose();
  }

  Future<void> _saveFlashcard() async {
    if (_formKey.currentState!.validate()) {
      final flashcardProvider = Provider.of<FlashcardProvider>(context, listen: false);
      
      try {
        if (widget.flashcard == null) {
          // Create new flashcard
          await flashcardProvider.createFlashcard(
            widget.categoryId,
            _frontSideController.text.trim(),
            _backSideController.text.trim(),
          );
        } else {
          // Update existing flashcard
          await flashcardProvider.updateFlashcard(
            widget.flashcard!.id,
            _frontSideController.text.trim(),
            _backSideController.text.trim(),
          );
        }

        if (mounted) {
          Navigator.of(context).pop();
          if (flashcardProvider.errorMessage == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.flashcard == null
                      ? 'Flashcard created successfully'
                      : 'Flashcard updated successfully',
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(flashcardProvider.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.flashcard == null ? 'Create Flashcard' : 'Edit Flashcard'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _frontSideController,
              decoration: const InputDecoration(
                labelText: 'Front Side (Term/Word)',
                hintText: 'Enter the term or word',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the front side content';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _backSideController,
              decoration: const InputDecoration(
                labelText: 'Back Side (Explanation)',
                hintText: 'Enter the explanation or definition',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the back side content';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        Consumer<FlashcardProvider>(
          builder: (context, flashcardProvider, child) {
            return ElevatedButton(
              onPressed: flashcardProvider.isLoading ? null : _saveFlashcard,
              child: flashcardProvider.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.flashcard == null ? 'Create' : 'Update'),
            );
          },
        ),
      ],
    );
  }
} 