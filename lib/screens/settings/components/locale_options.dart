/*Prasish*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timetracker/blocs/locale/locale_bloc.dart';
import 'package:timetracker/l10n.dart';

class LocaleOptions extends StatelessWidget {
  final LocaleBloc bloc;
  const LocaleOptions({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
        bloc: bloc,
        builder: (BuildContext context, LocaleState state) {
          return ListTile(
            title: Text(L10N.of(context).tr.language),
            subtitle: Text(L10N.of(context).tr.automaticLanguage),
            trailing: Icon(L10N.of(context).rtl
                ? FontAwesomeIcons.chevronLeft
                : FontAwesomeIcons.chevronRight),
            leading: const Icon(FontAwesomeIcons.language),
            onTap: () async {
              Locale? newLocale = await showModalBottomSheet<Locale>(
                  context: context,
                  builder: (context) => ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          RadioListTile<Locale?>(
                            title: Text(L10N.of(context).tr.automaticLanguage),
                            value: null,
                            groupValue: state.locale,
                            onChanged: (Locale? type) {
                              bloc.add(ChangeLocaleEvent(type));
                              Navigator.pop(context, type);
                            },
                          ),
                        ]
                            .followedBy([
                              const Locale('ar'),
                              const Locale('cs'),
                              const Locale('da'),
                              const Locale('de'),
                              const Locale('en'),
                              const Locale('es'),
                              const Locale('fr'),
                              const Locale('hi'),
                              const Locale('id'),
                              const Locale('it'),
                              const Locale('ja'),
                              const Locale('ko'),
                              const Locale('nb', 'NO'),
                              const Locale('pt'),
                              const Locale('ru'),
                              const Locale('tr'),
                              const Locale('zh', 'CN'),
                              const Locale('zh', 'TW'),
                            ].map(
                              (l) => RadioListTile<Locale>(
                                title: Text(L10N.of(context).tr.langName(l)),
                                value: l,
                                groupValue: state.locale,
                                onChanged: (Locale? type) {
                                  bloc.add(ChangeLocaleEvent(type));
                                  Navigator.pop(context, type);
                                },
                              ),
                            ))
                            .toList(),
                      ));

              bloc.add(ChangeLocaleEvent(newLocale));
            },
          );
        });
  }
}
