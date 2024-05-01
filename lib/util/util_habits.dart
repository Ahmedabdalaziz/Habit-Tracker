import 'package:habittracker/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any((date) =>
  date.year == today.year &&
      date.month == today.month &&
      date.day == today.day);
}

Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};
  for (var habit in habits) {
    for (var date in habit.completedDay) {
      final normalizationDate = DateTime(date.year, date.month, date.day);
      if (dataset.containsKey(normalizationDate)) {
        dataset[normalizationDate] = dataset[normalizationDate]! + 1;
      }
      else {
        dataset[normalizationDate] = 1;
      }
    }
  }
  return dataset;
}
