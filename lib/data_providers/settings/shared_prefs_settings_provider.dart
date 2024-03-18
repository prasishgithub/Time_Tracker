/*Prasish*/

import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetracker/models/theme_type.dart';
import 'settings_provider.dart';

class SharedPrefsSettingsProvider extends SettingsProvider {
  final SharedPreferences _prefs;
  SharedPrefsSettingsProvider(this._prefs);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<void> setBool(String key, bool? value) => (value == null)
      ? _prefs.remove(key)
      : _prefs.setBool(
          key, value); //todo remove null check with null safety implementation

  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  Future<void> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  static Future<SharedPrefsSettingsProvider> load() async {
    return SharedPrefsSettingsProvider(await SharedPreferences.getInstance());
  }

  @override
  ThemeType getTheme() {
    String? t = _prefs.getString("theme");
    return ThemeType.fromString(t);
  }

  @override
  Future<void> setTheme(ThemeType? theme) async {
    if (theme == null) {
      //todo remove null check with null safety implementation
      await _prefs.remove("theme");
    } else {
      await _prefs.setString("theme", theme.stringify!);
    }
  }

  @override
  Locale? getLocale() {
    String? languageCode = _prefs.getString("languageCode");
    if (languageCode == null) {
      return null;
    }
    String? countryCode = _prefs.getString("countryCode");
    return Locale.fromSubtags(
        languageCode: languageCode, countryCode: countryCode);
  }

  @override
  Future<void> setLocale(Locale? locale) async {
    final langCode = locale?.languageCode;
    if (langCode == null) {
      //todo remove null check with null safety implementation
      await _prefs.remove("languageCode");
    } else {
      await _prefs.setString("languageCode", langCode);
    }

    final countryCode = locale?.countryCode;

    if (countryCode == null) {
      //todo remove null check with null safety implementation
      await _prefs.remove("countryCode");
    } else {
      await _prefs.setString("countryCode", countryCode);
    }
  }
}
