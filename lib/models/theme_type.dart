/*Prasish*/

import 'package:flutter/cupertino.dart';
import 'package:timetracker/l10n.dart';

enum ThemeType {
  auto,
  light,
  dark,
  black,
  autoMaterialYou,
  lightMaterialYou,
  darkMaterialYou;

  String? get stringify {
    switch (this) {
      case ThemeType.auto:
        return "auto";
      case ThemeType.light:
        return "light";
      case ThemeType.dark:
        return "dark";
      case ThemeType.black:
        return "black";
      case ThemeType.autoMaterialYou:
        return "autoMaterialYou";
      case ThemeType.lightMaterialYou:
        return "lightMaterialYou";
      case ThemeType.darkMaterialYou:
        return "darkMaterialYou";
    }
  }

  String? display(BuildContext context) {
    switch (this) {
      case ThemeType.auto:
        return L10N.of(context).tr.auto;
      case ThemeType.light:
        return L10N.of(context).tr.light;
      case ThemeType.dark:
        return L10N.of(context).tr.dark;
      case ThemeType.black:
        return L10N.of(context).tr.black;
      case ThemeType.autoMaterialYou:
        return L10N.of(context).tr.autoMaterialYou;
      case ThemeType.lightMaterialYou:
        return L10N.of(context).tr.lightMaterialYou;
      case ThemeType.darkMaterialYou:
        return L10N.of(context).tr.darkMaterialYou;
      default:
        return null;
    }
  }

  static ThemeType fromString(String? type) {
    if (type == null) return ThemeType.auto;
    switch (type) {
      case "auto":
        return ThemeType.auto;
      case "light":
        return ThemeType.light;
      case "dark":
        return ThemeType.dark;
      case "black":
        return ThemeType.black;
      case "autoMaterialYou":
        return ThemeType.autoMaterialYou;
      case "lightMaterialYou":
        return ThemeType.lightMaterialYou;
      case "darkMaterialYou":
        return ThemeType.darkMaterialYou;
      default:
        return ThemeType.auto;
    }
  }
}
