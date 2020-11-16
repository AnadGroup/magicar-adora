import 'package:anad_magicar/ui/theme/dark_theme.dart';
import 'package:anad_magicar/ui/theme/theme.dart';
import 'package:flutter/material.dart';

enum AppTheme {
  GreenLight,
  GreenDark,
  BlueLight,
  BlueDark,
  MyBlueLightTheme,
  MyDarkTheme,
  HeaderTheme
}

 const HeaderTextStyle =   TextStyle(fontSize: 18.0,color: Colors.green);
const  ContentTextStyle =   TextStyle(fontSize: 18.0,color: Colors.blueAccent);

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
final appThemeData = {
  AppTheme.GreenLight: ThemeData(
    primarySwatch: white,
    brightness: Brightness.light,
    primaryColor: Colors.green,
    fontFamily: 'IranSans'
  ),
  AppTheme.GreenDark: ThemeData(
      primarySwatch: white,
    brightness: Brightness.dark,
    primaryColor: Colors.green[700],
      fontFamily: 'IranSans'
  ),
  AppTheme.BlueLight: ThemeData(
      primarySwatch: white,
    brightness: Brightness.light,
    primaryColor: Colors.blue,
      fontFamily: 'IranSans'
  ),
  AppTheme.BlueDark: ThemeData(
      primarySwatch: white,
    brightness: Brightness.dark,
    primaryColor: Colors.blue[700],
      fontFamily: 'IranSans'
  ),

  AppTheme.HeaderTheme: ThemeData(
    fontFamily: 'IranSans',
    textTheme: TextTheme(
      title: TextStyle(fontSize: 20.0),
      body1: TextStyle(fontSize: 20.0),
      body2: TextStyle(fontSize: 20.0),
      display1: TextStyle(fontSize: 20.0),
      subtitle: TextStyle(fontSize: 20.0),
    )
  ),
  AppTheme.MyBlueLightTheme: myLightTheme,
  AppTheme.MyDarkTheme: myDarkTheme
};
