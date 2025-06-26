import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../models/category.dart';

class CategoryDialog extends StatefulWidget {
  final Category? category;

  const CategoryDialog({
    super.key,
    this.category,
  });

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedColor = '#2196F3'; // Default blue color

  // Define 8 available colors
  final List<Map<String, dynamic>> _availableColors = [
    {'name': 'Blue', 'value': '#2196F3', 'color': Colors.blue},
    {'name': 'Red', 'value': '#F44336', 'color': Colors.red},
    {'name': 'Green', 'value': '#4CAF50', 'color': Colors.green},
    {'name': 'Orange', 'value': '#FF9800', 'color': Colors.orange},
    {'name': 'Purple', 'value': '#9C27B0', 'color': Colors.purple},
    {'name': 'Teal', 'value': '#009688', 'color': Colors.teal},
    {'name': 'Pink', 'value': '#E91E63', 'color': Colors.pink},
    {'name': 'Indigo', 'value': '#3F51B5', 'color': Colors.indigo},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _descriptionController.text = widget.category!.description;
      _selectedColor = widget.category!.color;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      final flashcardProvider = Provider.of<FlashcardProvider>(context, listen: false);
      
      try {
        if (widget.category == null) {
          // Create new category
          await flashcardProvider.createCategory(
            _nameController.text.trim(),
            _descriptionController.text.trim(),
            _selectedColor,
          );
        } else {
          // Update existing category
          await flashcardProvider.updateCategory(
            widget.category!.id,
            _nameController.text.trim(),
            _descriptionController.text.trim(),
            _selectedColor,
          );
        }

        if (mounted) {
          Navigator.of(context).pop();
          if (flashcardProvider.errorMessage == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.category == null
                      ? 'Category created successfully'
                      : 'Category updated successfully',
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
      title: Text(widget.category == null ? 'Create Category' : 'Edit Category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a category name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Color selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Color:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableColors.map((colorInfo) {
                    final isSelected = _selectedColor == colorInfo['value'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = colorInfo['value'];
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colorInfo['color'],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey.shade300,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
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
              onPressed: flashcardProvider.isLoading ? null : _saveCategory,
              child: flashcardProvider.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.category == null ? 'Create' : 'Update'),
            );
          },
        ),
      ],
    );
  }
} 