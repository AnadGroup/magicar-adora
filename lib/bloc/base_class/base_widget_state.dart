import 'dart:async';
import 'dart:io';
import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:connectivity/connectivity.dart';


/// a base class for any statful widget for checking internet connectivity
abstract class BaseState<T extends StatefulWidget> extends State<T> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void castStatefulWidget();

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  /// the internet connectivity status
  bool isOnline = true;

  /// initialize connectivity checking
  /// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    await _updateConnectionStatus().then((bool isConnected) => setState(() {
      isOnline = isConnected;
    }));
  }




  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await _updateConnectionStatus().then((bool isConnected) => setState(() {
        isOnline = isConnected;
      }));
    });

   // checkConnection();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<bool> _updateConnectionStatus() async {
    bool isConnected;
    try {
      final List<InternetAddress> result =
      await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    return isConnected;
  }


  showSnackLogin(BuildContext context,String message,bool isLoading)
  {

    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar( duration: new Duration(seconds: 6),
          backgroundColor: Colors.amber,
          elevation: 0.8,
          content:
          Container(
            height: MediaQuery.of(context).size.height/3.5,
            child:
            new Column(

              children: <Widget>[
                isLoading ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CircularProgressIndicator() ,
                      // new Text(message,style: TextStyle(fontFamily: 'IranSans',fontSize: 20.0),)
                    ]) :
                new Icon(Icons.error_outline,color: Colors.black,),
                Expanded(
                  child:
                  new Text(message,style: TextStyle(fontFamily: 'IranSans',fontSize: 20.0),),),
              ],
            ),
          ),
        ));
  }

  checkConnection()
  {
    if(!isOnline)
    {
     // showSnackLogin(context, Translations.current.noConnection(), false);
    }
  }
}
