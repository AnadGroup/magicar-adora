import 'package:anad_magicar/bloc/device/register.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/fancy_popup/main.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/noty_loading_vm.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/device/add_device_form.dart';
import 'package:anad_magicar/widgets/flutter_offline/flutter_offline.dart';
import 'package:anad_magicar/widgets/forms_appbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anad_magicar/bloc/register/register.dart';
import 'package:anad_magicar/components/RegisterForm.dart';
import 'package:flutter/material.dart';



class RegisterDeviceScreen extends StatefulWidget
{
  bool hasConnection;
  bool fromMainApp;
  int userId;
  NotyBloc<Message> changeFormNotyBloc;
  @override
  _RegisterDeviceState createState() {
    return _RegisterDeviceState();
  }

  RegisterDeviceScreen({
    @required this.hasConnection,
    @required this.fromMainApp,
    @required this.userId,
    @required this.changeFormNotyBloc
  });

}

class _RegisterDeviceState extends State<RegisterDeviceScreen>
{

  bool hasInternet=false;
  ValueChanged<String> onChanged;
  NotyBloc<NotyLoadingVM> _notyBloc;

  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        body: Stack(
            overflow: Overflow.visible,
            children: <Widget>[

        /*BlocProvider<RegisterDeviceBloc>(
          create: (context) => RegisterDeviceBloc(),
          child:*/ new AddDeviceForm(hasConnection: true,
            fromMainApp: widget.fromMainApp,
            userId: widget.userId,
            changeFormNotyBloc: widget.changeFormNotyBloc,),
       // ),
       // ),
              FormsAppBar( actionIcon: Icon(Icons.directions_car),loadingNoty: _notyBloc,
              onBackPress:null),// widget.fromMainApp!=null && widget.fromMainApp ? Navigator.of(context).pop(false) : Navigator.pushReplacementNamed(context, '/login') ,)
    ],
        ),
        );

  }


  @override
  void initState() {
    super.initState();
    _notyBloc=new NotyBloc<NotyLoadingVM>();
    hasInternet=widget.hasConnection;
  }

  @override
  void dispose() {
    _notyBloc.dispose();
    super.dispose();
  }




}
