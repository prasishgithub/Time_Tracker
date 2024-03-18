/*Prasish*/

import 'package:flutter/material.dart';

class ResponsivenessUtils {
  static const _widescreenBreakpoint = 960;

  static bool isWidescreen(BuildContext context) =>
      MediaQuery.of(context).size.width > _widescreenBreakpoint;
}
