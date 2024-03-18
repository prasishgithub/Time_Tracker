/*Prasish*/

extension StartOfWeek on DateTime {
  DateTime startOfWeek({int startOfWeekDay = DateTime.sunday}) {
    // change to Sunday as start..
    int diff = (7 + (weekday - startOfWeekDay)) % 7;
    DateTime dt = add(Duration(days: -diff));
    return DateTime(dt.year, dt.month, dt.day);
  }
}
