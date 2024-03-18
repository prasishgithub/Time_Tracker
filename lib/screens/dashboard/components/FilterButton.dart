/*Prasish*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timetracker/l10n.dart';
import 'package:timetracker/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:timetracker/screens/dashboard/components/FilterSheet.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);
    return IconButton(
      tooltip: L10N.of(context).tr.filter,
      icon: const Icon(FontAwesomeIcons.filter),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) => FilterSheet(
          dashboardBloc: bloc,
        ),
      ),
    );
  }
}
