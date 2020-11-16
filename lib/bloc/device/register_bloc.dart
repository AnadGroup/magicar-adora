import 'dart:async';
//import 'package:anad_magicar/bloc/device/register_event.dart';
import 'package:anad_magicar/bloc/device/register.dart';
import 'package:bloc/bloc.dart';



class RegisterDeviceBloc extends Bloc<RegisterEvent,RegisterState>
{
  static final RegisterDeviceBloc _registerBlocSingleton = new RegisterDeviceBloc._internal();
  var currentObj;
  factory RegisterDeviceBloc() {
    return _registerBlocSingleton;
  }
  RegisterDeviceBloc._internal();

  RegisterState get initialState => new UnRegisterState();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
   try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }

  }


}
