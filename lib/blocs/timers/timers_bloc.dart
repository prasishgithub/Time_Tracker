/*Prasish*/

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:timetracker/data_providers/data/data_provider.dart';
import 'package:timetracker/data_providers/settings/settings_provider.dart';
import 'package:timetracker/models/timer_entry.dart';
import './bloc.dart';

class TimersBloc extends Bloc<TimersEvent, TimersState> {
  final DataProvider data;
  final SettingsProvider settings;
  TimersBloc(this.data, this.settings) : super(TimersState.initial()) {
    on<LoadTimers>((event, emit) async {
      List<TimerEntry> timers = await data.listTimers();
      emit(TimersState(timers, DateTime.now()));
    });

    on<CreateTimer>((event, emit) async {
      TimerEntry timer = await data.createTimer(
          description: event.description, projectID: event.project?.id);
      List<TimerEntry> timers =
          state.timers.map((t) => TimerEntry.clone(t)).toList();
      timers.add(timer);
      timers.sort((a, b) => a.startTime.compareTo(b.startTime));
      emit(TimersState(timers, DateTime.now()));
    });

    on<UpdateNow>((event, emit) {
      emit(TimersState(state.timers, DateTime.now()));
    });

    on<StopTimer>((event, emit) async {
      TimerEntry timer = TimerEntry.clone(event.timer, endTime: DateTime.now());
      await data.editTimer(timer);
      List<TimerEntry> timers = state.timers.map((t) {
        if (t.id == timer.id) return TimerEntry.clone(timer);
        return TimerEntry.clone(t);
      }).toList();
      timers.sort((a, b) => a.startTime.compareTo(b.startTime));
      emit(TimersState(timers, DateTime.now()));
    });

    on<EditTimer>((event, emit) async {
      await data.editTimer(event.timer);
      List<TimerEntry> timers = state.timers.map((t) {
        if (t.id == event.timer.id) return TimerEntry.clone(event.timer);
        return TimerEntry.clone(t);
      }).toList();
      timers.sort((a, b) => a.startTime.compareTo(b.startTime));
      emit(TimersState(timers, DateTime.now()));
    });

    on<DeleteTimer>((event, emit) async {
      await data.deleteTimer(event.timer);
      List<TimerEntry> timers = state.timers
          .where((t) => t.id != event.timer.id)
          .map((t) => TimerEntry.clone(t))
          .toList();
      emit(TimersState(timers, DateTime.now()));
    });

    on<StopAllTimers>((event, emit) async {
      List<Future<TimerEntry>> timerEdits = state.timers.map((t) async {
        if (t.endTime == null) {
          TimerEntry timer = TimerEntry.clone(t, endTime: DateTime.now());
          await data.editTimer(timer);
          return timer;
        }
        return TimerEntry.clone(t);
      }).toList();

      List<TimerEntry> timers = await Future.wait(timerEdits);
      timers.sort((a, b) => a.startTime.compareTo(b.startTime));
      emit(TimersState(timers, DateTime.now()));
    });
  }
}
