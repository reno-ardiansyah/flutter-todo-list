import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/enums/todo_filter.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/providers/todo_provider.dart';
import 'package:todolist/widgets/todo_filter.dart';
import 'package:todolist/widgets/todo_header.dart';
import 'package:todolist/widgets/todo_list.dart';
import 'package:todolist/widgets/todo_stats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? expandedId;
  TodoFilter _filter = TodoFilter.all;

  void _handleResult(dynamic result) {
    final provider = context.read<TodoProvider>();

    if (result is Map<String, dynamic>) {
      final id = result['id'] as String?;
      final title = result['title'] as String?;
      final description = result['description'] as String?;
      final colorValue = result['colorValue'] as int?;

      if (id != null) {
        provider.editTask(
          id: id,
          title: title,
          description: description,
          color: colorValue != null ? Color(colorValue) : null,
        );
      } else if (title != null && title.isNotEmpty) {
        provider.addTask(
          title: title,
          description: description,
          color: colorValue != null ? Color(colorValue) : Colors.blue,
        );
      }
    } else if (result is String && result.isNotEmpty) {
      provider.addTask(title: result);
    }
  }

  Future<void> _onAdd() async {
    final result = await Navigator.pushNamed(context, '/addTodo');
    if (result != null) _handleResult(result);
  }

  Future<void> _onEdit(Map<String, dynamic> initialData) async {
    final result =
        await Navigator.pushNamed(context, '/addTodo', arguments: initialData);
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

  List<TodoItem> _getFilteredTasks(List<TodoItem> tasks) {
    switch (_filter) {
      case TodoFilter.completed:
        return tasks.where((t) => t.isDone).toList();
      case TodoFilter.pending:
        return tasks.where((t) => !t.isDone).toList();
      case TodoFilter.all:
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TodoProvider>().tasks;
    final filteredTasks = _getFilteredTasks(tasks);
    final completedCount = tasks.where((t) => t.isDone).length;

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
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Task',
          onPressed: _onAdd,
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            const TodoHeader(),

            TodoFilterBar(
              selected: _filter,
              onChanged: (value) {
                setState(() {
                  _filter = value;
                  expandedId = null;
                });
              },
            ),

            TodoStats(
              total: tasks.length,
              completed: completedCount,
            ),

            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks found',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : TodoList(
                      tasks: filteredTasks,
                      expandedId: expandedId,
                      onEdit: _onEdit,
                      onToggle: _onToggle,
                      onDelete: _onDelete,
                      onExpandChange: _onExpandChange,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
