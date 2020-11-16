import 'package:anad_magicar/model/AppLocal.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocalEvent extends Equatable {
  // Passing class fields in a list to the Equatable super class
  LocalEvent([List props = const []]) : super();
}

class LocalChanged extends LocalEvent {
  final AppLocal local;

  LocalChanged({
    @required this.local,
  }) : super([local]);
  @override
  // TODO: implement props
  List<Object> get props => null;
}
