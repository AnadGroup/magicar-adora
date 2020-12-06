import 'package:flutter/material.dart';
import 'package:anad_magicar/bloc/local/change_local_bloc.dart';
import 'package:anad_magicar/components/animstepper/stepper.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('زبان ها')),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: 32, right: MediaQuery.of(context).size.width * 0.55),
              child: Container(
                width: 100.0,
                height: 48.0,
                child: StepperTouch(
                  initialValue: 1,
                  direction: Axis.horizontal,
                  withSpring: false,
                  showIcon: false,
                  leftImage: 'assets/images/english.png',
                  rightImage: 'assets/images/iran.png',
                  leftTitle: 'En',
                  rightTitle: 'Fa',
                  onChanged: (int value) {
                    if (value == 1) {
                      changeLocalBloc.onPersianLocalChange();
                      Translations.load(Locale('fa', 'IR'));
                    } else {
                      changeLocalBloc.onEnglishLocalChange();
                      Translations.load(Locale('en', 'US'));
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
