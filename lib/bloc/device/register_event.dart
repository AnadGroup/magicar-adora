import 'dart:convert';
import 'package:anad_magicar/bloc/device/register.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


@immutable
abstract class RegisterEvent {
  Future<RegisterState> applyAsync(
      {RegisterState currentState, RegisterDeviceBloc bloc});

}

class InRegisterEvent extends RegisterEvent{

  String token;
  String typeId;

  InRegisterEvent(this.token, this.typeId);

  @override
  Future<RegisterState> applyAsync({RegisterState currentState, RegisterDeviceBloc bloc}) async{
    if(currentState is UnRegisterState) {
      try {

            return new LoadRegisterState();

      }

      catch (_, stackTrace) {
        return new ErrorRegisterState(_?.toString());
      }
    }
    return new InRegisterState();
  }

}

class LoadRegisterEvent extends RegisterEvent {

  User user;
  BuildContext context;
  LoadRegisterEvent(this.user,this.context);

  @override
  String toString() => 'LoadRegisterEvent';

  @override
  Future<RegisterState> applyAsync({RegisterState currentState, RegisterDeviceBloc bloc}) async {

   try {
        //UserRepository userRepository=new UserRepository();
       bool isLogged = await prefRepository.setLoggedIn(false);
       if (isLogged)
         return new RegisteredState();
       else
         return new InRegisterState();

    } catch (_, stackTrace) {
      return new ErrorRegisterState(_?.toString());
    }
  }
}

class RegisteredEvent extends RegisterEvent {
  User user;

  RegisteredEvent({this.user});
  @override
  String toString() => 'RegisteredEvent';

  @override
  Future<RegisterState> applyAsync(
      {
        RegisterState currentState, RegisterDeviceBloc bloc}) async {
    try {


      return new RegisteredState();
    } catch (_, stackTrace) {

      return new ErrorRegisterState(_?.toString());
    }
  }
}
