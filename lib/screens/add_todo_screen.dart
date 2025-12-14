import 'dart:ui';
import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  int _colorValue = Colors.blue.value;
  String? _editingId;

  final List<Color> _palette = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.grey,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map<String, dynamic>) {
      _editingId = args['id'];
      _titleController =
          TextEditingController(text: args['title'] ?? '');
      _descController =
          TextEditingController(text: args['description'] ?? '');
      _colorValue = args['colorValue'] ?? Colors.blue.value;
    } else {
      _editingId = null;
      _titleController = TextEditingController();
      _descController = TextEditingController();
      _colorValue = Colors.blue.value;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    Navigator.pop(context, {
      if (_editingId != null) 'id': _editingId,
      'title': title,
      'description': _descController.text.trim(),
      'colorValue': _colorValue,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingId != null;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B0B0C), Color(0xFF1E1E1F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 520),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER
                        Text(
                          isEditing ? 'Edit Task' : 'New Task',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isEditing
                              ? 'Update your task details'
                              : 'Create a new task to stay productive',
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // TITLE
                        TextField(
                          controller: _titleController,
                          decoration: _inputDecoration('Title'),
                        ),

                        const SizedBox(height: 14),

                        // DESCRIPTION
                        TextField(
                          controller: _descController,
                          maxLines: 4,
                          decoration: _inputDecoration('Description'),
                        ),

                        const SizedBox(height: 18),

                        // COLOR PICKER
                        const Text(
                          'Color',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: _palette.map((c) {
                            final selected = c.value == _colorValue;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _colorValue = c.value),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 200),
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: c,
                                  shape: BoxShape.circle,
                                  border: selected
                                      ? Border.all(
                                          width: 3,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 26),

                        // ACTIONS
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.deepPurple,
                                ),
                                onPressed: _save,
                                child:
                                    Text(isEditing ? 'Save' : 'Add'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
