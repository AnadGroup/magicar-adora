import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class PressedEvent extends Equatable {
    PressedEvent([List props = const []]) : super();
}


class StartPressed extends PressedEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class Pressed extends PressedEvent
{
 final BuildContext context;
   Pressed(this.context) : super([context]);
 @override
 // TODO: implement props
 List<Object> get props => null;
}
