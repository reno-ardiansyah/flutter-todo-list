import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/todo.dart';

class TodoProvider extends ChangeNotifier {
  final List<TodoItem> _tasks = [];

  List<TodoItem> get tasks => List.unmodifiable(_tasks);

  // LOAD TASKS
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('tasks');
    if (jsonString == null) return;

    final List decoded = jsonDecode(jsonString);

    _tasks
      ..clear()
      ..addAll(decoded.map((e) => TodoItem.fromJson(e)));

    notifyListeners();
  }

  // SAVE TASKS
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(_tasks.map((e) => e.toJson()).toList());

    await prefs.setString('tasks', jsonString);
  }

  // ADD TASK
  void addTask({
    required String title,
    String? description,
    Color color = Colors.blue,
    int priority = 1,
    DateTime? dueDate,
  }) {
    _tasks.add(
      TodoItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        color: color,
        priority: priority,
        dueDate: dueDate,
      ),
    );

    _saveTasks();
    notifyListeners();
  }

  // EDIT TASK
  void editTask({
    required String id,
    String? title,
    String? description,
    Color? color,
    int? priority,
    DateTime? dueDate,
  }) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final task = _tasks[index];

    if (title != null) task.title = title;
    if (description != null) task.description = description;
    if (color != null) task.colorValue = color.value;
    if (priority != null) task.priority = priority;
    if (dueDate != null) task.dueDate = dueDate;

    _saveTasks();
    notifyListeners();
  }

  // TOGGLE DONE STATUS
  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;

    _tasks[index].isDone = !_tasks[index].isDone;
    _saveTasks();
    notifyListeners();
  }

  // DELETE TASK
  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _saveTasks();
    notifyListeners();
  }

  // FILTER & SORT TASKS
  List<TodoItem> get completedTasks =>
      _tasks.where((t) => t.isDone).toList();

  List<TodoItem> get pendingTasks =>
      _tasks.where((t) => !t.isDone).toList();

  List<TodoItem> sortByPriority() {
    return [..._tasks]..sort((a, b) => b.priority.compareTo(a.priority));
  }
}
