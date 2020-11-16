import 'package:flutter/material.dart';
import 'package:anad_magicar/translation_strings.dart';

class Button extends StatelessWidget {

  final String title;
  double wid;
  int color=0xff3949ab;
  Color clr;
  bool backTransparent;
  bool fixWidth=true;
  Button({this.wid, this.title,this.color,this.clr,this.backTransparent = false,this.fixWidth=true});
  @override
  Widget build(BuildContext context) {
    return  new Padding(
      padding: EdgeInsets.only(right: 0.0,left: 0.0) ,
        child:
      fixWidth ?  new Container(
      width: wid,
      height: 40.0,
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: this.backTransparent ? Colors.transparent : (clr!=null ? clr : Color(this.color)),
        border: new Border.all(width: 0.5,color: color!=null ? Color(this.color) : Colors.blueAccent),
        borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
      ),
      child:  Text(
        this.title,
        textAlign: TextAlign.center,
        style:  TextStyle(

          color: color!=null ? Color(color) : Colors.white,
          fontSize: 12.0,
      
        ),
      ),
        ) :
      new Container(
        //width: MediaQuery.of(context).size.width,
        height: 40.0,
        alignment: FractionalOffset.center,
        decoration: new BoxDecoration(
          color: this.backTransparent ? Colors.transparent : (clr!=null ? clr : Color(this.color)),
          border: new Border.all(width: 0.5,color: color!=null ? Color(this.color) : Colors.blueAccent),
          borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
        ),
        child:  Text(
          this.title,
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: color!=null ? Color(color) : Colors.white,
            fontSize: 12.0,
          
          ),
        ),
      )
    );
  }
}
