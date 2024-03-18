/*Prasish*/

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timetracker/blocs/projects/bloc.dart';
import 'package:timetracker/blocs/timers/bloc.dart';
import 'package:timetracker/components/ProjectColour.dart';
import 'package:timetracker/l10n.dart';
import 'package:timetracker/models/timer_entry.dart';
import 'package:timetracker/screens/timer/TimerEditor.dart';
import 'package:timetracker/utils/timer_utils.dart';

class RunningTimerRow extends StatelessWidget {
  final TimerEntry timer;
  final DateTime now;

  const RunningTimerRow({Key? key, required this.timer, required this.now})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Slidable(
      startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.15,
          children: <Widget>[
            SlidableAction(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              icon: FontAwesomeIcons.trash,
              onPressed: (_) async {
                final timersBloc = BlocProvider.of<TimersBloc>(context);
                final bool delete = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text(L10N.of(context).tr.confirmDelete),
                              content:
                                  Text(L10N.of(context).tr.deleteTimerConfirm),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(L10N.of(context).tr.cancel),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: Text(L10N.of(context).tr.delete),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                              ],
                            )) ??
                    false;
                if (delete == true) {
                  timersBloc.add(DeleteTimer(timer));
                }
              },
            )
          ]),
      child: ListTile(
          leading: ProjectColour(
              project: BlocProvider.of<ProjectsBloc>(context)
                  .getProjectByID(timer.projectID)),
          title: Text(TimerUtils.formatDescription(context, timer.description),
              style: TimerUtils.styleDescription(context, timer.description)),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(timer.formatTime(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFeatures: [const FontFeature.tabularFigures()],
                )),
            const SizedBox(width: 4),
            IconButton(
              tooltip: L10N.of(context).tr.stopTimer,
              icon: const Icon(FontAwesomeIcons.solidCircleStop),
              onPressed: () {
                final timers = BlocProvider.of<TimersBloc>(context);
                timers.add(StopTimer(timer));
              },
            ),
          ]),
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute<TimerEditor>(
                builder: (BuildContext context) => TimerEditor(
                  timer: timer,
                ),
                fullscreenDialog: true,
              ))),
    );
  }
}
