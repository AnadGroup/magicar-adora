import 'package:flutter/foundation.dart';

class LoginData {
  final String name;
  final String password;
  final String firstName;
  final String lastName;
  final String mobile;
  LoginData({
    @required this.name,
    @required this.password,
    @required this.firstName,
    @required this.lastName,
    @required this.mobile
  });

  @override
  String toString() {
    return '$runtimeType($name, $password)';
  }
}
