/*Prasish*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timetracker/blocs/projects/bloc.dart';
import 'package:timetracker/blocs/settings/settings_bloc.dart';
import 'package:timetracker/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:timetracker/screens/dashboard/components/DescriptionField.dart';
import 'package:timetracker/screens/dashboard/components/ProjectSelectField.dart';
import 'package:timetracker/screens/dashboard/components/RunningTimers.dart';
import 'package:timetracker/screens/dashboard/components/StartTimerButton.dart';
import 'package:timetracker/screens/dashboard/components/StoppedTimers.dart';
import 'package:timetracker/screens/dashboard/components/TopBar.dart';
import 'package:timetracker/ad.dart';

class DashboardScreen extends StatelessWidget {
  //adBanner
  final BannerAd myBanner = BannerAd(
    adUnitId: AdManager.bannerAdUnitId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  )..load();

  //consructor with myBanner
  DashboardScreen({Key? key, myBanner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final screenBorders = MediaQuery.of(context).padding;

    return BlocProvider<DashboardBloc>(
        create: (_) => DashboardBloc(projectsBloc, settingsBloc),
        child: Scaffold(
          appBar: const TopBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              //AdWidget
              SizedBox(
                height: 75,
                child: AdWidget(ad: myBanner),
              ),

              const Expanded(
                flex: 1,
                child: StoppedTimers(),
              ),
              const RunningTimers(),
              Material(
                elevation: 8.0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8 + screenBorders.left, 8,
                      8 + screenBorders.right, 8 + screenBorders.bottom),
                  child: const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ProjectSelectField(),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                          child: DescriptionField(),
                        ),
                      ),
                      SizedBox(
                        width: 75,
                        height: 75,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: const StartTimerButton(),
        ));
  }
}
