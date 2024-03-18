/*Prasish*/

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetracker/blocs/timers/bloc.dart';
import 'package:timetracker/l10n.dart';
import 'package:timetracker/models/timer_entry.dart';
import 'package:timetracker/screens/dashboard/bloc/dashboard_bloc.dart';

import 'RunningTimerRow.dart';

class RunningTimers extends StatelessWidget {
  const RunningTimers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (BuildContext context, DashboardState dashboardState) {
        if (dashboardState.searchString != null) {
          return const SizedBox();
        }

        return BlocBuilder<TimersBloc, TimersState>(
          builder: (BuildContext context, TimersState timersState) {
            final theme = Theme.of(context);

            List<TimerEntry> runningTimers = timersState.timers
                .where((timer) => timer.endTime == null)
                .toList();
            if (runningTimers.isEmpty) {
              return const SizedBox();
            }

            DateTime now = DateTime.now();
            Duration runningTotal = Duration(
                seconds: runningTimers.fold(
                    0,
                    (int sum, TimerEntry t) =>
                        sum + now.difference(t.startTime).inSeconds));

            return Material(
              elevation: 4,
              color: theme.colorScheme.surfaceVariant,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(L10N.of(context).tr.runningTimers,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w700)),
                              Text(TimerEntry.formatDuration(runningTotal),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures()
                                    ],
                                  ))
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    Theme(
                        data: Theme.of(context).copyWith(
                            scrollbarTheme: ScrollbarThemeData(
                                thumbVisibility:
                                    MaterialStateProperty.all<bool>(true))),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: MediaQuery.sizeOf(context).height / 4),
                          child: ListView(
                            shrinkWrap: true,
                            children: runningTimers
                                .map((timer) => RunningTimerRow(
                                    timer: timer, now: timersState.now))
                                .toList(),
                          ),
                        )),
                  ]),
            );
          },
        );
      },
    );
  }
}
