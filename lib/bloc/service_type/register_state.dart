import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterServiceTypeState extends Equatable {
  RegisterServiceTypeState([Iterable props]) : super();

  /// Copy object for use in action
  RegisterServiceTypeState getStateCopy();
}

class UnRegisterServiceTypeState extends RegisterServiceTypeState {
@override
  String toString() => 'UnRegisterServiceTypeServiceTypeState';

  @override
  RegisterServiceTypeState getStateCopy() {
    return UnRegisterServiceTypeState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;

}

class InRegisterServiceTypeState extends RegisterServiceTypeState {

  @override
  String toString() => 'InRegisterServiceTypeState';

  @override
  RegisterServiceTypeState getStateCopy() {
    return InRegisterServiceTypeState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadRegisterServiceTypeState extends RegisterServiceTypeState {

  @override
  String toString() => 'LoadRegisterServiceTypeState';

  @override
  RegisterServiceTypeState getStateCopy() {
    return LoadRegisterServiceTypeState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
class RegisteredServiceTypeState extends RegisterServiceTypeState {

  @override
  String toString() => 'RegisterServiceTypeedState';

  @override
  RegisterServiceTypeState getStateCopy() {
    return RegisteredServiceTypeState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorRegisterServiceTypeState extends RegisterServiceTypeState {
  final String errorMessage;

  ErrorRegisterServiceTypeState(this.errorMessage);

  @override
  String toString() => 'ErrorRegisterServiceTypeState';

  @override
  RegisterServiceTypeState getStateCopy() {
    return ErrorRegisterServiceTypeState(this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
