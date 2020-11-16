import 'package:flutter/material.dart';

import '../models/login_data.dart';

enum AuthMode { Signup, Login , Recover}

/// The result is an error message, callback successes if message is null
typedef AuthCallback = Future<String> Function(LoginData);

/// The result is an error message, callback successes if message is null
typedef RecoverCallback = Future<String> Function(String);

class Auth with ChangeNotifier {
  Auth({
    this.onLogin,
    this.onSignup,
   // this.onConfirm,
    this.onRecoverPassword,
    Auth previous,
  }) {
    if (previous != null) {
      _mode = previous.mode;
    }
  }

  Auth.empty()
      : this(
          onLogin: null,
          onSignup: null,
          //onConfirm: null,
          onRecoverPassword: null,
          previous: null,
        );

  final AuthCallback onLogin;
  final AuthCallback onSignup;
 // final AuthCallback onConfirm;
  final RecoverCallback onRecoverPassword;

  AuthMode _mode = AuthMode.Login;

  AuthMode get mode => _mode;
  set mode(AuthMode value) {
    _mode = value;
    notifyListeners();
  }

  bool get isLogin => _mode == AuthMode.Login;
  bool get isSignup => _mode == AuthMode.Signup;
  //bool get isConfirm =>_mode== AuthMode.Confirm;
  //bool get isRecover => _mode==AuthMode.Recover;
  bool isRecover = false;

  AuthMode opposite() {
    return _mode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
  }

  AuthMode switchAuth() {
    if (mode == AuthMode.Login) {
      mode = AuthMode.Signup;
    } else if (mode == AuthMode.Signup) {
      mode = AuthMode.Login;
    }
    return mode;
  }

  AuthMode switchAuth2(String mod) {
    if(mod=='REGISTER')
      mode = AuthMode.Signup;
     else if (mod == 'LOGIN') {
      mode = AuthMode.Login;
    }
    return mode;
  }
}
