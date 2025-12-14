import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/app.dart';
import 'providers/todo_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider()..loadTasks(),
      child: const MyApp(),
    ),
  );
}
