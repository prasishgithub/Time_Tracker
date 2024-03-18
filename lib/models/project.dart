/*Prasish*/

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Project extends Equatable {
  final int id;
  final String name;
  final Color colour;
  final bool archived;

  const Project(
      {required this.id,
      required this.name,
      required this.colour,
      required this.archived});

  @override
  List<Object> get props => [id, name, colour, archived];
  @override
  bool get stringify => true;

  Project.clone(Project project, {String? name, Color? colour, bool? archived})
      : this(
          id: project.id,
          name: name ?? project.name,
          colour: colour ?? project.colour,
          archived: archived ?? project.archived,
        );
}
