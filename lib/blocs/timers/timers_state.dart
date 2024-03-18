/*Prasish*/

import 'package:equatable/equatable.dart';
import 'package:timetracker/models/timer_entry.dart';

class TimersState extends Equatable {
  final List<TimerEntry> timers;
  final DateTime now;

  const TimersState(this.timers, this.now);

  static TimersState initial() {
    return TimersState(const [], DateTime.now());
  }

  TimersState.clone(TimersState state) : this(state.timers, DateTime.now());

  int countRunningTimers() {
    return timers.where((t) => t.endTime == null).length;
  }

  @override
  List<Object> get props => [timers, now];
  @override
  bool get stringify => true;
}
