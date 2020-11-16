import 'dart:async';

import 'package:anad_magicar/components/Form.dart';
import 'package:anad_magicar/components/ScrollableController.dart';
import 'package:anad_magicar/components/SignInButton.dart';
import 'package:anad_magicar/components/SignUpLink.dart';
import 'package:anad_magicar/components/WhiteTick.dart';
import 'package:anad_magicar/components/scrollabe_bottom_sheet.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/login/confirm_form.dart';
import 'package:anad_magicar/ui/screen/login/confirm_login.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'loginAnimation.dart';
import 'styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;
  bool _bottomSheetActive = false;
  String _currentState = "initial";
  String _currentDirection = "up";
  final controller = ScrollableController();

  VoidCallback _showBottomSheetCallback;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showMessage(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('You tapped the floating action button.'),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    _showBottomSheetCallback = _showPersistBottomSheet;
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('از خروج مطمئن هستید?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('خیر'),
              ),
              new FlatButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/home"),
                child: new Text('بله'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
            key: _scaffoldKey,
            body: Builder(builder: (BuildContext context) {
              return new Container(
                decoration: new BoxDecoration(
                  image: backgroundImage,
                ),
                child: new Container(
                    decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                      colors: <Color>[
                        const Color.fromRGBO(162, 146, 199, 0.8),
                        const Color.fromRGBO(51, 51, 63, 0.9),
                      ],
                      stops: [0.2, 1.0],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.0, 1.0),
                    )),
                    child: new ListView(
                      padding: const EdgeInsets.all(0.0),
                      children: <Widget>[
                        new Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new Tick(image: tick),
                                new FormContainer(),
                                new SignUp()
                              ],
                            ),
                            animationStatus == 0
                                ? new Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 50.0),
                                    child: new InkWell(
                                        onTap: () {
                                          setState(() {
                                            animationStatus = 1;
                                            _bottomSheetActive =
                                                _bottomSheetActive
                                                    ? false
                                                    : true;
                                          });
                                          //_playAnimation();

                                          _showBottomSheetCallback;
                                          //_showModalBottomSheet(context);
                                        },
                                        child: new SignIn()),
                                  )
                                : new StaggerAnimation(
                                    buttonController:
                                        _loginButtonController.view),
                          ],
                        ),
                      ],
                    )),
              );
            }))));
  }

  Widget _bottomSheetBuilder(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Stack(children: [
      ScrollableBottomSheet(
        controller: controller,
        halfHeight: 250.0,
        minimumHeight: 50.0,
        autoPop: false,
        scrollTo: ScrollState.minimum,
        snapAbove: false,
        snapBelow: false,
        callback: (state) {
          if (state == ScrollState.minimum) {
            _currentState = "minimum";
            _currentDirection = "up";
          } else if (state == ScrollState.half) {
            if (_currentState == "minimum") {
              _currentDirection = "up";
            } else {
              _currentDirection = "down";
            }
            _currentState = "half";
          } else {
            _currentState = "full";
            _currentDirection = "down";
          }
        },
        child: Container(
            color: Colors.greenAccent,
            margin: EdgeInsets.only(bottom: 50.0),
            child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(children: [
                  InkWell(
                    child: Container(color: Colors.red, height: 57.0),
                    onTap: () {
                      controller.animateToZero(context, willPop: true);
                    },
                  ),
                  new ConfirmLogin(),
                  new DoConfirm()
                ]))),
      ),
      Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          height: 50.0,
          child: Material(
            elevation: 15.0,
            child: IconButton(
                icon: Icon(Icons.location_on),
                onPressed: () {
                  if (_currentState == "half") {
                    if (_currentDirection == "up") {
                      controller.animateToFull(context);
                    } else {
                      controller.animateToMinimum(context);
                    }
                  } else {
                    controller.animateToHalf(context);
                  }
                }),
          ))
    ]);
  }

  _showBottomSheet(BuildContext context) {
    showBottomSheet<void>(context: context, builder: _bottomSheetBuilder)
        .closed
        .whenComplete(() {
      if (mounted) {
        setState(() {
          // re-enable the button
          _bottomSheetActive = false;
        });
      }
    });
  }

  _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
            height: 350.0,
            color: Colors.transparent,
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.close),
                    title: new Text('تایید کد دریافتی'),
                    onTap: () => null,
                  ),
                  new ConfirmLogin(),
                  new DoConfirm()
                ],
              ),
            ),
          );
        });
  }

  void _showPersistBottomSheet() {
    setState(() {
      // disable the button
      _showBottomSheetCallback = null;
    });
    _scaffoldKey.currentState
        .showBottomSheet<void>((BuildContext context) {
          final ThemeData themeData = Theme.of(context);
          return new Container(
            height: 350.0,
            color: Colors.transparent,
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.close),
                    title: new Text(Translations.current.confirmrecievecode()),
                    onTap: () => null,
                  ),
                  new ConfirmLogin(),
                  new DoConfirm()
                ],
              ),
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              // re-enable the button
              _showBottomSheetCallback = _showPersistBottomSheet;
            });
          }
        });
  }
}
