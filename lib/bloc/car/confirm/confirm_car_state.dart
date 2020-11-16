import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConfirmCarState extends Equatable {
  ConfirmCarState([Iterable props]) : super();

  /// Copy object for use in action
  ConfirmCarState getStateCopy();
}

class UnConfirmCarState extends ConfirmCarState {
@override
  String toString() => 'UnConfirmCarState';

  @override
  ConfirmCarState getStateCopy() {
    return UnConfirmCarState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;

}

class InConfirmCarState extends ConfirmCarState {

  @override
  String toString() => 'InConfirmCarState';

  @override
  ConfirmCarState getStateCopy() {
    return InConfirmCarState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadConfirmCarState extends ConfirmCarState {

  @override
  String toString() => 'LoadConfirmCarState';

  @override
  ConfirmCarState getStateCopy() {
    return LoadConfirmCarState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
class ConfirmedCarState extends ConfirmCarState {

  @override
  String toString() => 'ConfirmedCarState';

  @override
  ConfirmCarState getStateCopy() {
    return ConfirmedCarState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ChangedCarState extends ConfirmCarState {

  @override
  String toString() => 'ChangedCarState';

  @override
  ConfirmCarState getStateCopy() {
    return ChangedCarState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
class ErrorConfirmCarState extends ConfirmCarState {
  final String errorMessage;

  ErrorConfirmCarState(this.errorMessage);

  @override
  String toString() => 'ErrorConfirmCarState';

  @override
  ConfirmCarState getStateCopy() {
    return ErrorConfirmCarState(this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
