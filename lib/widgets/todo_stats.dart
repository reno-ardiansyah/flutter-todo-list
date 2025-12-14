import 'package:flutter/material.dart';

class TodoStats extends StatelessWidget {
  final int total;
  final int completed;

  const TodoStats({super.key, required this.total, required this.completed});

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : completed / total;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$completed / $total tasks completed',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: double.parse(percent.toStringAsFixed(2)),
                minHeight: 8,
                backgroundColor: Colors.white12,
                valueColor: const AlwaysStoppedAnimation(
                  Colors.deepPurpleAccent,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${(percent * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
