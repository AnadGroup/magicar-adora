import 'package:anad_magicar/bloc/login/login.dart';
import 'package:anad_magicar/components/card_widget.dart';
import 'package:anad_magicar/components/myprogress_dialog.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/service/local_auth_service.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class LoginScreen extends StatefulWidget {

  final LoginBloc loginBloc;
  final LocalAuthenticationService localAuth;
  final MyProgressDialog myProgressDialog;
  final bool fingerprintSupport;
  final Function() loginFunc;
  final Function() fingerFunc;
  final Function() patternFunc;


  @override
  _LoginScreenState createState() => _LoginScreenState();

  const LoginScreen({
    @required this.loginBloc,
    @required this.localAuth,
    @required this.myProgressDialog,
    @required this.fingerprintSupport,
    this.loginFunc,
    this.fingerFunc,
    this.patternFunc
  });

}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SolidController _solidBottomSheetController = SolidController();

  AnimationController _controller;
  Animation<Offset> pulseAnimation;

  String bottomSheetMessage='';


  /*void registerBus(BuildContext context) {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event)  {

      if(event.type=='LOGIN_FAILED')
      {
        bottomSheetMessage=event.message;
        *//*if(_solidBottomSheetController.isOpened)
          _solidBottomSheetController.hide();
        _solidBottomSheetController.show();
*//*

      }
    });
  }*/

  _buildUsername(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: 45,
        padding: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0.0
              )
            ]
        ),
        child:
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
            border: InputBorder.none,
            icon: Icon(Icons.person_pin,
              color: Colors.blueAccent[100],
            ),
            hintStyle: TextStyle(color: Colors.pinkAccent[100]),
            hintText: Translations.of(context).userName(),
          ),
          onChanged: (value) {
            RxBus.post(new ChangeEvent(message: value,type: 'LOGIN_USERNAME'));
            //this.userName=value;
          },
        ),


      ),
    );
  }

  _buildPassword(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: 45,
        margin: EdgeInsets.only(top: 12),
        padding: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0.0
              )
            ]
        ),
        child:
        TextField(
          textAlign: TextAlign.start ,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
            border: InputBorder.none,
            icon: Icon(Icons.vpn_key,
              color: Colors.blueAccent[100],
            ),
            hintStyle: TextStyle(color: Colors.pinkAccent[100]),
            hintText: Translations.of(context).password(),
          ),
          onChanged: (value) {
            RxBus.post(new ChangeEvent(message: value,type: 'LOGIN_PASSWORD'));
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
   // registerBus(context);
    _controller = AnimationController(vsync: this,duration: Duration(microseconds: 3000));
 // _solidBottomSheetController=new SolidController();
  /*if(_solidBottomSheetController.isOpened)
    _solidBottomSheetController.hide();*/
    pulseAnimation = Tween<Offset>(
      begin: Offset(6, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.6,
          curve: Curves.ease,
        ),
      ),
    );

    _controller.forward();
    //super.initState();
  }


  _showMenu(String message)
  {
    return SolidBottomSheet(
      controller: _solidBottomSheetController,
      draggableBody: true,
      maxHeight: 50.0,
      smoothness: Smoothness.medium,
      canUserSwipe: true,
     // autoSwiped: true,
      //showOnAppear: true,
      headerBar: Container(
        color: Theme.of(context).primaryColor,
        height: 20,
        child: Center(
          child: Text("close me"),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // _controller.isOpened ? _controller.hide() : _controller.show();
        },
        child:
        Container(
          color: Colors.white,
          height: 30,
          child: Center(
            child: Text(
              message,
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
      ),
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent, // navigation bar color// status bar color
      statusBarIconBrightness: Brightness.light, // status bar icons' color
      systemNavigationBarIconBrightness: Brightness.dark, //n
    ),);

    return
      new Stack(
      alignment: Alignment.topCenter,
      overflow: Overflow.visible,
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
     child:
      Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CardWidget(
          fingerprintSupport: widget.fingerprintSupport,
          localAuth: widget.localAuth,
          loginBloc: widget.loginBloc,
          myProgressDialog: widget.myProgressDialog,
          loginButtonFunc:  widget.loginFunc,
          fingerFunc: widget.fingerFunc,
          patternFunc: widget.patternFunc,
          widgets: <Widget>[
            _buildUsername(),
            Divider(),
            _buildPassword(),
          ],
        ),
      ],
      ),
        ),
      ],
    );
  }
}
