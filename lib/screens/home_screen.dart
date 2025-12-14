import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/providers/todo_provider.dart';
import 'package:todolist/widgets/todo_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? expandedId;

  void _handleResult(dynamic result) {
    final provider = context.read<TodoProvider>();

    if (result is Map<String, dynamic>) {
      final id = result['id'] as String?;
      final title = result['title'] as String?;
      final description = result['description'] as String?;
      final colorValue = result['colorValue'] as int?;

      if (id != null) {
        // edit existing
        provider.editTask(
          id: id,
          title: title,
          description: description,
          color: colorValue != null ? Color(colorValue) : null,
        );
      } else if (title != null && title.isNotEmpty) {
        // add new
        provider.addTask(
          title: title,
          description: description,
          color: colorValue != null ? Color(colorValue) : Colors.blue,
        );
      }
    } else if (result is String && result.isNotEmpty) {
      // backward compatibility
      context.read<TodoProvider>().addTask(title: result);
    }
  }

  void _onAdd() async {
    final result = await Navigator.pushNamed(context, '/addTodo');
    if (result != null) _handleResult(result);
  }

  void _onEdit(Map<String, dynamic> initialData) async {
    final result = await Navigator.pushNamed(context, '/addTodo', arguments: initialData);
    if (result != null) _handleResult(result);
  }

  void _onToggle(String id) {
    context.read<TodoProvider>().toggleTask(id);
  }

  void _onDelete(String id) {
    context.read<TodoProvider>().deleteTask(id);
  }

  void _onExpandChange(String? id) {
    setState(() {
      expandedId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final tasks = provider.tasks;

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
        appBar: AppBar(
          title: const Text('My Tasks'),
          actions: [IconButton(icon: const Icon(Icons.add), onPressed: _onAdd)],
        ),
        body: tasks.isEmpty
            ? const Center(child: Text('No tasks yet', style: TextStyle(fontSize: 16)))
            : TodoList(
                tasks: tasks,
                expandedId: expandedId,
                onEdit: _onEdit,
                onToggle: _onToggle,
                onDelete: _onDelete,
                onExpandChange: _onExpandChange,
              ),
      ),
    );
  }
}
