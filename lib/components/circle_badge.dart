import 'package:flutter/material.dart';

class CircleBadge extends StatelessWidget {

  String number;
  CircleBadge({Key key,this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CircleAvatar(
      minRadius: 10.0,
      maxRadius: 10.0,
      backgroundColor: Colors.pinkAccent,
      child:
      new Text(number,style: TextStyle(fontSize: 15.0,color: Colors.white),),);
  }
}
