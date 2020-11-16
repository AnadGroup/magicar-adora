import 'package:flutter/material.dart';

abstract class CustomDialog {

  String getTitle();
  String getMessage();
  Widget create(BuildContext context);

  Future<void> show(BuildContext context) async {
    var dialog = create(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _) {
        return dialog;
      },
    );
  }
}
