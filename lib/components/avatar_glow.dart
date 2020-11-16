import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class MyAvatarGlow extends StatelessWidget {
  Widget child;
  String imageUrl;
  double eRadius;
  double radius;
  bool animation;
  MyAvatarGlow({Key key,this.child,
    this.imageUrl,
  this.eRadius,
  this.radius,
  this.animation}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return  AvatarGlow(
      startDelay: Duration(milliseconds: 300),
      glowColor: Colors.lightGreenAccent,
      endRadius: eRadius,
      duration: Duration(milliseconds: 2000),
      repeat: true,
      showTwoGlows: true,
      repeatPauseDuration: Duration(milliseconds: 100),
      child: Material(
        elevation: 0.0,
        shape: CircleBorder(),
        child: CircleAvatar(
          backgroundColor:Colors.white, //Colors.grey[100] ,
          child: Image.asset(imageUrl,scale: 1.0,),
          radius: radius,
          //shape: BoxShape.circle
        ),
      ),
      shape: BoxShape.circle,
      animate: animation,
      curve: Curves.fastOutSlowIn,
    );
  }
}
