import 'dart:async';
import 'package:anad_magicar/bloc/car/confirm/confirm_car_event.dart';
import 'package:anad_magicar/bloc/car/confirm/confirm_car_state.dart';
import 'package:anad_magicar/bloc/car/register.dart';
import 'package:bloc/bloc.dart';



class ConfirmCarBloc extends Bloc<ConfirmCarEvent,ConfirmCarState>
{
  static final ConfirmCarBloc _registerBlocSingleton = new ConfirmCarBloc._internal();
  var currentObj;
  factory ConfirmCarBloc() {
    return _registerBlocSingleton;
  }
  ConfirmCarBloc._internal();

  ConfirmCarState get initialState => new UnConfirmCarState();

  @override
  Stream<ConfirmCarState> mapEventToState(ConfirmCarEvent event) async* {
   try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }

  }


}

ConfirmCarBloc confirmCarBloc=new ConfirmCarBloc();
