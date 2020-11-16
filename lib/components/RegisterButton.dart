import 'package:flutter/material.dart';
import 'package:anad_magicar/translation_strings.dart';

class SendRegister extends StatelessWidget {
  SendRegister();
  @override
  Widget build(BuildContext context) {
    return new Container(
     // width: 40.0,
      height: 40.0,
      margin: EdgeInsets.symmetric(horizontal: 50.0,vertical: 10.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: const Color(0xff0091ea),
        borderRadius: new BorderRadius.all(const Radius.circular(3.0)),
      ),
      child: new Text(
        Translations.current.send(),
        style: new TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}