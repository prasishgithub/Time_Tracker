/*Prasish*/

import 'package:equatable/equatable.dart';

class TimerEntry extends Equatable {
  final int id;
  final String? description;
  final int? projectID;
  final DateTime startTime;
  final DateTime? endTime;
  final String? notes;

  const TimerEntry(
      {required this.id,
      required this.description,
      required this.projectID,
      required this.startTime,
      required this.endTime,
      this.notes = ""});

  @override
  List<Object?> get props =>
      [id, description, projectID, startTime, endTime, notes];
  @override
  bool get stringify => true;

  TimerEntry.clone(TimerEntry timer,
      {String? description,
      int? projectID,
      DateTime? startTime,
      DateTime? endTime,
      String? notes})
      : this(
          id: timer.id,
          description: description ?? timer.description,
          projectID: projectID ?? timer.projectID,
          startTime: startTime ?? timer.startTime,
          endTime: endTime ?? timer.endTime,
          notes: notes ?? timer.notes,
        );

  static String formatDuration(Duration d) {
    if (d.inHours > 0) {
      return "${d.inHours}:${(d.inMinutes - (d.inHours * 60)).toString().padLeft(2, "0")}:${(d.inSeconds - (d.inMinutes * 60)).toString().padLeft(2, "0")}";
    } else {
      return "${d.inMinutes.toString().padLeft(2, "0")}:${(d.inSeconds - (d.inMinutes * 60)).toString().padLeft(2, "0")}";
    }
  }

  String formatTime() {
    Duration d = (endTime ?? DateTime.now()).difference(startTime);
    return formatDuration(d);
  }
}
