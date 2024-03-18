/*Prasish*/

import 'package:bloc/bloc.dart';
import 'package:timetracker/data_providers/data/data_provider.dart';
import 'package:timetracker/models/project.dart';
import './bloc.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final DataProvider data;
  ProjectsBloc(this.data) : super(ProjectsState.initial()) {
    on<LoadProjects>((event, emit) async {
      List<Project> projects = await data.listProjects();
      emit(ProjectsState(projects));
    });

    on<CreateProject>((event, emit) async {
      Project newProject =
          await data.createProject(name: event.name, colour: event.colour);
      List<Project> projects =
          state.projects.map((project) => Project.clone(project)).toList();
      projects.add(newProject);
      projects.sort((a, b) => a.name.compareTo(b.name));
      emit(ProjectsState(projects));
    });

    on<EditProject>((event, emit) async {
      await data.editProject(event.project);
      List<Project> projects = state.projects.map((project) {
        if (project.id == event.project.id) return Project.clone(event.project);
        return Project.clone(project);
      }).toList();
      projects.sort((a, b) => a.name.compareTo(b.name));
      emit(ProjectsState(projects));
    });

    on<DeleteProject>((event, emit) async {
      await data.deleteProject(event.project);
      List<Project> projects = state.projects
          .where((p) => p.id != event.project.id)
          .map((p) => Project.clone(p))
          .toList();
      emit(ProjectsState(projects));
    });
  }
  Project? getProjectByID(int? id) {
    if (id == null) return null;
    for (Project p in state.projects) {
      if (p.id == id) return p;
    }
    return null;
  }
}
