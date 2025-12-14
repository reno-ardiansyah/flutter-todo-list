import 'package:flutter/material.dart';
import 'package:todolist/screens/add_todo_screen.dart';
import 'package:todolist/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoList',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const HomeScreen(),
        '/addTodo': (_) => const AddTodoScreen(),
      },
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
      ),
    );
  }
}
