import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/login/fancy_login/flutter_login.dart';
import 'package:flutter/material.dart';




class FancyLoginForm extends StatelessWidget {

  FancyLoginForm({
    @required Function authUser,
    @required Function recoverPassword,
    @required Function onSignup,
    @required Function onSubmit,
    this.showUserName,
   // @required bool isSignUp,
  })
      : _authUser = authUser,
      _onSignUp= onSignup,
        _recoverPassword = recoverPassword,
  _onSubmit=onSubmit;

  Duration get loginTime => Duration(milliseconds: 2250);

 Function _authUser;
 Function _onSignUp;
 Function  _recoverPassword;
 Function _onSubmit;
 bool showUserName;
 // bool isSignUp;
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
     // isSignUp: isSignUp,
      showUserName: showUserName,
      title: '',
      messages: new LoginMessages(
        goBackButton: Translations.current.goBack(),
        loginButton: Translations.current.login(),
        passwordHint: Translations.current.password(),
        signupButton: Translations.current.register(),
        usernameHint: Translations.current.userName(),
        firstNameHint: Translations.current.firstName(),
        lastNameHint: Translations.current.lastName(),
        mobileHint: Translations.current.mobile(),
        confirmPasswordHint: Translations.current.reTypePassword(),
        forgotPasswordButton: Translations.current.forgotPassword(),
        recoverPasswordButton: Translations.current.recoverPassword()
      ),

      //mobileValidator: null,
      onLogin: _authUser,
      onSignup: _onSignUp,
      onSubmitAnimationCompleted: _onSubmit,
      onRecoverPassword: _recoverPassword,
    );
  }


}
