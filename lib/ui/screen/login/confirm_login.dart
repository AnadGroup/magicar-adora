import 'package:anad_magicar/components/form_validation.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:flutter/material.dart';



class ConfirmLogin extends StatefulWidget
{

  User user;

  ConfirmLogin({this.user});
  @override
  _ConfirmLoginState createState() {
    return  new _ConfirmLoginState();
  }


}

class _ConfirmLoginState extends State<ConfirmLogin>
{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _confirmBody(context);
  }

  Widget _confirmBody(BuildContext context) {
    return new FormValidation();
  }


}
