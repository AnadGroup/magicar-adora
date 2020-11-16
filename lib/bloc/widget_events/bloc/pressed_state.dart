import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PressedState extends Equatable {
  PressedState([List props = const []]) : super();
}

class InitialPressedState extends PressedState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}


class DoClick extends PressedState {
  final BuildContext context;
  DoClick(this.context) : super([context]);
  @override
  // TODO: implement props
  List<Object> get props => null;
}
