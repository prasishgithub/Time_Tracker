/*Prasish*/

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timetracker/screens/dashboard/components/RowSeparator.dart';

class TimerDenseTrailing extends StatelessWidget {
  final Function(BuildContext) resumeTimer;
  final String durationString;

  const TimerDenseTrailing(
      {super.key, required this.resumeTimer, required this.durationString});

  @override
  Widget build(BuildContext context) {
    final directionality = Directionality.of(context);
    final tilePadding = Theme.of(context)
        .expansionTileTheme
        .tilePadding
        ?.resolve(directionality);
    final theme = Theme.of(context);

    return InkWell(
        onTap: () => resumeTimer(context),
        child: Padding(
            padding: EdgeInsetsDirectional.only(
                end: (directionality == TextDirection.ltr
                        ? tilePadding?.right
                        : tilePadding?.left) ??
                    16,
                top: tilePadding?.top ?? 0,
                bottom: tilePadding?.bottom ?? 0),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const RowSeparator(),
                  ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 66),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(durationString,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onBackground,
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              )),
                          const SizedBox(height: 8),
                          const Icon(FontAwesomeIcons.play, size: 16)
                        ],
                      ))
                ])));
  }
}
