/*Prasish*/

extension CloneTime on DateTime {
  DateTime clone() {
    return DateTime(
        year, month, day, hour, minute, second, millisecond, microsecond);
  }
}
