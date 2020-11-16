import 'package:anad_magicar/bloc/theme/theme.dart';
import 'package:anad_magicar/bloc/theme/theme_bloc.dart';
import 'package:anad_magicar/components/animstepper/stepper.dart';
import 'package:anad_magicar/components/material_switch.dart';
import 'package:anad_magicar/components/switch_button.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PreferencePage extends StatefulWidget {

  @override
  PreferencePageState createState() {
    return new PreferencePageState();
  }

}
class PreferencePageState extends State<PreferencePage> {
  bool enableCoolStuff = true;
  List<String> themeOptions = <String>[Translations.current.darkTheme(), Translations.current.lightTheme()];
  String selectedThemeOption = Translations.current.lightTheme();
  var itemAppTheme = AppTheme.values[4];
  void _toggle() {
    setState(() {
      enableCoolStuff = !enableCoolStuff;
      selectedThemeOption=themeOptions[enableCoolStuff ? 1 : 0];
      itemAppTheme=AppTheme.values[enableCoolStuff ? 4 : 5];
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: new Padding(
        padding: EdgeInsets.only(top: 100.0),
        child:
      Column(
        children: <Widget> [
        Row(
        mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0,top: 10.0,right: 10.0),
              child: Text(
                Translations.current.appTheme(),
                textScaleFactor: 0.8,
              ),
            ),
        ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(right: 15.0,top: 5.0),
        child: GestureDetector(
          onTap: () {
            _toggle();
            BlocProvider.of<ThemeBloc>(context).add(new ThemeChanged(theme: itemAppTheme));
          },
          behavior: HitTestBehavior.translucent,
          child:
          SwitchlikeCheckbox(checked: enableCoolStuff),
            ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                selectedThemeOption,
                textScaleFactor: 1.3,
              ),
            )
          ],
        ),
        ],
      ),
      ),
    );
  }
}
