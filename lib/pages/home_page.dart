import 'package:flutter/material.dart';
import 'package:habittracker/components/my_drawer.dart';
import 'package:habittracker/components/my_habit_list_tile.dart';
import 'package:habittracker/database/habit_database.dart';
import 'package:habittracker/models/habit.dart';
import 'package:habittracker/util/util_habits.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();

  void _createNewHabit() {
    showDialog(
      barrierColor: Theme.of(context).colorScheme.background,
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(
            hintText: 'Enter your habit',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _textController.clear();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              String newHabitName = _textController.text;
              context.read<HabitDatabase>().addHabit(newHabitName);
              Navigator.of(context).pop();
              _textController.clear();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitComplete(habit.id, value);
    }
  }

  @override
  void initState() {
    Provider.of<HabitDatabase>(listen: false, context).readHabit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        onPressed: _createNewHabit,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: _buildHabitList(),
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabit;
    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        bool isCompleteToday = isHabitCompletedToday(habit.completedDay);

        return MyHabitListTil(
          isCompleted: isCompleteToday,
          text: habit.name,
          onChanged: (value) => checkHabitOnOff(value, habit),
        );
      },
    );
  }
}
