/*Prasish*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetracker/blocs/projects/projects_bloc.dart';
import 'package:timetracker/blocs/settings/settings_bloc.dart';
import 'package:timetracker/blocs/timers/timers_bloc.dart';
import 'package:timetracker/blocs/timers/timers_event.dart';
import 'package:timetracker/l10n.dart';
import 'package:timetracker/models/project.dart';
import 'package:timetracker/models/timer_entry.dart';
import 'package:timetracker/utils/responsiveness_utils.dart';
import 'package:timetracker/screens/dashboard/components/StoppedTimerRowNarrowDense.dart';
import 'package:timetracker/screens/dashboard/components/StoppedTimerRowNarrowSimple.dart';
import 'package:timetracker/screens/dashboard/components/StoppedTimerRowWide.dart';

class StoppedTimerRow extends StatelessWidget {
  final TimerEntry timer;
  final bool isWidescreen;
  final bool showProjectName;

  const StoppedTimerRow(
      {Key? key,
      required this.timer,
      required this.isWidescreen,
      required this.showProjectName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsivenessUtils.isWidescreen(context)
        ? StoppedTimerRowWide(
            timer: timer,
            resumeTimer: _resumeTimer,
            deleteTimer: _deleteTimer,
            showProjectName: showProjectName)
        : BlocProvider.of<SettingsBloc>(context).state.showProjectNames
            ? StoppedTimerRowNarrowDense(
                timer: timer,
                resumeTimer: _resumeTimer,
                deleteTimer: _deleteTimer)
            : StoppedTimerRowNarrowSimple(
                timer: timer,
                resumeTimer: _resumeTimer,
                deleteTimer: _deleteTimer);
  }

  void _resumeTimer(BuildContext context) {
    final timersBloc = BlocProvider.of<TimersBloc>(context);
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    Project? project = projectsBloc.getProjectByID(timer.projectID);
    if (settingsBloc.state.oneTimerAtATime) {
      timersBloc.add(const StopAllTimers());
    }
    timersBloc
        .add(CreateTimer(description: timer.description, project: project));
  }

  void _deleteTimer(BuildContext context) async {
    final timersBloc = BlocProvider.of<TimersBloc>(context);
    final bool delete = await (showDialog<bool>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text(L10N.of(context).tr.confirmDelete),
                  content: Text(L10N.of(context).tr.deleteTimerConfirm),
                  actions: <Widget>[
                    TextButton(
                      child: Text(L10N.of(context).tr.cancel),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: Text(L10N.of(context).tr.delete),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ))) ??
        false;
    if (delete) {
      timersBloc.add(DeleteTimer(timer));
    }
  }
}
