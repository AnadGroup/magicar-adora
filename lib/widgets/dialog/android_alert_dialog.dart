import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/widgets/dialog/base_dialog.dart';
import 'package:flutter/material.dart';

class AndroidAlertDialog extends CustomDialog {

  String title;
  String message;

  AndroidAlertDialog({
    @required this.title,
    @required this.message,
  });

  @override
  String getTitle() {
    return title;
  }

  @override
  Widget create(BuildContext context) {
    return AlertDialog(
      title: Text(getTitle()),
      content: Text(getMessage()),
      actions: <Widget>[
        FlatButton(
          child: Text(Translations.current.cancel()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  @override
  String getMessage() {
    // TODO: implement getMessage
    return message;
  }


}
