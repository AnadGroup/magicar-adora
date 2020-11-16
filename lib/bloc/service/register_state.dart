import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterServiceState extends Equatable {
  RegisterServiceState([Iterable props]) : super();

  /// Copy object for use in action
  RegisterServiceState getStateCopy();
}

class UnRegisterServiceState extends RegisterServiceState {
@override
  String toString() => 'UnRegisterState';

  @override
  RegisterServiceState getStateCopy() {
    return UnRegisterServiceState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;

}

class InRegisterServiceState extends RegisterServiceState {

  @override
  String toString() => 'InRegisterState';

  @override
  RegisterServiceState getStateCopy() {
    return InRegisterServiceState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadRegisterServiceState extends RegisterServiceState {

  @override
  String toString() => 'LoadRegisterState';

  @override
  RegisterServiceState getStateCopy() {
    return LoadRegisterServiceState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
class RegisteredServiceState extends RegisterServiceState {

  @override
  String toString() => 'RegisteredState';

  @override
  RegisterServiceState getStateCopy() {
    return RegisteredServiceState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorRegisterServiceState extends RegisterServiceState {
  final String errorMessage;

  ErrorRegisterServiceState(this.errorMessage);

  @override
  String toString() => 'ErrorRegisterState';

  @override
  RegisterServiceState getStateCopy() {
    return ErrorRegisterServiceState(this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
