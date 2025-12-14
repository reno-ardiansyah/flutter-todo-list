import 'package:flutter/material.dart';
import 'package:todolist/enums/todo_filter.dart';

class TodoFilterBar extends StatelessWidget {
  final TodoFilter selected;
  final ValueChanged<TodoFilter> onChanged;

  const TodoFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  Widget _chip(String label, TodoFilter value, bool active) {
    return ChoiceChip(
      label: Text(label),
      selected: active,
      onSelected: (_) => onChanged(value),
      selectedColor: Colors.deepPurple,
      backgroundColor: Colors.white10,
      labelStyle: TextStyle(color: active ? Colors.white : Colors.white70),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        children: [
          _chip('All', TodoFilter.all, selected == TodoFilter.all),
          _chip('Pending', TodoFilter.pending, selected == TodoFilter.pending),
          _chip(
            'Completed',
            TodoFilter.completed,
            selected == TodoFilter.completed,
          ),
        ],
      ),
    );
  }
}
