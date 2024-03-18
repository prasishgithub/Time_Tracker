/*Prasish*/

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timetracker/blocs/projects/bloc.dart';
import 'package:timetracker/components/ProjectColour.dart';
import 'package:timetracker/l10n.dart';
import 'package:timetracker/models/timer_entry.dart';
import 'package:timetracker/screens/timer/TimerEditor.dart';

import 'package:timetracker/utils/timer_utils.dart';

class StoppedTimerRowNarrowSimple extends StatefulWidget {
  final TimerEntry timer;
  final Function(BuildContext) resumeTimer;
  final Function(BuildContext) deleteTimer;

  const StoppedTimerRowNarrowSimple(
      {Key? key,
      required this.timer,
      required this.resumeTimer,
      required this.deleteTimer})
      : super(key: key);

  @override
  State<StoppedTimerRowNarrowSimple> createState() =>
      _StoppedTimerRowNarrowSimpleState();
}

class _StoppedTimerRowNarrowSimpleState
    extends State<StoppedTimerRowNarrowSimple> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    assert(widget.timer.endTime != null);

    final theme = Theme.of(context);

    return MouseRegion(
        onEnter: (_) => setState(() {
              _hovering = true;
            }),
        onExit: (_) => setState(() {
              _hovering = false;
            }),
        child: Slidable(
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.15,
            children: <Widget>[
              SlidableAction(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  icon: FontAwesomeIcons.trash,
                  onPressed: widget.deleteTimer)
            ],
          ),
          endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.15,
              children: <Widget>[
                SlidableAction(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    icon: FontAwesomeIcons.play,
                    onPressed: (_) => widget.resumeTimer(context))
              ]),
          child: ListTile(
              key: Key("stoppedTimer-${widget.timer.id}"),
              leading: ProjectColour(
                  project: BlocProvider.of<ProjectsBloc>(context)
                      .getProjectByID(widget.timer.projectID)),
              title: Text(
                  TimerUtils.formatDescription(
                      context, widget.timer.description),
                  style: TimerUtils.styleDescription(
                      context, widget.timer.description)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  widget.timer.formatTime(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
                if (_hovering) const SizedBox(width: 4),
                if (_hovering)
                  IconButton(
                      icon: const Icon(FontAwesomeIcons.circlePlay),
                      onPressed: () => widget.resumeTimer(context),
                      tooltip: L10N.of(context).tr.resumeTimer),
              ]),
              onTap: () =>
                  Navigator.of(context).push(MaterialPageRoute<TimerEditor>(
                    builder: (BuildContext context) => TimerEditor(
                      timer: widget.timer,
                    ),
                    fullscreenDialog: true,
                  ))),
        ));
  }
}
