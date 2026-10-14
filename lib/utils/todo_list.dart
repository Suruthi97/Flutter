import 'package:flutter/material.dart';

class Todolist extends StatelessWidget {
  const Todolist({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    this.onChanged
  });

  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 0,
        left: 20,
        right: 20,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade300,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
              checkColor: Colors.blue.shade300,
              activeColor: Colors.white,
              side: BorderSide(
                color: Colors.white,
              ),
            ),
            Text(
              taskName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                decoration: taskCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                decorationColor: Colors.white,
                decorationThickness: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}