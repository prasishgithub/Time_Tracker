/*Prasish Sharma*/

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timetracker/l10n.dart';
import 'package:timetracker/screens/about/AboutScreen.dart';
import 'package:timetracker/screens/export/ExportScreen.dart';
import 'package:timetracker/screens/projects/ProjectsScreen.dart';
import 'package:timetracker/screens/reports/ReportsScreen.dart';
import 'package:timetracker/screens/settings/SettingsScreen.dart';
import 'package:timetracker/ad_interstitial.dart';

enum MenuItem {
  projects,
  reports,
  export,
  settings,
  about,
}

class PopupMenu extends StatelessWidget {
  final AdManager adManager = AdManager(); // Create an instance of AdManager

  PopupMenu({Key? key}) : super(key: key) {
    adManager.initialize(); // Initialize AdManager when PopupMenu is created
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      key: const Key("menuButton"),
      icon: const Icon(FontAwesomeIcons.bars),
      onSelected: (MenuItem item) {
        if (adManager.isInterstitialAdReady) {
          _showInterstitialAd(context,
              item); // Show interstitial ad when a menu item is selected
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            key: const Key("menuProjects"),
            value: MenuItem.projects,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.layerGroup),
              title: Text(L10N.of(context).tr.projects),
            ),
          ),
          PopupMenuItem(
            key: const Key("menuReports"),
            value: MenuItem.reports,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.chartPie),
              title: Text(L10N.of(context).tr.reports),
            ),
          ),
          PopupMenuItem(
            key: const Key("menuExport"),
            value: MenuItem.export,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.fileExport),
              title: Text(L10N.of(context).tr.exportImport),
            ),
          ),
          PopupMenuItem(
            key: const Key("menuSettings"),
            value: MenuItem.settings,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.gear),
              title: Text(L10N.of(context).tr.settings),
            ),
          ),
          PopupMenuItem(
            key: const Key("menuAbout"),
            value: MenuItem.about,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.dna),
              title: Text(L10N.of(context).tr.about),
            ),
          ),
        ];
      },
    );
  }

  void _showInterstitialAd(BuildContext context, MenuItem selectedItem) {
    if (selectedItem == MenuItem.export || selectedItem == MenuItem.reports) {
      if (adManager.isInterstitialAdReady) {
        adManager.showInterstitialAd();
      }
    }
    // adManager.showInterstitialAd(); // Show interstitial ad when method is called

    // Perform the selected action based on the chosen MenuItem
    switch (selectedItem) {
      case MenuItem.projects:
        Navigator.of(context).push(MaterialPageRoute<ProjectsScreen>(
          builder: (_) => ProjectsScreen(),
        ));
        break;
      case MenuItem.reports:
        Navigator.of(context).push(MaterialPageRoute<ReportsScreen>(
          builder: (_) => const ReportsScreen(),
        ));
        break;
      case MenuItem.export:
        Navigator.of(context).push(MaterialPageRoute<ExportScreen>(
          builder: (_) => const ExportScreen(),
        ));
        break;
      case MenuItem.settings:
        Navigator.of(context).push(MaterialPageRoute<SettingsScreen>(
          builder: (_) => SettingsScreen(),
        ));
        break;
      case MenuItem.about:
        Navigator.of(context).push(MaterialPageRoute<AboutScreen>(
          builder: (_) => AboutScreen(),
        ));
        break;
    }
  }
}
