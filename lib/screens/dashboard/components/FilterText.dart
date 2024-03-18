/*Prasish*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timetracker/l10n.dart';

class FilterText extends StatelessWidget {
  final DateTime? filterStart;
  final DateTime? filterEnd;
  const FilterText({Key? key, this.filterStart, this.filterEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();

    if (filterStart == null && filterEnd == null) return const SizedBox();

    final filterString = (filterStart == null)
        ? L10N.of(context).tr.filterUntil(dateFormat.format(filterEnd!))
        : (filterEnd == null)
            ? L10N.of(context).tr.filterFrom(dateFormat.format(filterStart!))
            : L10N.of(context).tr.filterFromUntil(
                dateFormat.format(filterStart!), dateFormat.format(filterEnd!));

    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Center(
            child: Text(
          filterString,
          style: Theme.of(context).textTheme.bodySmall,
        )));
  }
}
