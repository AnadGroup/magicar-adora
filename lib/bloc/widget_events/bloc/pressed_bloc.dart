import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class PressedBloc extends Bloc<PressedEvent, PressedState> {
StreamSubscription subscription;

  @override
  PressedState get initialState => InitialPressedState();

  @override
  Stream<PressedState> mapEventToState(
    PressedEvent event,
  ) async* {
    if(event is StartPressed)
    {
      subscription?.cancel();

    }
    if(event is Pressed)
    {
      yield DoClick(event.context);
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    //super.dispose();
  }
}
