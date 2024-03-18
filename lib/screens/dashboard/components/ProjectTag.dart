/*Prasish*/

import 'package:flutter/material.dart';
import 'package:timetracker/components/ProjectColour.dart';
import 'package:timetracker/l10n.dart';
import 'package:timetracker/models/project.dart';
import 'package:timetracker/themes.dart';

class ProjectTag extends StatelessWidget {
  final Project? project;

  const ProjectTag({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      ProjectColour(mini: true, project: project),
      const SizedBox(width: 6),
      Text(
        project?.name ?? L10N.of(context).tr.noProject,
        style: theme.textTheme.bodyMedium?.copyWith(
            color: project == null
                ? ThemeUtil.getOnBackgroundLighter(context)
                : theme.colorScheme.onBackground),
      )
    ]);
  }
}
