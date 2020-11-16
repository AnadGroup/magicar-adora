import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  SkipButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return new Container(
      margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
      width: MediaQuery.of(context).size.width/2.5,
      height: 60.0,
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xffff4081).withAlpha(60),
            blurRadius: 6.0,
            spreadRadius: 0.0,
            offset: Offset(
              0.0,
              3.0,
            ),
          ),
        ],
        color: Colors.pink,
        border: new Border.all(color: Color(0xffff4081),width: 2.0,),
        borderRadius: new BorderRadius.all(const Radius.circular(0.0)),
      ),
      child: new Text(
        Translations.of(context).skip(),
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
