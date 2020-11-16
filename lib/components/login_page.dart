import 'package:anad_magicar/bloc/base_class/base_widget_state.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anad_magicar/authentication/authentication.dart';
import 'package:anad_magicar/bloc/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';





class LoginPage extends StatefulWidget {
final UserRepository userRepository;

LoginPage({Key key, @required this.userRepository,})
      : assert(userRepository != null),
        super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends BaseState<LoginPage> {// State<LoginPage> {


  @override
  void castStatefulWidget() {
    // ignore: unnecessary_statements
    widget is LoginPage;
  }

  LoginPage get _widget => widget as LoginPage;
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  SharedPreferences prefs;
  UserRepository get _userRepository => _widget.userRepository;
  void registerBus() {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event)  {

      if(event.type=='LOGIN_LOADING')
      {
        //showSnackLogin(context, Translations.current.inLoadingApp(), true);
      }

      if(event.type=='LOGIN_FAILED')
      {
        //showSnackLogin(context, event.message, false);
        //Navigator.of(context).pushReplacementNamed('/loadingscreen');
      }
    });
  }

  _getPrefs() async {
     prefs= await prefRepository.getPrefs();
     if(prefs!=null)
      prefs.setBool('LOGINSTATUS', false);
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
  @override
  void initState() {
    super.initState();
    castStatefulWidget();
    //SystemChrome.setEnabledSystemUIOverlays([]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      statusBarColor:Colors.blueAccent.shade200,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.blueAccent,
      systemNavigationBarDividerColor: Colors.pinkAccent,
      systemNavigationBarIconBrightness: Brightness.light ));



    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      authenticationBloc: _authenticationBloc,
    );

      _getPrefs();
      registerBus();
     // checkConnection();
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        key: _scaffoldKey,
      body:
        new LoginForm(authenticationBloc: _authenticationBloc,loginBloc: _loginBloc,),
      );
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }
}
