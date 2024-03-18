/*Prasish*/

import 'package:equatable/equatable.dart';
import 'package:timetracker/models/project.dart';
import 'package:timetracker/models/timer_entry.dart';

abstract class TimersEvent extends Equatable {
  const TimersEvent();
}

class LoadTimers extends TimersEvent {
  @override
  List<Object> get props => [];
}

class CreateTimer extends TimersEvent {
  final String? description;
  final Project? project;
  const CreateTimer({this.description, this.project});
  @override
  List<Object?> get props => [description, project];
}

class UpdateNow extends TimersEvent {
  const UpdateNow();
  @override
  List<Object> get props => [];
}

class StopTimer extends TimersEvent {
  final TimerEntry timer;
  const StopTimer(this.timer);
  @override
  List<Object> get props => [timer];
}

class EditTimer extends TimersEvent {
  final TimerEntry timer;
  const EditTimer(this.timer);
  @override
  List<Object> get props => [timer];
}

class DeleteTimer extends TimersEvent {
  final TimerEntry timer;
  const DeleteTimer(this.timer);
  @override
  List<Object> get props => [timer];
}

class StopAllTimers extends TimersEvent {
  const StopAllTimers();
  @override
  List<Object> get props => [];
}
