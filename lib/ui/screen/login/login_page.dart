import 'package:anad_magicar/authentication/authentication.dart';
import 'package:anad_magicar/bloc/login/login.dart';
import 'package:anad_magicar/components/fancy_popup/main.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/firebase/message/firebase_message_handler.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/login/login_form.dart';
import 'package:anad_magicar/widgets/flash_bar/flash.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final UserRepository userRepository;
  final LoginType loginType;
  final bool showUserName;
  FireBaseMessageHandler messageHandler;
  GlobalKey<NavigatorState> navigatorKey;

  LoginPage(
      {Key key,
      @required this.userRepository,
      @required this.navigatorKey,
      this.showUserName,
      this.loginType,
      this.messageHandler})
      : assert(userRepository != null),
        super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Animation<Offset> pulseAnimation;
  AnimationController formAnimationController;
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  String securityCode = '';
  SharedPreferences prefs;
  UserRepository get _userRepository => widget.userRepository;

  void _showBasicsFlash({
    String title,
    String message,
    Duration duration,
    flashStyle = FlashStyle.floating,
  }) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          style: flashStyle,

          // boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          backgroundColor: Colors.redAccent,
          brightness: Brightness.light,
          boxShadows: [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          //style: style,
          position: FlashPosition.top,
          child: FlashBar(
            title: Text(
              title,
              style: TextStyle(color: Colors.amberAccent),
            ),
            message: Text(message, style: TextStyle(color: Colors.amberAccent)),
            showProgressIndicator: true,
            // primaryAction: FlatButton(
            //   onPressed: () => controller.dismiss(),
            //   child: Text(Translations.current.close(),
            //       style: TextStyle(color: Colors.amber)),
            // ),
          ),
        );
      },
    );
  }

  void registerBus() {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event) {
      if (event.type == 'LOGIN_LOADING') {}

      if (event.type == 'LOGIN_FAILED') {
        _showBasicsFlash(
            duration: Duration(seconds:2),
            title: Translations.current.hasErrors(),
          
             message: event.message);
      }
      if (event.type == 'LOGIN_NOCONNECTION') {
        centerRepository.showFancyToast(
            Translations.current.noConnection(), false);
      }
      if (event.type == 'SIGNUP_DONE') {
        //this.securityCode=event.message;
        showConfrimSecurityCodePopUp(event.message);
      }
      if (event.type == 'SIGNUP_FAILD') {
        //this.securityCode=event.message;
        //centerRepository.showFancyToast( event.message);
        FlashHelper.errorBar(context, message: event.message,);
      }
    });
  }

  _buildSecurityCode() {
    return SlideTransition(
      position: pulseAnimation,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        height: 45,
        padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.blueAccent[100],
                style: BorderStyle.solid,
                width: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.transparent, blurRadius: 0.0)]),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
              top: 4.0,
              bottom: 0.0,
            ),
            border: InputBorder.none,
            icon: Icon(
              Icons.security,
              color: Colors.blueAccent[100],
            ),
            hintStyle: TextStyle(color: Colors.pinkAccent[100]),
            hintText: Translations.of(context).pleaseEnterSecurityCode(),
          ),
          onChanged: (value) {
            this.securityCode = value;
          },
        ),
      ),
    );
  }

  _buildConfirmSecurityCode(String code) {
    return SlideTransition(
        position: pulseAnimation,
        child: Container(
          margin: EdgeInsets.only(bottom: 2.0, left: 5.0, right: 5.0),
          height: 38,
          width: MediaQuery.of(context).size.width / 3.0,
          decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF76ff03).withAlpha(60),
                  blurRadius: 6.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                    0.0,
                    3.0,
                  ),
                ),
              ],
              border: Border.all(
                  color: Colors.blueAccent[100],
                  style: BorderStyle.solid,
                  width: 0.5),
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.transparent],
              ),
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          child: Center(
            child: RaisedButton(
              onPressed: () {
                if (code != null && code.isNotEmpty) {
                  if (code == securityCode) {
                    Navigator.of(context).pushReplacementNamed('/register');
                  } else {
                    centerRepository.showFancyToast(
                        Translations.current.notValidSecurityCode(), false);
                  }
                }
              },
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              child: Text(Translations.of(context).confirmrecievecode(),
                  style: TextStyle(color: Colors.blueAccent)),
              color: Colors.transparent,
            ),
          ),
        ));
  }

  showConfrimSecurityCodePopUp(String recCode) {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateAuthentication,
    );
    popup.show(
      title: Translations.current.confirmrecievecode(),
      content: Translations.current.plzEnterRecievedSecurityCode(),
      actions: [
        new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 100.0,
              child: _buildSecurityCode(),
            ),
            //_buildConfirmSecurityCode(recCode),
            //_buildReSendSecurityCode(mobile),
            popup.button(
              label: Translations.current.confirmrecievecode(),
              onPressed: () {
                if (recCode != null && recCode.isNotEmpty) {
                  if (recCode == securityCode) {
                    Navigator.of(context).pushReplacementNamed('/register');
                  } else {
                    centerRepository.showFancyToast(
                        Translations.current.notValidSecurityCode(), false);
                  }
                }
              },
            ),
            popup.button(
              label: Translations.current.resendSecurityCode(),
              onPressed: () {
                // _loginBloc.dispatch(new ReSignUpButtonPressed(mobile: mobile ));
              },
            ),
            popup.button(
              label: Translations.current.cancel(),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        )
      ],
// bool barrierDismissible = false,
// Widget close,
    );
    return popup;
  }

  showPopUp(String message) {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateNotification,
    );
    popup.show(
      title: Translations.current.errorFetchData(),
      content: message,
      actions: [
        popup.button(
          label: Translations.current.exit(),
          onPressed: Navigator.of(context).pop,
        ),
      ],
// bool barrierDismissible = false,
// Widget close,
    );
  }

  _getPrefs() async {
    prefs = await prefRepository.getPrefs();
    if (prefs != null) prefs.setBool('LOGINSTATUS', false);
  }

  showSnackLogin(BuildContext context, String message, bool isLoading) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: new Duration(seconds: 6),
      backgroundColor: Colors.amber,
      elevation: 0.8,
      content: Container(
        height: MediaQuery.of(context).size.height / 4.3,
        child: new Column(
          children: <Widget>[
            isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        new CircularProgressIndicator(),
                        // new Text(message,style: TextStyle(fontFamily: 'IranSans',fontSize: 20.0),)
                      ])
                : new Icon(
                    Icons.error_outline,
                    color: Colors.black,
                  ),
            Expanded(
              child: new Text(
                message,
                style: TextStyle(fontFamily: 'IranSans', fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    // castStatefulWidget();
    //SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.blueAccent,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor:
            Colors.blueAccent, // navigation bar color// status bar color
        statusBarIconBrightness: Brightness.light, // status bar icons' color
        systemNavigationBarIconBrightness: Brightness.dark, //n
      ),
    );

    formAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    pulseAnimation = Tween<Offset>(
      begin: Offset(6, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: formAnimationController,
        curve: Interval(
          0.0,
          0.6,
          curve: Curves.ease,
        ),
      ),
    );
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      authenticationBloc: _authenticationBloc,
    );

    _getPrefs();
    registerBus();
    //checkConnection();

    formAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: LoginForm(
        authenticationBloc: _authenticationBloc,
        showUserName: widget.showUserName,
        loginBloc: _loginBloc,
        messageHandler: widget.messageHandler,
        navigatorKey: widget.navigatorKey,
        loginType: widget.loginType,
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.close();
    FlashHelper.dispose();
    super.dispose();
  }
}
