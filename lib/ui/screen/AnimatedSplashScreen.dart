import 'dart:async';

import 'package:anad_magicar/authentication/authentication.dart';
import 'package:anad_magicar/components/shimmer/myshimmer.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedSplashScreen extends StatefulWidget {
  AuthenticationBloc _authenticationBloc;

  AnimatedSplashScreen(this._authenticationBloc);

  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  String logoPath = 'assets/images/i7.png';
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    //Navigator.of(context).pushReplacementNamed(Constants.LOGIN_SCREEN);
    widget._authenticationBloc.add(AppStarted());
  }

  @override
  void initState() {
    if(CenterRepository.APP_TYPE_ADORA){
      logoPath = 'assets/images/adora_logo.png';
    } else {
      logoPath = 'assets/images/i7.png';
    }
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CenterRepository.APP_TYPE_ADORA ? Color(0xffffffff) : Color(0xff424242),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 200.0,
                    height: 100.0,
                    child: Shimmer.fromColors(
                      baseColor: Colors.black87,
                      highlightColor: Colors.white,
                      child: Image.asset(logoPath),
                    ),
                  ),
                ],
              ),
            ),

            /* new Center(
            child:
               */ /* new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[*/ /*
                    */ /*new Padding(padding: EdgeInsets.only(bottom: 50.0),
                        child:*/ /*


         // ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [

              AvatarGlow(
              startDelay: Duration(milliseconds: 300),
            glowColor: Colors.indigo,
            endRadius: MediaQuery.of(context).size.width/3.0,
            duration: Duration(milliseconds: 2000),
            repeat: true,
            showTwoGlows: true,
            repeatPauseDuration: Duration(milliseconds: 100),
            child: Material(
              elevation: 0.0,
              shape: CircleBorder(),
              child: CircleAvatar(
                backgroundColor:Colors.white, //Colors.grey[100] ,
                child: Container(
                  width: MediaQuery.of(context).size.width/4.0,
                  height: MediaQuery.of(context).size.width/4.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                        image: AssetImage('assets/images/car_splash.png'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF3F5BFA).withAlpha(90),
                          blurRadius: 6.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                            0.0,
                            3.0,
                          ),
                        ),
                      ]),
                  child:new Text(''),
                  //new Image.asset('assets/images/car_splash.png',fit: BoxFit.cover,),
                ),
                radius: MediaQuery.of(context).size.width/4.0,
                //shape: BoxShape.circle
              ),
            ),
            shape: BoxShape.circle,
            animate: true,
            curve: Curves.fastOutSlowIn,
          ),
            ],
          ),*/
            //],
            //),
            //),
          ],
        ),
      ),
    );
  }
}
