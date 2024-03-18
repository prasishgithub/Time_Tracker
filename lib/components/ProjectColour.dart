/*Prasish*/

import 'package:flutter/material.dart';
import 'package:timetracker/models/project.dart';
import 'package:timetracker/themes.dart';

class ProjectColour extends StatelessWidget {
  static const double _size = 20;
  final Project? project;
  final bool? mini;
  const ProjectColour({Key? key, this.project, this.mini}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool m = mini ?? false;
    double scale = m ? 14 / 20 : 1.0;

    return Container(
      key: Key("pc-${project?.id}-m"),
      width: _size * scale,
      height: _size * scale,
      decoration: BoxDecoration(
        color: project?.colour ?? Colors.transparent,
        //borderRadius: BorderRadius.circular(SIZE * 0.5 * scale),
        border: project == null
            ? Border.all(
                color: ThemeUtil.getOnBackgroundLighter(context),
                width: m ? 2.5 : 3.0,
              )
            : null,
        shape: BoxShape.circle,
      ),
    );
  }
}
