import 'package:flutter/material.dart';
import 'package:todolist/models/todo.dart';

typedef OnEdit = void Function(Map<String, dynamic> initialData);
typedef OnToggle = void Function(String id);
typedef OnDelete = void Function(String id);
typedef OnExpandChange = void Function(String? id);

class TodoList extends StatelessWidget {
  final List<TodoItem> tasks;
  final String? expandedId;
  final OnEdit onEdit;
  final OnToggle onToggle;
  final OnDelete onDelete;
  final OnExpandChange onExpandChange;

  const TodoList({
    super.key,
    required this.tasks,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
    required this.onExpandChange,
    this.expandedId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isOpen = task.id == expandedId;

        return Card(
          color: Colors.white.withOpacity(0.03),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ExpansionTile(
            key: ValueKey(task.id),
            initiallyExpanded: isOpen,
            onExpansionChanged: (open) => onExpandChange(open ? task.id : null),
            leading: CircleAvatar(
              backgroundColor: task.color,
              child: const Icon(Icons.check, color: Colors.white, size: 18),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: task.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                Checkbox(value: task.isDone, onChanged: (_) => onToggle(task.id)),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.description != null && task.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(task.description!, style: const TextStyle(fontSize: 14)),
                      ),
                    Row(
                      children: [
                        Text(
                          'Created: ${DateTime.fromMillisecondsSinceEpoch(int.tryParse(task.id) ?? 0).toLocal()}',
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        const Spacer(),
                        IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => onEdit(task.toJson())),
                        IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: () => onDelete(task.id)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
