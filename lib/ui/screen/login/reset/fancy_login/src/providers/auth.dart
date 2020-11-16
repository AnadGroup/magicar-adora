import 'package:flutter/material.dart';

import '../models/login_data.dart';

enum AuthMode { Cancel, Confirm , Recover}

/// The result is an error message, callback successes if message is null
typedef AuthCallback = Future<String> Function(LoginData);

/// The result is an error message, callback successes if message is null
typedef RecoverCallback = Future<String> Function(String);

class Auth with ChangeNotifier {
  Auth({
    this.onConfirm,
    this.onCancel,
    this.onRecoverPassword,
    Auth previous,
  }) {
    if (previous != null) {
      _mode = previous.mode;
    }
  }

  Auth.empty()
      : this(
    onConfirm: null,
    onCancel: null,
          onRecoverPassword: null,
          previous: null,
        );

  final AuthCallback onConfirm;
  final AuthCallback onCancel;
  final RecoverCallback onRecoverPassword;

  AuthMode _mode = AuthMode.Confirm;

  AuthMode get mode => _mode;
  set mode(AuthMode value) {
    _mode = value;
    notifyListeners();
  }

  bool get isConfirm => _mode == AuthMode.Confirm;
  bool get isCancel => _mode == AuthMode.Cancel;
  //bool get isRecover => _mode==AuthMode.Recover;
  bool isRecover = false;

  AuthMode opposite() {
    return _mode == AuthMode.Confirm ? AuthMode.Cancel : AuthMode.Confirm;
  }

  AuthMode switchAuth() {
    if (mode == AuthMode.Confirm) {
      mode = AuthMode.Cancel;
    } else if (mode == AuthMode.Cancel) {
      mode = AuthMode.Confirm;
    }
    return mode;
  }


}
