import 'dart:async';

import 'package:anad_magicar/bloc/service_type/register.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:bloc/bloc.dart';



class RegisterServiceTypeBloc extends Bloc<RegisterServiceTypeEvent,RegisterServiceTypeState>
{
  static final RegisterServiceTypeBloc _registerBlocSingleton = new RegisterServiceTypeBloc._internal();
  var currentObj;
  factory RegisterServiceTypeBloc() {
    return _registerBlocSingleton;
  }
  RegisterServiceTypeBloc._internal();

  RegisterServiceTypeState get initialState => new UnRegisterServiceTypeState();

  @override
  Stream<RegisterServiceTypeState> mapEventToState(RegisterServiceTypeEvent event) async* {
   if(event is LoadRegisterServiceTypeEvent){
     yield LoadRegisterServiceTypeState();
     try{
       if(event.serviceType!=null) {
         var result=await restDatasource.saveServiceType(event.serviceType);
         if(result!=null) {
           if(result.IsSuccessful) {
             yield RegisteredServiceTypeState();
           }
           yield ErrorRegisterServiceTypeState(result.Message);
         }
         else {
           yield ErrorRegisterServiceTypeState(Translations.current.hasErrors());
         }
       }
     } catch(_, stackTrace){
       yield ErrorRegisterServiceTypeState(_?.toString());
    }
   }
   if(event is RegisteredServiceTypeEvent){
     yield RegisteredServiceTypeState();
   }
   if(event is InRegisterServiceTypeEvent){
     yield InRegisterServiceTypeState();
   }

  }


}
