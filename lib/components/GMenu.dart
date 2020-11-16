import 'package:flutter/material.dart';
import 'package:anad_magicar/translation_strings.dart';
class GMenu extends StatefulWidget {
  @override
  _GMenuState createState() => _GMenuState();
}
class _GMenuState extends State<GMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 15
            )
          ]
      ),
      child: IconButton(icon:new Icon( Icons.arrow_forward),iconSize: 36.0,color: Colors.redAccent,onPressed: () {
        Navigator.of(context).pushNamed('/home');
      },)
    );
  }
}