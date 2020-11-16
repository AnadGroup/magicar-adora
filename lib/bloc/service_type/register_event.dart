import 'dart:convert';


import 'package:anad_magicar/bloc/service_type/register.dart';
import 'package:anad_magicar/data/ds/car_ds.dart';
import 'package:anad_magicar/data/rest_ds.dart';

import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/cars/car.dart';

import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';

import 'package:flutter/material.dart';
import 'package:anad_magicar/bloc/login/login.dart';
import 'package:anad_magicar/repository/center_repository.dart';

import 'package:meta/meta.dart';


@immutable
abstract class RegisterServiceTypeEvent {
  Future<RegisterServiceTypeState> applyAsync(
      {RegisterServiceTypeState currentState, RegisterServiceTypeBloc bloc});

}

class UnRegisterServiceTypeEvent extends RegisterServiceTypeEvent{

  String token;
  String typeId;

  UnRegisterServiceTypeEvent(this.token, this.typeId);

  @override
  Future<RegisterServiceTypeState> applyAsync({RegisterServiceTypeState currentState, RegisterServiceTypeBloc bloc}) async{
    return UnRegisterServiceTypeState();
  }

}

class InRegisterServiceTypeEvent extends RegisterServiceTypeEvent{

  String token;
  String typeId;

  InRegisterServiceTypeEvent(this.token, this.typeId);

  @override
  Future<RegisterServiceTypeState> applyAsync({RegisterServiceTypeState currentState, RegisterServiceTypeBloc bloc}) async{

  }

}

class LoadRegisterServiceTypeEvent extends RegisterServiceTypeEvent {

  User user;
  ServiceType serviceType;
  BuildContext context;
  LoadRegisterServiceTypeEvent(this.user,this.serviceType, this.context);

  @override
  String toString() => 'LoadRegisterServiceTypeEvent';

  @override
  Future<RegisterServiceTypeState> applyAsync({RegisterServiceTypeState currentState, RegisterServiceTypeBloc bloc}) async {


  }
}

class RegisteredServiceTypeEvent extends RegisterServiceTypeEvent {
  User user;

  RegisteredServiceTypeEvent({this.user});
  @override
  String toString() => 'RegisteredServiceTypeEvent';

  @override
  Future<RegisterServiceTypeState> applyAsync(
      {
        RegisterServiceTypeState currentState, RegisterServiceTypeBloc bloc}) async {

  }
}
