import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/login/reset/fancy_login/flutter_login.dart';
import 'package:flutter/material.dart';




class ResetPasswordForm extends StatelessWidget {

  ResetPasswordForm({
    @required Function authUser,
    @required Function recoverPassword,
    @required Function onCancel,
    @required Function onSubmit,
  })
      : _authUser = authUser,
        _onCancel= onCancel,
        _recoverPassword = recoverPassword,
        _onSubmit=onSubmit;

  Duration get loginTime => Duration(milliseconds: 2250);

  Function _authUser;
  Function _onCancel;
  Function  _recoverPassword;
  Function _onSubmit;

  @override
  Widget build(BuildContext context) {

    return FlutterLogin(
      title: '',
      messages: new LoginMessages(
        currentPasswordHint: Translations.current.currentPassword(),
          goBackButton: Translations.current.goBack(),
          loginButton: Translations.current.resetPassword(),
          passwordHint: Translations.current.password(),
          signupButton: Translations.current.cancel(),
          usernameHint: Translations.current.userName(),
          firstNameHint: Translations.current.firstName(),
          lastNameHint: Translations.current.lastName(),
          mobileHint: Translations.current.mobile(),
          confirmPasswordHint: Translations.current.reTypePassword(),
          forgotPasswordButton: Translations.current.forgotPassword(),
          recoverPasswordButton: Translations.current.recoverPassword()
      ),
      //mobileValidator: null,

      onConfirm: _authUser,
      onCancel: _onCancel,

      onSubmitAnimationCompleted: _onSubmit,
      onRecoverPassword: _recoverPassword,
    );
  }


}
