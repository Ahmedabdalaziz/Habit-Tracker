import 'package:flutter/material.dart';

class MyHabitListTil extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;

  const MyHabitListTil({
    Key? key,
    required this.isCompleted,
    required this.text,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green
            : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: ListTile(
        leading: Checkbox(
            value: isCompleted,
            onChanged: onChanged),
        title: Text(text),
      ),
    );
  }
}
