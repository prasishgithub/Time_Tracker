/*Prasish*/

import 'package:flutter/material.dart';
import 'package:timetracker/l10n.dart';
import 'package:timetracker/themes.dart';

class TimerUtils {
  static String formatDescription(BuildContext context, String? description) {
    if (description == null || description.trim().isEmpty) {
      return L10N.of(context).tr.noDescription;
    }
    return description;
  }

  static TextStyle styleDescription(BuildContext context, String? description) {
    if (description == null || description.trim().isEmpty) {
      return Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: ThemeUtil.getOnBackgroundLighter(context));
    } else {
      return Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: Theme.of(context).colorScheme.onBackground);
    }
  }
}
