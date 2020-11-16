import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterState extends Equatable {
  RegisterState([Iterable props]) : super();

  /// Copy object for use in action
  RegisterState getStateCopy();
}

class UnRegisterState extends RegisterState {
@override
  String toString() => 'UnRegisterState';

  @override
  RegisterState getStateCopy() {
    return UnRegisterState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;

}

class InRegisterState extends RegisterState {

  @override
  String toString() => 'InRegisterState';

  @override
  RegisterState getStateCopy() {
    return InRegisterState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadRegisterState extends RegisterState {

  @override
  String toString() => 'LoadRegisterState';

  @override
  RegisterState getStateCopy() {
    return LoadRegisterState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
class RegisteredState extends RegisterState {

  @override
  String toString() => 'RegisteredState';

  @override
  RegisterState getStateCopy() {
    return RegisteredState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorRegisterState extends RegisterState {
  final String errorMessage;

  ErrorRegisterState(this.errorMessage);

  @override
  String toString() => 'ErrorRegisterState';

  @override
  RegisterState getStateCopy() {
    return ErrorRegisterState(this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
