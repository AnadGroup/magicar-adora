import 'dart:async';

import 'package:anad_magicar/data/event_listener.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super();
}

class LoginButtonPressed extends LoginEvent  {
  final String username;
  final String password;

  LoginButtonPressed({
    @required this.username,
    @required this.password,
  }) : super([username, password]){
   // init();
  }


  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password }';

  @override
  // TODO: implement props
  List<Object> get props => null;

}

class SignUpButtonPressed extends LoginEvent  {
  final String mobile;


  SignUpButtonPressed({
    @required this.mobile,

  }) : super([mobile, ]){
    // init();
  }


  @override
  String toString() =>
      'SignUpButtonPressed { mobile: $mobile}';

  @override
  // TODO: implement props
  List<Object> get props => null;

}

class ReSignUpButtonPressed extends LoginEvent  {
  final String mobile;


  ReSignUpButtonPressed({
    @required this.mobile,

  }) : super([mobile, ]){
    // init();
  }


  @override
  String toString() =>
      'ReSignUpButtonPressed { mobile: $mobile}';

  @override
  // TODO: implement props
  List<Object> get props => null;

}
//بعد از رجیستر باید توکن دریافت شود این رویداد جهت کال کردن authenticate از سرور میباشد
class LoginPassed extends LoginEvent {
  final String username;
  final String password;

  LoginPassed({
    @required this.username,
    @required this.password,
  }) : super([username, password]);


  @override
  String toString() =>
      'LoginPassed { username: $username, password: $password }';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginFailed extends LoginEvent {
  final String errorMessage;


  LoginFailed({
    @required this.errorMessage,

  }) : super([errorMessage,]);


  @override
  String toString() =>
      'LoginFailed { error: $errorMessage }';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SignUpFailed extends LoginEvent {
  final String errorMessage;


  SignUpFailed({
    @required this.errorMessage,

  }) : super([errorMessage,]);


  @override
  String toString() =>
      'SignUpFailed { error: $errorMessage }';

  @override
  // TODO: implement props
  List<Object> get props => null;
}
