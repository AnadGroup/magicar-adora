import 'package:anad_magicar/model/user/user.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super();
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SignUpLoading extends LoginState {


  @override
  String toString() => 'SigUpLoading';

  @override
  // TODO: implement props
  List<Object> get props => null;
}
class LoginLoading extends LoginState {


  @override
  String toString() => 'LoginLoading';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginDone extends LoginState {
  User user;

  @override
  String toString() => 'LoginDone';

  LoginDone({
     this.user,
  });

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SignUpDone extends LoginState {
  String code;

  @override
  String toString() => 'SignUpDone';

  SignUpDone({
    this.code,
  });
  @override
  // TODO: implement props
  List<Object> get props => null;
}
class SignUpFaild extends LoginState {
  String error;

  @override
  String toString() => 'SignUpFaild';

  SignUpFaild({
    this.error,
  });
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginForAuthenticate extends LoginState {
  User user;

  @override
  String toString() => 'LoginForAuthenticate';

  LoginForAuthenticate({
     this.user,
  });
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginForConfirm extends LoginState {
  User user;

  @override
  String toString() => 'LoginForConfirm';

  LoginForConfirm({
     this.user,
  });
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginNoConnection extends LoginState {
  final String error;

  LoginNoConnection({ this.error}) : super([error]);

  @override
  String toString() => 'LoginNoConnection { error: $error }';
  @override
  // TODO: implement props
  List<Object> get props => null;
}
class SigUpNoConnection extends LoginState {
  final String error;

  SigUpNoConnection({ this.error}) : super([error]);

  @override
  String toString() => 'SigUpNoConnection { error: $error }';
  @override
  // TODO: implement props
  List<Object> get props => null;
}
class LoginFailure extends LoginState {
  final String error;

  LoginFailure({ this.error}) : super([error]);

  @override
  String toString() => 'LoginFailure { error: $error }';
  @override
  // TODO: implement props
  List<Object> get props => null;
}
