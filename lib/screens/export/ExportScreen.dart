/*Prasish*/

import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timetracker/blocs/projects/projects_bloc.dart';
import 'package:timetracker/blocs/settings/bloc.dart';
import 'package:timetracker/components/DateRangeTile.dart';
import 'package:timetracker/components/ProjectTile.dart';
import 'package:timetracker/l10n.dart';
import 'package:timetracker/models/project.dart';
import 'package:timetracker/models/timer_entry.dart';
import 'package:timetracker/screens/export/components/ExportMenu.dart';
import 'package:timetracker/utils/export_utils.dart';
//import 'package:timetracker/ad_interstitial.dart';

// Class to manage ads

class ExportScreen extends StatefulWidget {
  //createInterstitialAd

  const ExportScreen({Key? key}) : super(key: key);

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class DayGroup {
  final DateTime date;
  List<TimerEntry> timers = [];

  DayGroup(this.date);
}

class _ExportScreenState extends State<ExportScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<Project?> selectedProjects = [];
  //final AdManager adManager = AdManager(); // Instantiate AdManager
  @override
  void initState() {
    super.initState();
    //   adManager.initialize(); // Initialize interstitial ad
    final projects = BlocProvider.of<ProjectsBloc>(context);
    selectedProjects = <Project?>[null]
        .followedBy(projects.state.projects
            .where((p) => !p.archived)
            .map((p) => Project.clone(p)))
        .toList();

    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _startDate = settingsBloc.getFilterStartDate();
  }

  // @override
  // void dispose() {
  //   adManager.dispose(); // Dispose of resources including interstitial ad
  //   super.dispose();
  // }

  // void _showInterstitialAd() {
  //   if (adManager.isInterstitialAdReady) {
  //     adManager.showInterstitialAd();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);

    final dateFormat = DateFormat.yMMMEd();

    return Scaffold(
      appBar: AppBar(
        title: Text(L10N.of(context).tr.exportImport),
        actions: <Widget>[
          ExportMenu(dateFormat: dateFormat),
        ],
      ),
      body: Stack(children: [
        ListView(
          children: <Widget>[
            DateRangeTile(
                startDate: _startDate,
                endDate: _endDate,
                onStartChosen: (DateTime? dt) =>
                    setState(() => _startDate = dt),
                onEndChosen: (DateTime? dt) => setState(() => _endDate = dt)),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settingsState) =>
                  ExpansionTile(
                key: const Key("optionColumns"),
                title: Text(L10N.of(context).tr.columns,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700)),
                children: <Widget>[
                  SwitchListTile.adaptive(
                    title: Text(L10N.of(context).tr.date),
                    value: settingsState.exportIncludeDate,
                    onChanged: (bool value) => settingsBloc
                        .add(SetBoolValueEvent(exportIncludeDate: value)),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  SwitchListTile.adaptive(
                    title: Text(L10N.of(context).tr.project),
                    value: settingsState.exportIncludeProject,
                    onChanged: (bool value) => settingsBloc
                        .add(SetBoolValueEvent(exportIncludeProject: value)),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  SwitchListTile.adaptive(
                    title: Text(L10N.of(context).tr.description),
                    value: settingsState.exportIncludeDescription,
                    onChanged: (bool value) => settingsBloc.add(
                        SetBoolValueEvent(exportIncludeDescription: value)),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  SwitchListTile.adaptive(
                    title: Text(L10N.of(context).tr.combinedProjectDescription),
                    value: settingsState.exportIncludeProjectDescription,
                    onChanged: (bool value) => settingsBloc.add(
                        SetBoolValueEvent(
                            exportIncludeProjectDescription: value)),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  SwitchListTile.adaptive(
                    title: Text(L10N.of(context).tr.startTime),
                    value: settingsState.exportIncludeStartTime,
                    onChanged: (bool value) => settingsBloc
                        .add(SetBoolValueEvent(exportIncludeStartTime: value)),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  SwitchListTile.adaptive(
                    title: Text(L10N.of(context).tr.endTime),
                    value: settingsState.exportIncludeEndTime,
                    onChanged: (bool value) => settingsBloc
                        .add(SetBoolValueEvent(exportIncludeEndTime: value)),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  SwitchListTile.adaptive(
                    title: Text(L10N.of(context).tr.timeH),
                    value: settingsState.exportIncludeDurationHours,
                    onChanged: (bool value) => settingsBloc.add(
                        SetBoolValueEvent(exportIncludeDurationHours: value)),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  SwitchListTile.adaptive(
                    title: Text(L10N.of(context).tr.notes),
                    value: settingsState.exportIncludeNotes,
                    onChanged: (bool value) => settingsBloc
                        .add(SetBoolValueEvent(exportIncludeNotes: value)),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
            ProjectTile(
              projects: projectsBloc.state.projects.where((p) => !p.archived),
              isEnabled: (project) =>
                  selectedProjects.any((p) => p?.id == project?.id),
              onToggled: (project) => setState(() {
                if (selectedProjects.any((p) => p?.id == project?.id)) {
                  selectedProjects.removeWhere((p) => p?.id == project?.id);
                } else {
                  selectedProjects.add(project);
                }
              }),
              onNoneSelected: () => setState(() {
                selectedProjects.clear();
              }),
              onAllSelected: () => selectedProjects = <Project?>[null]
                  .followedBy(projectsBloc.state.projects
                      .where((p) => !p.archived)
                      .map((p) => Project.clone(p)))
                  .toList(),
            ),
            ExpansionTile(
              title: Text(L10N.of(context).tr.options,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700)),
              children: <Widget>[
                BlocBuilder<SettingsBloc, SettingsState>(
                  bloc: settingsBloc,
                  builder:
                      (BuildContext context, SettingsState settingsState) =>
                          SwitchListTile.adaptive(
                    title: Text(L10N.of(context).tr.groupTimers),
                    value: settingsState.exportGroupTimers,
                    onChanged: (bool value) => settingsBloc
                        .add(SetBoolValueEvent(exportGroupTimers: value)),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FloatingActionButton.extended(
                  heroTag: "csv",
                  label: Text(L10N.of(context).tr.exportCSV),
                  icon: const Icon(FontAwesomeIcons.fileCsv),
                  onPressed: () async {
                    //_showInterstitialAd(); // Show interstitial ad
                    final localizations = L10N.of(context);
                    await _export(
                      localizations: localizations,
                      stringContent: ExportUtils.toCSVString(
                          context, _startDate, _endDate, selectedProjects),
                      mimetype: "text/csv",
                      fileName:
                          "timetracker_${DateTime.now().toIso8601String().split('T').first}.csv",
                      dateFormat: dateFormat,
                    );
                    // _showInterstitialAd(); // Show interstitial ad
                  },
                ),
                FloatingActionButton.extended(
                  heroTag: "pdf",
                  label: Text(L10N.of(context).tr.exportPDF),
                  icon: const Icon(FontAwesomeIcons.solidFilePdf),
                  onPressed: () async {
                    // _showInterstitialAd(); // Show interstitial ad
                    final localizations = L10N.of(context);
                    final pdf = await ExportUtils.toPDF(
                      context,
                      _startDate,
                      _endDate ?? DateTime.now(),
                      selectedProjects,
                    );
                    final pdfBytes = await pdf.save();
                    await _export(
                      localizations: localizations,
                      byteContent: pdfBytes,
                      mimetype: "application/pdf",
                      fileName:
                          "timetracker_${DateTime.now().toIso8601String().split('T').first}.pdf",
                      dateFormat: dateFormat,
                    );
                    // _showInterstitialAd(); // Show interstitial ad
                  },
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Future<void> _export(
      {required L10N localizations,
      String? stringContent,
      Uint8List? byteContent,
      required String mimetype,
      required String fileName,
      required DateFormat dateFormat}) async {
    assert((stringContent == null) !=
        (byteContent ==
            null)); //Either stringContent or byteContent is provided, not both
    if (Platform.isMacOS || Platform.isLinux) {
      final outputFile = await FilePicker.platform.saveFile(
        dialogTitle: "",
        fileName: fileName,
      );

      if (outputFile != null) {
        if (stringContent != null) {
          await File(outputFile).writeAsString(stringContent, flush: true);
        } else {
          await File(outputFile).writeAsBytes(byteContent!);
        }
      }
    } else {
      final directory = (Platform.isAndroid)
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      final localPath = '${directory!.path}/$fileName';

      if (stringContent != null) {
        await File(localPath).writeAsString(stringContent, flush: true);
      } else {
        await File(localPath).writeAsBytes(byteContent!);
      }
      await Share.shareXFiles([XFile(localPath, mimeType: mimetype)],
          subject: localizations.tr
              .timetrackerEntries(dateFormat.format(DateTime.now())));
    }
  }
}
