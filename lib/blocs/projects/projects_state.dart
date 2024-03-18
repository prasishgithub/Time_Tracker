/*Prasish*/

import 'package:equatable/equatable.dart';
import 'package:timetracker/models/project.dart';

class ProjectsState extends Equatable {
  final List<Project> projects;

  const ProjectsState(this.projects);

  static ProjectsState initial() {
    return const ProjectsState([]);
  }

  ProjectsState.clone(ProjectsState state) : this(state.projects);

  @override
  List<Object> get props => [projects];
  @override
  bool get stringify => true;
}
