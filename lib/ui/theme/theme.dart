  import 'package:anad_magicar/repository/center_repository.dart';
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


 
  final ThemeData myLightTheme = ThemeData(

    primarySwatch: MaterialColor(0xFFFFFFFF,{50: Color( 0xfff2f2f2 )
      , 100: Color( 0xffe6e6e6 )
      , 200: Color( 0xffcccccc )
      , 300: Color( 0xffb3b3b3 )
      , 400: Color( 0xff999999 )
      , 500: Color( 0xff808080 )
      , 600: Color( 0xff666666 )
      , 700: Color( 0xff4d4d4d )
      , 800: Color( 0xff333333 )
      , 900: Color( 0xff191919 )
    }),
    brightness: Brightness.light,
    primaryColor:  CenterRepository.APP_TYPE_ADORA ? Colors.deepOrange : Color( 0xff2196f3 ),
    primaryColorBrightness: Brightness.dark,
    primaryColorLight: Color( 0xffbbdefb ),
    primaryColorDark:CenterRepository.APP_TYPE_ADORA ? Colors.deepOrange : Color( 0xff1976d2 ),
    accentColor:CenterRepository.APP_TYPE_ADORA ? Colors.deepOrange : Color( 0xff2196f3 ),
    accentColorBrightness: Brightness.dark,
    canvasColor: Color( 0xfffafafa ),
    scaffoldBackgroundColor: Color( 0xfffafafa ),
    bottomAppBarColor: Color( 0xffffffff ),
    cardColor: Color( 0xffffffff ),
    dividerColor: Color( 0x1f000000 ),
    highlightColor: Color( 0x66bcbcbc ),
    splashColor: Color( 0x66c8c8c8 ),
    selectedRowColor: Color( 0xfff5f5f5 ),
    unselectedWidgetColor: Color( 0x8a000000 ),
    disabledColor: Color( 0x61000000 ),
    buttonColor: Color( 0xffe0e0e0 ),
    toggleableActiveColor: Color( 0xff1e88e5 ),
    secondaryHeaderColor: Color( 0xffe3f2fd ),
    textSelectionColor: Color( 0xff90caf9 ),
    cursorColor: Color( 0xff4285f4 ),
    textSelectionHandleColor: Color( 0xff64b5f6 ),
    backgroundColor: Color( 0xff90caf9 ),
    dialogBackgroundColor: Color( 0xffffffff ),
    indicatorColor: Color( 0xff2196f3 ),
    hintColor: Color( 0x8a000000 ),
    errorColor: Color( 0xffd32f2f ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0.0
    ),
    cardTheme: CardTheme(
      elevation: 0.0,
    ),
    fontFamily: 'IranSans',
    snackBarTheme: SnackBarThemeData(
      elevation: 0.0,
      backgroundColor: Colors.pinkAccent,
      actionTextColor: Colors.white,
      contentTextStyle: TextStyle(fontFamily: 'IranSans',fontSize: 18.0,color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.normal,
      minWidth: 88,
      height: 36,
      padding: EdgeInsets.only(top:0,bottom:0,left:16, right:16),
      shape:     RoundedRectangleBorder(
      side: BorderSide(color: Color( 0xff000000 ), width: 0, style: BorderStyle.none, ),
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
      alignedDropdown: false ,
      buttonColor: Color( 0xffe0e0e0 ),
      disabledColor: Color( 0x61000000 ),
      highlightColor: Color( 0x29000000 ),
      splashColor: Color( 0x1f000000 ),
      focusColor: Color( 0x1f000000 ),
      hoverColor: Color( 0x0a000000 ),
      colorScheme: ColorScheme(
        primary: CenterRepository.APP_TYPE_ADORA ? Colors.deepOrange : Color( 0xff2196f3 ),
        primaryVariant: CenterRepository.APP_TYPE_ADORA ? Colors.deepOrange : Color( 0xff1976d2 ),
        secondary:CenterRepository.APP_TYPE_ADORA ? Colors.deepOrange : Color( 0xff2196f3 ),
        secondaryVariant: Color( 0xff1976d2 ),
        surface: Color( 0xffffffff ),
        background: Color( 0xff90caf9 ),
        error: Color( 0xffd32f2f ),
        onPrimary: Color( 0xffffffff ),
        onSecondary: Color( 0xffffffff ),
        onSurface: Color( 0xff000000 ),
        onBackground: Color( 0xffffffff ),
        onError: Color( 0xffffffff ),
        brightness: Brightness.light,
      ),
    ),
    textTheme: TextTheme(
      display4: TextStyle(
      color: Color( 0x8a000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      display3: TextStyle(
      color: Color( 0x8a000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      display2: TextStyle(
      color: Color( 0x8a000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      display1: TextStyle(
      color: Color( 0x8a000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      headline: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      title: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      subhead: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      body2: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      body1: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      caption: TextStyle(
      color: Color( 0x8a000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      button: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      subtitle: TextStyle(
      color: Color( 0xff000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      overline: TextStyle(
      color: Color( 0xff000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    ),
    primaryTextTheme: TextTheme(
      display4: TextStyle(
      color: Color( 0xb3ffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      display3: TextStyle(
      color: Color( 0xb3ffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      display2: TextStyle(
      color: Color( 0xb3ffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      display1: TextStyle(
      color: Color( 0xb3ffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      headline: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      title: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      subhead: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      body2: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      body1: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      caption: TextStyle(
      color: Color( 0xb3ffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      button: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      subtitle: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      overline: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    ),
    accentTextTheme: TextTheme(
      display4: TextStyle(
      color: Color( 0xb3ffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      display3: TextStyle(
      color: Color( 0xb3ffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      display2: TextStyle(
      color: Color( 0xb3ffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      display1: TextStyle(
      color: Color( 0xb3ffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      headline: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      title: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      subhead: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      body2: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      body1: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      caption: TextStyle(
      color: Color( 0xb3ffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      button: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      subtitle: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      overline: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    ),
    inputDecorationTheme:   InputDecorationTheme(
    labelStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    helperStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    hintStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    errorStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    hasFloatingPlaceholder: true,
    isDense: false,
    contentPadding: EdgeInsets.only(top:12,bottom:12,left:0, right:0),
    isCollapsed : false,
    prefixStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    suffixStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    counterStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    filled: false,
    fillColor: Color( 0x00000000 ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color( 0xff000000 ), width: 1, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color( 0xff000000 ), width: 1, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color( 0xff000000 ), width: 1, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color( 0xff000000 ), width: 1, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color( 0xff000000 ), width: 1, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Color( 0xff000000 ), width: 1, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  ),
    iconTheme: IconThemeData(
      color: Color( 0xdd000000 ),
      opacity: 1,
      size: 24,
    ),
    primaryIconTheme: IconThemeData(
      color: Color( 0xffffffff ),
      opacity: 1,
      size: 24,
    ),
    accentIconTheme: IconThemeData(
      color: Color( 0xffffffff ),
      opacity: 1,
      size: 24,
    ),

    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Color( 0xffffffff ),
      unselectedLabelColor: Color( 0xb2ffffff ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Color( 0x1f000000 ),
      brightness: Brightness.light,
      deleteIconColor: Color( 0xde000000 ),
      disabledColor: Color( 0x0c000000 ),
      labelPadding: EdgeInsets.only(top:0,bottom:0,left:8, right:8),
      labelStyle: TextStyle(
      color: Color( 0xde000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
        fontFamily: 'IranSans'
    ),
      padding: EdgeInsets.only(top:4,bottom:4,left:4, right:4),
      secondaryLabelStyle: TextStyle(
      color: Color( 0x3d000000 ),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
      secondarySelectedColor: Color( 0x3d2196f3 ),
      selectedColor: Color( 0x3d000000 ),
      shape: StadiumBorder( side: BorderSide(color: Color( 0xff000000 ), width: 0, style: BorderStyle.none, ) ),
    ),
    dialogTheme: DialogTheme(
      shape:     BeveledRectangleBorder(
      side: BorderSide(color: Color( 0xff000000 ), width: 0, style: BorderStyle.none, ),
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
    )

    ),
  );
