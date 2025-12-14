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
    if (args != null && args is Map<String, dynamic>) {
      _editingId = args['id'] as String?;
      _titleController = TextEditingController(text: args['title'] ?? '');
      _descController = TextEditingController(text: args['description'] ?? '');
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

    final result = {
      if (_editingId != null) 'id': _editingId,
      'title': title,
      'description': _descController.text.trim(),
      'colorValue': _colorValue,
    };

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingId != null;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isEditing ? 'Edit Todo' : 'Add Todo', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  Align(alignment: Alignment.centerLeft, child: Text('Color', style: Theme.of(context).textTheme.bodyMedium)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _palette.map((c) {
                      final selected = c.value == _colorValue;
                      return GestureDetector(
                        onTap: () => setState(() => _colorValue = c.value),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: selected ? Border.all(width: 3, color: Colors.white) : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      child: Text(isEditing ? 'Save' : 'Add'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
