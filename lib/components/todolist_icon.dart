import 'package:flutter/material.dart';

class TodolistIcon extends StatelessWidget {
  const TodolistIcon({
    super.key,
    required this.taskName,
    required this.value,
    this.onChanged,
    required this.onDelete,
  });

  final String taskName;
  final bool value;
  final Function(bool?)? onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              checkColor: Colors.white,
              side: BorderSide(color: Colors.white),
            ),
            Expanded(
              child: Text(
                taskName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: value
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: Colors.white,
                  decorationThickness: 2,
                ),
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
