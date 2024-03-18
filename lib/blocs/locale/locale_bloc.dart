/*Prasish*/

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:timetracker/data_providers/settings/settings_provider.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final SettingsProvider settings;
  LocaleBloc(this.settings) : super(const LocaleState(null)) {
    on<LoadLocaleEvent>((event, emit) {
      emit(LocaleState(settings.getLocale()));
    });
    on<ChangeLocaleEvent>((event, emit) {
      settings.setLocale(event.locale);
      emit(LocaleState(event.locale));
    });
  }
}
