import 'package:flutter/material.dart';

class ImageNeonGlow extends StatelessWidget {

  String imageUrl;
  int counter;
  Color color;
  double scale;
  ImageNeonGlow({Key key,this.imageUrl,this.counter,this.color,this.scale=1.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
        key: ValueKey(counter),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    boxShadow: [
    BoxShadow(
    color: color!=null ? color.withOpacity(0.5) :
      color ,//Color(0xFFdd2c00).withAlpha(60),
    blurRadius: 6.0,
    spreadRadius: 1.0,
    offset: Offset(
    2.0,
    3.0,
    ),
    ),
    ]), child: Image.asset(imageUrl,color: color,fit: BoxFit.fill,scale: scale==null ? 1.0 : scale,),
    );
  }
}
