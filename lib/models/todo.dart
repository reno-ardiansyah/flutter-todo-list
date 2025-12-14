import 'package:flutter/material.dart';

class TodoItem {
  String id;
  String title;
  String? description;
  bool isDone;
  int colorValue;
  int priority;
  DateTime? dueDate;
  DateTime createdAt;

  TodoItem({
    String? id,
    required this.title,
    this.description,
    this.isDone = false,
    Color? color,
    this.priority = 1,
    this.dueDate,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        colorValue = (color ?? Colors.blue).value,
        createdAt = createdAt ?? DateTime.now();

  Color get color => Color(colorValue);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'colorValue': colorValue,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'],
      isDone: json['isDone'] ?? false,
      color: json['colorValue'] != null ? Color(json['colorValue']) : Colors.blue,
      priority: json['priority'] ?? 1,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
