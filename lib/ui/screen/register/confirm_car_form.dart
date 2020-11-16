import 'package:anad_magicar/components/add_car_button.dart';
import 'package:anad_magicar/components/skip_button.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/material.dart';

class ConfirmCarForm extends StatefulWidget {
  ConfirmCarForm({Key key}) : super(key: key);

  @override
  _ConfirmCarFormState createState() {
    return _ConfirmCarFormState();
  }
}

class _ConfirmCarFormState extends State<ConfirmCarForm> {


  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text(Translations.current.areYouSureToExit()),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(Translations.current.no()),
          ),
          new FlatButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, "/login"),
            child: new Text(Translations.current.yes()),
          ),
        ],
      ),
    ) ??
        false;
  }

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

    return new Container(
      //height: 250.0,
      color: Colors.white,//Color(0xffb2dfdb),
      child: new Container(
        decoration: new BoxDecoration(
            color: Color(0xffb2dfdb),
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child:
        new Column(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(leading: new Container(
              width:48.0,
              height: 48.0,
        child:
            new Image.asset('assets/images/close.png'),),
              title: new Text(Translations.current.addCarFormTitle()),
              onTap: () {
              _onWillPop();
              },
            ),
            GestureDetector(
              onTap: () {onAddCarTap();},
              child:
              new AddCarButton(),
            ),
            new GestureDetector(
              onTap: () {onSkipTap();},
              child:
              new SkipButton(),
            ),
          ],
        ),
      ),
    );
  }



  onAddCarTap()
  {
    Navigator.of(context).pushReplacementNamed('/addcar');
  }

  onSkipTap()
  {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}