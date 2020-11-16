import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDialog extends StatelessWidget{

  String message;
  MyDialog({this.message});

 _onWillPop(BuildContext ctx) {
  return showDialog(
    context: ctx,
    child:

        new AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: new Text('خیر'),
            ),
            new FlatButton(
              onPressed: () =>
                  SystemNavigator.pop(),
              child: new Text('بله'),
            ),
          ],
        ),
   ) ??
   false;

    }


  @override
  Widget build(BuildContext context) {
    return  _onWillPop(context);
  }
}