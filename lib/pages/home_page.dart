import 'package:flutter/material.dart';
import 'package:habittracker/components/my_drawer.dart';
import 'package:habittracker/components/my_habit_list_tile.dart';
import 'package:habittracker/database/habit_database.dart';
import 'package:habittracker/models/habit.dart';
import 'package:habittracker/pages/heat_map.dart';
import 'package:habittracker/util/util_habits.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

  void editHabit(Habit habit) {
    _textController.text = habit.name;

    showDialog(
      barrierColor: Theme.of(context).colorScheme.background,
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(),
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
            onPressed: () async {
              String newHabitName = _textController.text;
              await context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);
              Navigator.of(context).pop();
              _textController.clear();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void deleteHabit(Habit habit) {
    showDialog(
      barrierColor: Theme.of(context).colorScheme.background,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are u sure to delete ?"),
        actions: [
          TextButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
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
      body: _buildHabitList(), // Use your custom function to build the ListView
    );
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabit;
    return FutureBuilder<DateTime?>(
        future: habitDatabase.getFirstLaunchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHeatMap(
              startDate: snapshot.data!,
              datasets: prepHeatMapDataset(currentHabits),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabit;

    return ListView.builder(
      // Remove physics and shrinkWrap properties to enable scrolling
      itemCount: 2, // One for heat map, one for habit list
      itemBuilder: (context, index) {
        if (index == 0) {
          // Heat Map
          return ListTile(
            title: _buildHeatMap(),
          );
        } else {
          // Habit List
          return Column(
            children: currentHabits.map((habit) {
              bool isCompleteToday = isHabitCompletedToday(habit.completedDay);

              return MyHabitListTil(
                editHabit: (context) => editHabit(habit),
                deleteHabit: (context) => deleteHabit(habit),
                isCompleted: isCompleteToday,
                text: habit.name,
                onChanged: (value) => checkHabitOnOff(value, habit),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
