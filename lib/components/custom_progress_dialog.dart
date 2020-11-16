import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:synchronized/synchronized.dart';

class CustomProgressDialog extends StatelessWidget {
  const CustomProgressDialog({
    Key key,
    this.child,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.shape,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to 100 milliseconds.
  final Duration insetAnimationDuration;

  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to [Curves.fastOutSlowIn].
  final Curve insetAnimationCurve;

  /// {@template flutter.material.dialog.shape}
  /// The shape of this dialog's border.
  ///
  /// Defines the dialog's [Material.shape].
  ///
  /// The default shape is a [RoundedRectangleBorder] with a radius of 2.0.
  /// {@endtemplate}
  final ShapeBorder shape;

  Color _getColor(BuildContext context) {
    return Theme.of(context).dialogBackgroundColor;
  }

  static const RoundedRectangleBorder _defaultDialogShape =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)));

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Material(
              elevation: 24.0,
              color: _getColor(context),
              type: MaterialType.card,
              child: child,
              shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressDialog {
  bool isDismissed = true;
  var lock = Lock();
  Timer _timer;
  Future<void> dismissProgressDialog(BuildContext context) async {
    _timer?.cancel();
    await lock.synchronized(() async {
      if (isDismissed != null && isDismissed) {
        return;
      }
      isDismissed = true;
      Navigator.of(context, rootNavigator: true).pop(true);
    });
  }

  void showProgressDialog(BuildContext context,
      {Color barrierColor = const Color(0x55222222),
      String textToBeDisplayed,
      Duration dismissAfter = const Duration(seconds: 5),
      Function onDismiss}) {
    dismissProgressDialog(context).then((_) {
      isDismissed = false;
      showGeneralDialog(
        context: context,
        barrierColor: barrierColor,
        pageBuilder: (context, animation1, animation2) {
          return CustomProgressDialog(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                padding: const EdgeInsets.all(20),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoActivityIndicator(
                          radius: 15,
                        )
                      : CircularProgressIndicator(),
                  textToBeDisplayed == null
                      ? Padding(
                          padding: EdgeInsets.all(0),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            textToBeDisplayed,
                            style: TextStyle(color: Colors.blueAccent),
                            textAlign: TextAlign.center,
                          ))
                ])),
          );
        },
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 100),
      ).then((dismissed) {
        isDismissed = dismissed;
      });
      if (dismissAfter == null) return;
      _timer = Timer(dismissAfter, () {
        dismissProgressDialog(context);
        if (onDismiss != null) onDismiss();
      });
    });
  }
}
