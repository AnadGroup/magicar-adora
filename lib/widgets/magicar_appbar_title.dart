import 'package:flutter/material.dart';

class MagicarAppbarTitle extends StatefulWidget {

  Color currentColor;
  Icon actionIcon;
  Image image;
  Function actionFunc;
  Function imageFunc;
  @override
  _MagicarAppbarTitleState createState() {
    return _MagicarAppbarTitleState();
  }

  MagicarAppbarTitle({
    @required this.currentColor,
    @required this.actionIcon,
    this.image,
    this.imageFunc,
    @required this.actionFunc
  });
}

class _MagicarAppbarTitleState extends State<MagicarAppbarTitle> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      alignment: Alignment.centerLeft,
      overflow: Overflow.visible,
      children: <Widget>[


      /*Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[*/
        /*Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[*/
    Align(
    alignment: Alignment(1,0),
    child:
            widget.image!=null ? FlatButton(
              onPressed: (){
                widget.imageFunc();
              },
              child: widget.image,
            ) : Container(width: 0,height: 0,),
    ),
          /*],
        ),*/
   /* Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[*/
   Align(
     alignment: Alignment(1,0),
    child:
      widget.actionIcon!=null ?  IconButton(
          onPressed:() { widget.actionFunc();},
          icon:
            widget.actionIcon//Icon(Icons.settings, color: widget.currentColor, size: 16.0),
        ) :
      Container(width: 0,height: 0,),
   ),
   /* ],
    ),*/
        new Align(child: Container(
        child:
        new Image.asset(
          'assets/images/i26.png',scale: 3.0, color: widget.currentColor,),
          alignment: Alignment(-1,0),),),
     /* ],
    ),*/
    ],
    );
  }
}
