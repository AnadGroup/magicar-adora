import 'package:flutter/foundation.dart';

class LoginData {
  final String name;
  final String password;
  final String firstName;
  final String lastName;
  final String mobile;
  final String currentPassword;
  final String confrimPassword;
  bool cancel;
  LoginData({
    @required this.name,
    @required this.password,
    @required this.currentPassword,
    @required this.confrimPassword,
    @required this.firstName,
    @required this.lastName,
    @required this.mobile,
    @required this.cancel,
  });

  @override
  String toString() {
    return '$runtimeType($name, $password)';
  }
}
