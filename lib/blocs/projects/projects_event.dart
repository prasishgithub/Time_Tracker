/*Prasish*/

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:timetracker/models/project.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();
}

class LoadProjects extends ProjectsEvent {
  @override
  List<Object> get props => [];
}

class CreateProject extends ProjectsEvent {
  final String name;
  final Color colour;
  const CreateProject(this.name, this.colour);
  @override
  List<Object> get props => [name, colour];
}

class EditProject extends ProjectsEvent {
  final Project project;
  const EditProject(this.project);
  @override
  List<Object> get props => [project];
}

class DeleteProject extends ProjectsEvent {
  final Project project;
  const DeleteProject(this.project);
  @override
  List<Object> get props => [project];
}
