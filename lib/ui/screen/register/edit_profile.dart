import 'package:anad_magicar/bloc/register/register.dart';
import 'package:anad_magicar/ui/screen/register/register_form.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() {
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ValueChanged<String> onChanged;
  RegisterBloc registerBloc;

  @override
  void initState() {
    super.initState();
    registerBloc=new RegisterBloc();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      key: _scaffoldKey,
      body:
      new Padding(padding: EdgeInsets.only(top: 8.0),
        child:
        new RegisterForm(bloc: registerBloc,mobile: '',isEdit: true,),
      ),
    );
  }
}
