/*Prasish*/

part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeType? theme;
  const ThemeState(this.theme);
  @override
  List<Object?> get props => [theme];
}
