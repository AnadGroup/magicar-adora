import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final DecorationImage image;
  final String title;
  Header({this.image,this.title});
  @override
  Widget build(BuildContext context) {
    return (new Container(
      width: 250.0,
      height: 80.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        image: image,
      ),
      child: new Text(this.title,style: new TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),),
    ));
  }
}
