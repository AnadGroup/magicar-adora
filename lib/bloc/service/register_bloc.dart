import 'dart:async';
import 'package:anad_magicar/bloc/service/register.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/ui/screen/service/service_page.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';



class RegisterCarServiceBloc extends Bloc<RegisterServiceEvent,RegisterServiceState>
{
  static final RegisterCarServiceBloc _registerBlocSingleton = new RegisterCarServiceBloc._internal();
  var currentObj;
  factory RegisterCarServiceBloc() {
    return _registerBlocSingleton;
  }
  RegisterCarServiceBloc._internal();

  RegisterServiceState get initialState => new UnRegisterServiceState();

  @override
  Stream<RegisterServiceState> mapEventToState(RegisterServiceEvent event) async* {


      if (event is LoadRegisterServiceEvent) {
        yield LoadRegisterServiceState();
        if (event.serviceModel != null) {
          try {
          var result = await restDatasource.saveCarService(event.serviceModel);
          if (result != null) {
            if (result.IsSuccessful)
              yield RegisteredServiceState();
            else
              yield ErrorRegisterServiceState(result.Message);
          }
          else
            yield ErrorRegisterServiceState('خطا در ثبت سرویس خودرو');
        }
          catch (_, stackTrace) {
            yield ErrorRegisterServiceState(_?.toString());
          }
      }
  }
      if(event is RegisteredServiceEvent){
        yield RegisteredServiceState();
      }
      if(event is InRegisterServiceEvent){
        yield InRegisterServiceState();
      }
  /* try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }*/

  }


}
