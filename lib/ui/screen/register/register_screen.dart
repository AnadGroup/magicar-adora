//import 'package:anad_magicar/bloc/register/register.dart' as prefix0;
import 'package:anad_magicar/components/RegisterButton.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/ui/screen/register/fancy_register/src/models/login_data.dart';
import 'package:anad_magicar/ui/screen/register/fancy_register_form.dart';

import 'package:anad_magicar/ui/screen/register/register_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anad_magicar/bloc/register/register.dart';
import 'package:anad_magicar/components/RegisterForm.dart';
import 'package:flutter/material.dart';



class RegisterScreen extends StatefulWidget
{

  String mobile;

  RegisterScreen({
    @required this.mobile,
  });

  @override
  _RegisterState createState() {
    return _RegisterState();
  }



}

class _RegisterState extends State<RegisterScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ValueChanged<String> onChanged;
  RegisterBloc registerBloc;

  showSnackLogin(BuildContext context,String message,bool isLoading)
  {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(duration: new Duration(seconds: 5),
          backgroundColor: Colors.amber,
          elevation: 0.8,
          content:
          Container(
            height: 92.0,
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
                new Text(message,style: TextStyle(fontFamily: 'IranSans',fontSize: 20.0),)
              ],
            ),
          ),
        ));
  }

  void registerBus() {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event)  {

      if(event.type=='REGISTER_LOADING')
      {
       // showSnackLogin(context, 'در حال ارسال اطلاعات', true);
      }

      if(event.type=='REGISTER_FAILED')
      {
       // showSnackLogin(context, event.message, false);

      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        key: _scaffoldKey,
      body:
      new Padding(padding: EdgeInsets.only(top: 8.0),
       child:
          new RegisterForm(bloc: registerBloc,mobile: widget.mobile,isEdit: false,),
        ),

    );
  }

  @override
  void initState() {
    super.initState();
    registerBloc=new RegisterBloc();
    registerBus();
  }

  @override
  void dispose() {
    registerBloc.close();
    super.dispose();
  }




}
