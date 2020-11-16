import 'package:anad_magicar/bloc/login/login.dart';
import 'package:anad_magicar/components/animstepper/stepper.dart';
import 'package:anad_magicar/components/myprogress_dialog.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/service/local_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardWidget extends StatelessWidget {
  final List<Widget> widgets;
  //final String buttonName;
  final Function() loginButtonFunc;
  final Function() fingerFunc;
  final Function() patternFunc;
  final LoginBloc loginBloc;
  final LocalAuthenticationService localAuth;
  final MyProgressDialog myProgressDialog;
  final bool fingerprintSupport;
  const CardWidget(
      {Key key,
        @required this.widgets,
        @required this.loginButtonFunc,
        @required this.fingerFunc,
        @required this.patternFunc,
        @required this.loginBloc,
        @required this.myProgressDialog,
        @required this.localAuth,
        @required this.fingerprintSupport,
      })
      : assert(widgets != null),

        super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName='';
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(children: widgets),
          ),
        ),
         new Padding(padding: EdgeInsets.only(top: 130.0) ,
         child:
         new Column(
    //crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center ,
    children: <Widget>[
    /* _buildLogin(),
                    _buildExit(),*/
    Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget> [
    GestureDetector(
    onTap: fingerFunc/*() {
    if(fingerprintSupport)
    localAuth.authenticate();
    }*/,
    child:
    Align(
    alignment: Alignment.center,
    child: Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    boxShadow: [
    BoxShadow(
    color: Color(0xFF263238).withAlpha(60),
    blurRadius: 6.0,
    spreadRadius: 0.0,
    offset: Offset(
    0.0,
    3.0,
    ),
    ),
    ],
    ),
    child:
    Padding(
    padding: EdgeInsets.all( 10.0),
    child:

    Icon(Icons.fingerprint,
    size: 48,
    color: Colors.black45,
    ),
    ),
    ),
    ),
    ),
    GestureDetector(
    onTap:  patternFunc,
    /*if(fingerprintSupport)
    localAuth.authenticate();*/


    child:
    Align(
    alignment: Alignment.center,
    child:Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    boxShadow: [
    BoxShadow(
    color: Color(0xFF263238).withAlpha(60),
    blurRadius: 6.0,
    spreadRadius: 0.0,
    offset: Offset(
    0.0,
    3.0,
    ),
    ),
    ],
    ),
    child:
    Padding(
    padding: EdgeInsets.all( 10.0),
    child:
    Icon(Icons.touch_app,
    size: 48,
    color: Colors.black45,
    ),
    ),
    ),
    ),
    ),
    ],
    ),
    new Container(
    width:MediaQuery.of(context).size.width/2.0,
    height: 68.0,
    margin: EdgeInsets.only(bottom: 5.0,top:10.0),
    child:
    StepperTouch(
    initialValue: 1,
    direction: Axis.horizontal,
    withSpring: true,
    showIcon: false,
    leftImage: 'assets/images/logout.png',
    rightImage: 'assets/images/login.png',
    leftTitle: 'خروج',
    rightTitle: 'ورود',
    onChanged: (int value)  {
    if(value ==1 )
    {
      RxBus.post(new ChangeEvent(message: 'LOGIN_CLICKED',type: 'LOGIN'));
    //loginBloc.dispatch(new LoginButtonPressed(username: userName,password: ''));
    //myProgressDialog.showProgressDialog();*/

    //isLoginDisabled=true;
    }
    else
    {
    SystemNavigator.pop();
    }
    },
    ),
    ),
    ],
          ),
         ),
      ],
    );
  }
}