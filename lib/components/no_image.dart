
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/translation_strings.dart';


class NoImageAvatar extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {

    return Text(Translations.current.noimage(),
      style: TextStyle(color: Colors.redAccent,fontSize: 10.0),);
  }

}