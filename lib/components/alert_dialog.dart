
import 'package:flutter/material.dart';

class MyAlertDialog {

  String title;
  String bodyText;
  String negativeText;
  String positiveText;
  VoidCallback positiveCallback;
  MyAlertDialog({
    @required this.title,
    @required this.bodyText,
    @required this.negativeText,
    @required this.positiveText,
    @required this.positiveCallback
  });

  Future<void> showMyDialog(BuildContext context)
  {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(bodyText,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(negativeText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(positiveText),
              onPressed: () {
                positiveCallback();
              },
            ),
          ],
        );
      },
    );
  }


}