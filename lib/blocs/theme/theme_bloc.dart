/*Prasish*/

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timetracker/data_providers/settings/settings_provider.dart';
import 'package:timetracker/models/theme_type.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SettingsProvider settings;
  ThemeBloc(this.settings) : super(const ThemeState(ThemeType.auto)) {
    on<LoadThemeEvent>((event, emit) {
      emit(ThemeState(settings.getTheme()));
    });

    on<ChangeThemeEvent>((event, emit) {
      settings.setTheme(event.theme);
      emit(ThemeState(event.theme));
    });
  }
}
