import 'dart:convert';

import 'package:anad_magicar/bloc/service/register.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_car_service.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/pref_repository.dart';

import 'package:flutter/material.dart';

import 'package:anad_magicar/repository/center_repository.dart';

import 'package:meta/meta.dart';


@immutable
abstract class RegisterServiceEvent {
  Future<RegisterServiceState> applyAsync(
      {RegisterServiceState currentState, RegisterCarServiceBloc bloc});

}

class UnRegisterServiceEvent extends RegisterServiceEvent {

  String token;
  String typeId;

  UnRegisterServiceEvent(this.token, this.typeId);

  @override
  Future<RegisterServiceState> applyAsync({RegisterServiceState currentState, RegisterCarServiceBloc bloc}) async{
    return UnRegisterServiceState();
  }

}

class InRegisterServiceEvent extends RegisterServiceEvent{

  String token;
  String typeId;

  InRegisterServiceEvent(this.token, this.typeId);

  @override
  Future<RegisterServiceState> applyAsync({RegisterServiceState currentState, RegisterCarServiceBloc bloc}) async{

  }

}

class LoadRegisterServiceEvent extends RegisterServiceEvent {

  User user;
  ApiService serviceModel;
  BuildContext context;
  LoadRegisterServiceEvent(this.user,this.serviceModel, this.context);

  @override
  String toString() => 'LoadRegisterServiceEvent';

  @override
  Future<RegisterServiceState> applyAsync({RegisterServiceState currentState, RegisterCarServiceBloc bloc}) async {


  }
}

class RegisteredServiceEvent extends RegisterServiceEvent {
  User user;

  RegisteredServiceEvent({this.user});
  @override
  String toString() => 'RegisteredServiceEvent';

  @override
  Future<RegisterServiceState> applyAsync(
      {
        RegisterServiceState currentState, RegisterCarServiceBloc bloc}) async {

  }
}
