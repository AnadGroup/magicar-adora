import 'package:anad_magicar/ui/screen/setting/setting_page.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        return Navigator.pushReplacementNamed(context, "/home");
      },
      child:
      Scaffold(
      /*appBar: AppBar(
      actions: <Widget>[
      new IconButton(
      icon: new Icon(Icons.close, color: Colors.white,),
    onPressed: () {
        Navigator.of(context).pop(false);
    }
    ),
    ],
    ),*/
    body: SettingPage(),

      ),
    );
  }
}
