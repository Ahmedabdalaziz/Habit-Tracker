import 'package:flutter/widgets.dart';
import 'package:habittracker/models/app_settings.dart';
import 'package:habittracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // initialize database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

  // save first data
  Future<void> saveFirstLaunchData() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstlaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //get first data of app launch
  Future<DateTime?> getFirstLaunchData() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstlaunchDate;
  }

  final List<Habit> currentHabit = [];

  // CREATE -ADD NEW HABIT
  Future<void> addHabit(String habitName) async {
    final newHabit = Habit()..name = habitName;
    await isar.writeTxn(() => isar.habits.put(newHabit));
    readHabit();
  }

  Future<void> readHabit() async {
    List<Habit> fetchedHabits = await isar.habits.where().findAll();
    currentHabit.clear();
    currentHabit.addAll(fetchedHabits);
    notifyListeners();
  }

  Future<void> updateHabitComplete(int id, bool isComplete) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      final now = DateTime.now();
      await isar.writeTxn(() async {
        if (isComplete &&
            !habit.completedDay
                .contains(DateTime(now.year, now.month, now.day))) {
          habit.completedDay.add(DateTime(now.year, now.month, now.day));
        } else if (!isComplete) {
          habit.completedDay.removeWhere((day) =>
              day.year == now.year &&
              day.month == now.month &&
              day.day == now.day);
        }
        await isar.habits.put(habit);
      });
    }
    readHabit();
  }

  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        return null;
      });
    }

  }


  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    readHabit();
  }
}
