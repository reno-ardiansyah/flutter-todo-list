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

        return Dismissible(
          key: ValueKey(task.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => onDelete(task.id),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Card(
            color: Colors.white.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  unselectedWidgetColor: Colors.white70,
                ),
                child: ExpansionTile(
                  key: ValueKey(task.id),
                  initiallyExpanded: isOpen,
                  onExpansionChanged: (open) =>
                      onExpandChange(open ? task.id : null),

                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (_) => onToggle(task.id),
                  ),

                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),

                      Text(
                        'Created: ${DateTime.fromMillisecondsSinceEpoch(int.tryParse(task.id) ?? 0).toLocal()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Text(
                            task.isDone ? 'Completed' : 'Pending',
                            style: TextStyle(
                              fontSize: 12,
                              color: task.isDone
                                  ? Colors.greenAccent
                                  : Colors.orangeAccent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => onEdit(task.toJson()),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(68, 0, 30, 16),
                        child: Text(
                          task.description!,
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
