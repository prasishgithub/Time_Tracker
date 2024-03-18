/*Prasish*/

// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/rendering.dart';
import 'package:timetracker/data_providers/settings/settings_provider.dart';
import 'package:timetracker/models/theme_type.dart';

class MockSettingsProvider extends SettingsProvider {
  late Map<String, dynamic> values;
  ThemeType? theme;
  Locale? locale;

  MockSettingsProvider() {
    values = <String, dynamic>{};
    theme = ThemeType.auto;
  }

  @override
  bool? getBool(String key) =>
      values.containsKey(key) ? values[key] as bool? : true;

  @override
  Future<void> setBool(String key, bool? value) async => values[key] = value;

  @override
  int? getInt(String key) => values.containsKey(key) ? values[key] as int? : -1;

  @override
  Future<void> setInt(String key, int value) async => values[key] = value;

  @override
  ThemeType? getTheme() => theme;

  @override
  Future<void> setTheme(ThemeType? t) async => theme = t;

  @override
  Locale? getLocale() => locale;

  @override
  Future<void> setLocale(Locale? l) async => locale = l;
}
