import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/register/fancy_register/flutter_login.dart';
import 'package:flutter/material.dart';




class FancyRegisterForm extends StatelessWidget {

  FancyRegisterForm({
    @required Function authUser,
    @required Function recoverPassword,
    @required Function onSubmit,
    this.mobile,
    this.isEdit
  })
      : _authUser = authUser,
        _recoverPassword = recoverPassword,
        _onSubmit=onSubmit;

  Duration get loginTime => Duration(milliseconds: 2250);

  bool isEdit;
  Function _authUser;
  Function  _recoverPassword;
  Function _onSubmit;
  String mobile;
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      isEdit: isEdit,
      mobile: mobile,
      title: '',
      messages: new LoginMessages(
          goBackButton: Translations.current.goBack(),
          loginButton: Translations.current.cancel(),
          passwordHint: Translations.current.password(),
          signupButton: Translations.current.register(),
          usernameHint: Translations.current.userName(),
          firstNameHint: Translations.current.firstName(),
          lastNameHint: Translations.current.lastName(),
          mobileHint: Translations.current.mobile(),
          editButton: Translations.current.sendChanges(),
          confirmPasswordError: Translations.current.confirmPasswordError(),
          confirmPasswordHint: Translations.current.reTypePassword(),
          forgotPasswordButton: Translations.current.forgotPassword(),
          recoverPasswordButton: Translations.current.recoverPassword()
      ),
      mobileValidator: null,
      onLogin: _authUser,
      onSignup: _authUser,
      onSubmitAnimationCompleted: _onSubmit,
      onRecoverPassword: _recoverPassword,
    );
  }


}
