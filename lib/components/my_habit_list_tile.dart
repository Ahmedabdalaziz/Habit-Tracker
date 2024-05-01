import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitListTil extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const MyHabitListTil({
    super.key,
    required this.isCompleted,
    required this.text,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteHabit,
              foregroundColor: Colors.black,
              backgroundColor: const Color(0xFFFE4A49),
              icon: Icons.delete,
              borderRadius:  BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: editHabit,
              foregroundColor: Colors.black,
              backgroundColor: Colors.green,
              icon: Icons.edit,
              borderRadius:  BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            // margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: ListTile(
              leading: Checkbox(
                  activeColor: Colors.green,
                  value: isCompleted,
                  onChanged: onChanged),
              title: Text(text),
            ),
          ),
        ),
      ),
    );
  }
}
