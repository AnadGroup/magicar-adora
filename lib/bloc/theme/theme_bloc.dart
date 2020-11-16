import 'dart:async';
import 'package:anad_magicar/bloc/theme/theme.dart';
import 'package:anad_magicar/ui/theme/app_themes.dart';
import 'package:bloc/bloc.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState =>
      ThemeState(themeData: appThemeData[AppTheme.MyBlueLightTheme]);

  @override
  Stream<ThemeState> mapEventToState(
      ThemeEvent event,
      ) async* {
    if (event is ThemeChanged) {
      yield ThemeState(themeData: appThemeData[event.theme]);
    }
  }
}
