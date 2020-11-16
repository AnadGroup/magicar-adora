import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/login/register/flutter_register.dart';
import 'package:flutter/material.dart';


const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class FancyRegisterForm extends StatelessWidget {

  FancyRegisterForm({
    @required Function authUser,
    @required Function recoverPassword,
    @required Function onSignup,
    @required Function onSubmit,
    @required bool isSignUp,
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
  bool isSignUp;
  @override
  Widget build(BuildContext context) {
    return FlutterRegister(
      isSignUp: isSignUp,
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
