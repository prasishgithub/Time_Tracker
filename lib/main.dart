/*Prasish*/

import 'dart:async';

import 'dart:io';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timetracker/ad.dart';
import 'package:timetracker/blocs/locale/locale_bloc.dart';
import 'package:timetracker/blocs/notifications/notifications_bloc.dart';
import 'package:timetracker/blocs/projects/bloc.dart';
import 'package:timetracker/blocs/settings/settings_bloc.dart';
import 'package:timetracker/blocs/settings/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetracker/blocs/settings/settings_state.dart';
import 'package:timetracker/blocs/theme/theme_bloc.dart';
import 'package:timetracker/blocs/timers/bloc.dart';
import 'package:timetracker/data_providers/data/data_provider.dart';
import 'package:timetracker/data_providers/notifications/notifications_provider.dart';
import 'package:timetracker/data_providers/settings/settings_provider.dart';
import 'package:timetracker/fontlicenses.dart';
import 'package:timetracker/l10n.dart';
import 'package:timetracker/models/theme_type.dart';
import 'package:timetracker/screens/dashboard/DashboardScreen.dart';
import 'package:timetracker/themes.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import 'package:timetracker/data_providers/data/database_provider.dart';
import 'package:timetracker/data_providers/settings/shared_prefs_settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //admob-line1
  MobileAds.instance.initialize(); //admob-line2
  WidgetsFlutterBinding.ensureInitialized();
  final SettingsProvider settings = await SharedPrefsSettingsProvider.load();

  // get a path to the database file
  if (Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  final databaseFile = await DatabaseProvider.getDatabaseFile();
  await databaseFile.parent.create(recursive: true);

  final DataProvider data = await DatabaseProvider.open(databaseFile.path);
  final NotificationsProvider notifications =
      await NotificationsProvider.load();
  await runMain(settings, data, notifications);
}

Future<void> runMain(SettingsProvider settings, DataProvider data,
    NotificationsProvider notifications) async {
  // setup intl date formats?
  //await initializeDateFormatting();
  LicenseRegistry.addLicense(getFontLicenses);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(
        create: (_) => ThemeBloc(settings),
      ),
      BlocProvider<LocaleBloc>(
        create: (_) => LocaleBloc(settings),
      ),
      BlocProvider<SettingsBloc>(
        create: (_) => SettingsBloc(settings, data),
      ),
      BlocProvider<TimersBloc>(
        create: (_) => TimersBloc(data, settings),
      ),
      BlocProvider<ProjectsBloc>(
        create: (_) => ProjectsBloc(data),
      ),
      BlocProvider<NotificationsBloc>(
        create: (_) => NotificationsBloc(notifications),
      ),
    ],
    child: timetrackerApp(settings: settings),
  ));
}

class timetrackerApp extends StatefulWidget {
  final SettingsProvider settings;
  const timetrackerApp({Key? key, required this.settings}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _timetrackerAppState();
}

class _timetrackerAppState extends State<timetrackerApp>
    with WidgetsBindingObserver {
  // Instance of AdManager
  final AdManager adManager = AdManager();
  // Banner ad instance
  late BannerAd myBanner;

  late Timer _updateTimersTimer;
  Brightness? brightness;

  @override
  void initState() {
    _updateTimersTimer = Timer.periodic(const Duration(seconds: 1),
        (_) => BlocProvider.of<TimersBloc>(context).add(const UpdateNow()));
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final timersBloc = BlocProvider.of<TimersBloc>(context);
    settingsBloc.stream.listen((settingsState) => _updateNotificationBadge(
        settingsState, timersBloc.state.countRunningTimers()));
    timersBloc.stream.listen((timersState) => _updateNotificationBadge(
        settingsBloc.state, timersState.countRunningTimers()));

    // send commands to our top-level blocs to get them to initialize
    settingsBloc.add(LoadSettingsFromRepository());
    timersBloc.add(LoadTimers());
    BlocProvider.of<ProjectsBloc>(context).add(LoadProjects());
    BlocProvider.of<ThemeBloc>(context).add(const LoadThemeEvent());
    BlocProvider.of<LocaleBloc>(context).add(const LoadLocaleEvent());

    // Initialize AdManager and load the banner ad
    adManager.initialize();
    myBanner = adManager.myBanner!;
    myBanner.load();
  }

  void _updateNotificationBadge(SettingsState settingsState, int count) async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!settingsState.hasAskedNotificationPermissions &&
          !settingsState.showBadgeCounts) {
        // they haven't set the permission yet
        return;
      } else if (settingsState.showBadgeCounts) {
        // need to ask permission
        if (count > 0) {
          FlutterAppBadger.updateBadgeCount(count);
        } else {
          FlutterAppBadger.removeBadge();
        }
      } else {
        // remove any and all badges if we disable the option
        FlutterAppBadger.removeBadge();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // print("application lifecycle changed to: " + state.toString());
    if (state == AppLifecycleState.paused) {
      final settings = BlocProvider.of<SettingsBloc>(context).state;
      final timers = BlocProvider.of<TimersBloc>(context).state;
      final localeState = BlocProvider.of<LocaleBloc>(context).state;
      final locale = localeState.locale ?? const Locale("en");
      final notificationsBloc = BlocProvider.of<NotificationsBloc>(context);
      final l10n = await L10N.load(locale);

      if (settings.showRunningTimersAsNotifications &&
          timers.countRunningTimers() > 0) {
        // print("showing notification");
        notificationsBloc.add(ShowNotification(
            title: l10n.tr.runningTimersNotificationTitle,
            body: l10n.tr.runningTimersNotificationBody));
      } else {
        // print("not showing notification");
      }
    } else if (state == AppLifecycleState.resumed) {
      BlocProvider.of<NotificationsBloc>(context)
          .add(const RemoveNotifications());
    }
  }

  @override
  void dispose() {
    _updateTimersTimer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    //ad dispose
    myBanner.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() => brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness);
  }

  ThemeData getTheme(
      ThemeType? type, ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    if (type == ThemeType.autoMaterialYou) {
      if (brightness == Brightness.dark) {
        type = ThemeType.darkMaterialYou;
      } else {
        type = ThemeType.lightMaterialYou;
      }
    }
    switch (type) {
      case ThemeType.light:
        return ThemeUtil.lightTheme;
      case ThemeType.dark:
        return ThemeUtil.darkTheme;
      case ThemeType.black:
        return ThemeUtil.blackTheme;
      case ThemeType.lightMaterialYou:
        return ThemeUtil.getThemeFromColors(
            brightness: Brightness.light,
            colors: lightDynamic ?? ThemeUtil.lightColors,
            appBarBackground:
                lightDynamic?.background ?? ThemeUtil.lightColors.background,
            appBarForeground: lightDynamic?.onBackground ??
                ThemeUtil.lightColors.onBackground);
      case ThemeType.darkMaterialYou:
        return ThemeUtil.getThemeFromColors(
            brightness: Brightness.dark,
            colors: darkDynamic ?? ThemeUtil.darkColors,
            appBarBackground:
                darkDynamic?.background ?? ThemeUtil.darkColors.background,
            appBarForeground:
                darkDynamic?.onBackground ?? ThemeUtil.darkColors.onBackground);
      case ThemeType.auto:
      default:
        return brightness == Brightness.dark
            ? ThemeUtil.darkTheme
            : ThemeUtil.lightTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SettingsProvider>.value(value: widget.settings),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState themeState) =>
            BlocBuilder<LocaleBloc, LocaleState>(
          builder: (BuildContext context, LocaleState localeState) =>
              DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) =>
                MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Time Tracker',
              home: DashboardScreen(
                myBanner: myBanner,
              ),
              theme: getTheme(themeState.theme, lightDynamic, darkDynamic),
              localizationsDelegates: const [
                L10N.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: localeState.locale,
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
                Locale('cs'),
                Locale('da'),
                Locale('de'),
                Locale('es'),
                Locale('fr'),
                Locale('hi'),
                Locale('id'),
                Locale('it'),
                Locale('ja'),
                Locale('ko'),
                Locale('nb', 'NO'),
                Locale('pt'),
                Locale('ru'),
                Locale('tr'),
                Locale('zh', 'CN'),
                Locale('zh', 'TW'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
