/*Prasish*/

import 'package:equatable/equatable.dart';
import 'package:timetracker/blocs/projects/projects_bloc.dart';
import 'package:timetracker/blocs/timers/timers_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class LoadSettingsFromRepository extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class ImportDatabaseEvent extends SettingsEvent {
  final String path;
  final TimersBloc timers;
  final ProjectsBloc projects;

  const ImportDatabaseEvent(this.path, this.timers, this.projects);

  @override
  List<Object> get props => [path, timers, projects];
}

class SetBoolValueEvent extends SettingsEvent {
  final bool? exportGroupTimers;
  final bool? exportIncludeDate;
  final bool? exportIncludeProject;
  final bool? exportIncludeDescription;
  final bool? exportIncludeProjectDescription;
  final bool? exportIncludeStartTime;
  final bool? exportIncludeEndTime;
  final bool? exportIncludeDurationHours;
  final bool? exportIncludeNotes;
  final bool? groupTimers;
  final bool? collapseDays;
  final bool? autocompleteDescription;
  final bool? defaultFilterStartDateToMonday;
  final bool? oneTimerAtATime;
  final bool? showBadgeCounts;
  final bool? showRunningTimersAsNotifications;
  final bool? showProjectNames;

  const SetBoolValueEvent(
      {this.exportGroupTimers,
      this.exportIncludeDate,
      this.exportIncludeProject,
      this.exportIncludeDescription,
      this.exportIncludeProjectDescription,
      this.exportIncludeStartTime,
      this.exportIncludeEndTime,
      this.exportIncludeDurationHours,
      this.exportIncludeNotes,
      this.groupTimers,
      this.collapseDays,
      this.autocompleteDescription,
      this.defaultFilterStartDateToMonday,
      this.oneTimerAtATime,
      this.showBadgeCounts,
      this.showRunningTimersAsNotifications,
      this.showProjectNames});

  @override
  List<Object?> get props => [
        exportGroupTimers,
        exportIncludeDate,
        exportIncludeProject,
        exportIncludeDescription,
        exportIncludeProjectDescription,
        exportIncludeStartTime,
        exportIncludeEndTime,
        exportIncludeDurationHours,
        exportIncludeNotes,
        groupTimers,
        collapseDays,
        autocompleteDescription,
        defaultFilterStartDateToMonday,
        oneTimerAtATime,
        showBadgeCounts,
        showRunningTimersAsNotifications,
        showProjectNames,
      ];
}

class SetDefaultFilterDays extends SettingsEvent {
  final int? days;

  const SetDefaultFilterDays(this.days);

  @override
  List<Object?> get props => [days];
}
