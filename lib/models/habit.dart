import 'package:isar/isar.dart';

part 'habit.g.dart';

@collection
class Habit {
  //id
  Id id = Isar.autoIncrement;

  // name
  late String name;

  //day
  List<DateTime> completedDay = [];

}
