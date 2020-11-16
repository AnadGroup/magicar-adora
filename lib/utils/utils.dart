import 'package:anad_magicar/model/AppLocal.dart';
import 'package:anad_magicar/ui/theme/dark_theme.dart';
import 'package:anad_magicar/ui/theme/theme.dart';
import 'package:flutter/material.dart';

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

final ThemeData kLightTheme = _buildLightTheme();

ThemeData _buildLightTheme() {
  final ThemeData base = myLightTheme; //ThemeData.light();
  return base;
  /*.copyWith(

      );*/
}

final ThemeData kDarkTheme = _buildDarkTheme();

ThemeData _buildDarkTheme() {
  final ThemeData base = myDarkTheme; //ThemeData.dark();
  return base;
}

final Locale persianLocal = _buildPersianLocal();

Locale _buildPersianLocal() {
  final Locale base = appPeriasnLocalData; //ThemeData.light();
  return base;
  /*.copyWith(

      );*/
}

final Locale englishLocal = _buildEnglishLocal();

Locale _buildEnglishLocal() {
  final Locale base = appEnglishLocalData; //ThemeData.dark();
  return base;
}
