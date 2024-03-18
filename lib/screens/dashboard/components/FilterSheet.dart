/*Prasish*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetracker/blocs/projects/projects_bloc.dart';
import 'package:timetracker/components/DateRangeTile.dart';
import 'package:timetracker/components/ProjectTile.dart';
import 'package:timetracker/screens/dashboard/bloc/dashboard_bloc.dart';

class FilterSheet extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  const FilterSheet({Key? key, required this.dashboardBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
      bloc: dashboardBloc,
      builder: (BuildContext context, DashboardState state) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            DateRangeTile(
              startDate: state.filterStart,
              endDate: state.filterEnd,
              onStartChosen: (dt) {
                dashboardBloc.add(FilterStartChangedEvent(dt));
              },
              onEndChosen: (dt) {
                dashboardBloc.add(FilterEndChangedEvent(dt));
              },
            ),
            ProjectTile(
              projects: projectsBloc.state.projects.where((p) => !p.archived),
              isEnabled: (project) =>
                  !state.hiddenProjects.any((p) => p == project?.id),
              onToggled: (project) {
                List<int?> hiddenProjects =
                    state.hiddenProjects.map((p) => p).toList();
                if (state.hiddenProjects.any((p) => p == project?.id)) {
                  hiddenProjects.removeWhere((p) => p == project?.id);
                } else {
                  hiddenProjects.add(project?.id);
                }
                dashboardBloc.add(FilterProjectsChangedEvent(hiddenProjects));
              },
              onNoneSelected: () => dashboardBloc.add(
                  FilterProjectsChangedEvent(<int?>[null]
                      .followedBy(projectsBloc.state.projects.map((p) => p.id))
                      .toList())),
              onAllSelected: () =>
                  dashboardBloc.add(const FilterProjectsChangedEvent(<int>[])),
            ),
          ],
        );
      },
    );
  }
}
