/*Prasish*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timetracker/blocs/theme/theme_bloc.dart';
import 'package:timetracker/l10n.dart';
import 'package:timetracker/models/theme_type.dart';

class ThemeOptions extends StatelessWidget {
  final ThemeBloc bloc;
  const ThemeOptions({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
        bloc: bloc,
        builder: (BuildContext context, ThemeState state) {
          return ListTile(
            key: const Key("themeOption"),
            title: Text(L10N.of(context).tr.theme),
            subtitle: Text(state.theme?.display(context) ?? ""),
            trailing: Icon(L10N.of(context).rtl
                ? FontAwesomeIcons.chevronLeft
                : FontAwesomeIcons.chevronRight),
            leading: const Icon(FontAwesomeIcons.palette),
            onTap: () async {
              ThemeType? oldTheme = state.theme;
              ThemeType? newTheme = await showModalBottomSheet<ThemeType>(
                  context: context,
                  builder: (context) => ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          RadioListTile<ThemeType>(
                            key: const Key("themeAuto"),
                            title: Text(L10N.of(context).tr.auto),
                            value: ThemeType.auto,
                            groupValue: state.theme,
                            onChanged: (ThemeType? type) =>
                                Navigator.pop(context, type),
                          ),
                          RadioListTile<ThemeType>(
                            key: const Key("themeLight"),
                            title: Text(L10N.of(context).tr.light),
                            value: ThemeType.light,
                            groupValue: state.theme,
                            onChanged: (ThemeType? type) =>
                                Navigator.pop(context, type),
                          ),
                          RadioListTile<ThemeType>(
                            key: const Key("themeDark"),
                            title: Text(L10N.of(context).tr.dark),
                            value: ThemeType.dark,
                            groupValue: state.theme,
                            onChanged: (ThemeType? type) =>
                                Navigator.pop(context, type),
                          ),
                          RadioListTile<ThemeType>(
                            key: const Key("themeBlack"),
                            title: Text(L10N.of(context).tr.black),
                            value: ThemeType.black,
                            groupValue: state.theme,
                            onChanged: (ThemeType? type) =>
                                Navigator.pop(context, type),
                          ),
                          RadioListTile<ThemeType>(
                            key: const Key("themeAutoMaterialYou"),
                            title: Text(L10N.of(context).tr.autoMaterialYou),
                            value: ThemeType.autoMaterialYou,
                            groupValue: state.theme,
                            onChanged: (ThemeType? type) =>
                                Navigator.pop(context, type),
                          ),
                          RadioListTile<ThemeType>(
                            key: const Key("themeLightMaterialYou"),
                            title: Text(L10N.of(context).tr.lightMaterialYou),
                            value: ThemeType.lightMaterialYou,
                            groupValue: state.theme,
                            onChanged: (ThemeType? type) =>
                                Navigator.pop(context, type),
                          ),
                          RadioListTile<ThemeType>(
                            key: const Key("themeDarkMaterialYou"),
                            title: Text(L10N.of(context).tr.darkMaterialYou),
                            value: ThemeType.darkMaterialYou,
                            groupValue: state.theme,
                            onChanged: (ThemeType? type) =>
                                Navigator.pop(context, type),
                          ),
                        ],
                      ));

              bloc.add(ChangeThemeEvent(newTheme ?? oldTheme));
            },
          );
        });
  }
}
