import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/widgets/dialog/base_dialog.dart';
import 'package:flutter/cupertino.dart';

class IosAlertDialog extends CustomDialog {

  String title;
  String message;
  IosAlertDialog({
    @required this.title,
    @required this.message,
  });

  @override
  String getTitle() {
    return title;
  }

  @override
  Widget create(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(getTitle()),
      content: Text(getMessage()),
      actions: <Widget>[
        CupertinoButton(
          child: Text(Translations.current.cancel()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  String getMessage() {
    // TODO: implement getMessage
    return message;
  }


}
