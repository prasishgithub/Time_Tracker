/*Prasish*/

import 'package:flutter/material.dart';

class RowSeparator extends StatelessWidget {
  const RowSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 32,
      width: 1,
      color: Theme.of(context).colorScheme.onBackground.withAlpha(31),
    );
  }
}
