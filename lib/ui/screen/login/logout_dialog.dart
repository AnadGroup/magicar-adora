import 'package:anad_magicar/components/logout_form.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:flutter/material.dart';




class LogoutDialog extends StatefulWidget
{

  User user;

  LogoutDialog({this.user});
  @override
  LogoutDialogState createState() {

    return  new LogoutDialogState();
  }


}

class LogoutDialogState extends State<LogoutDialog>
{


  static final route='/logout';

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

     body: _confirmBody(context),
    );
  }

  Widget _confirmBody(BuildContext context) {


    return new LogoutForm(user: widget.user);
  }


}
