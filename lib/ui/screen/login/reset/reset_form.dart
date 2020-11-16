import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/ui/screen/login/reset/fancy_login/src/models/login_data.dart';
import 'package:anad_magicar/ui/screen/login/reset/reset_password_form.dart';
import 'package:anad_magicar/ui/screen/setting/security_settings_form.dart';
import 'package:flutter/material.dart';

typedef AuthCallback = Future<String> Function(LoginData data);

class ResetForm extends StatefulWidget {
  // AuthCallback resetFunc;
  ResetForm({
    Key key,
  }) : super(key: key);

  @override
  _ResetFormState createState() {
    return _ResetFormState();
  }
}

class _ResetFormState extends State<ResetForm> {
  Future<String> _resetFunc(LoginData data) async {
    return Future.delayed(Duration(microseconds: 100)).then((_) {
      if (data != null &&
          data.currentPassword != null &&
          data.currentPassword.isNotEmpty &&
          !data.cancel) {
        _doResetPassword(
            data.currentPassword, data.password, data.confrimPassword);
        return null;
      } else {
        _toggle();
        return null;
      }
    });
  }

  _doResetPassword(String cPassword, String nPassword, String fPassword) async {
    RestDatasource restDatasource = RestDatasource();
    try {
      var result =
          await restDatasource.resetPassword(cPassword, nPassword, fPassword);
      if (result != null && result.IsSuccessful) {
        centerRepository.showFancyToast(result.Message, true);
        _toggle();
      } else {
        centerRepository.showFancyToast(result.Message, false);
        _toggle();
      }
    } catch (ex) {
      centerRepository.showFancyToast(ex.toString(), false);
      _toggle();
    }
  }

  _toggle() {
    Navigator.pushReplacementNamed(context, SecuritySettingsFormState.route);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 0.0),
          height: MediaQuery.of(context).size.height * 1,
          child: ResetPasswordForm(
            onCancel: _resetFunc,
            authUser: _resetFunc,
            onSubmit: () {},
            recoverPassword: null,
          ),
        ),
      ],
    );
  }
}
