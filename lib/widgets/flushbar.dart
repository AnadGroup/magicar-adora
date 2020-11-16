import 'package:anad_magicar/components/flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomFlushbar extends StatelessWidget {

  String title;
  String titleText;

  String message;
  String messageText;

  String mainButtonTitle;
  CustomFlushbar({Key key,
  this.title,
  this.titleText,
  this.message,
  this.messageText,
  this.mainButtonTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
      isDismissible: false,
      duration: Duration(seconds: 4),
      icon: Icon(
        Icons.check,
        color: Colors.greenAccent,
      ),
      mainButton: FlatButton(
        onPressed: () {},
        child: Text(
         mainButtonTitle,
          style: TextStyle(color: Colors.amber),
        ),
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.blueGrey,
      titleText: Text(
        titleText,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.yellow[600], fontFamily: "IranSans"),
      ),
      messageText: Text(
        messageText,
        style: TextStyle(fontSize: 18.0, color: Colors.green, fontFamily: "IranSans"),
      ),
    )..show(context);
  }
}
