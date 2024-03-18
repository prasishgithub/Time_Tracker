/*Prasish*/

import 'package:equatable/equatable.dart';

class ProjectDescriptionPair extends Equatable {
  final int? project;
  final String? description;

  const ProjectDescriptionPair(this.project, this.description);

  @override
  List<Object?> get props => [project, description];
}
