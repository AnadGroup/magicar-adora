import 'dart:convert';

import 'package:anad_magicar/bloc/car/register.dart';
import 'package:anad_magicar/data/ds/car_ds.dart';
import 'package:anad_magicar/date/helper/shamsi_date.dart';
import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/ui/screen/car/register_car_screen.dart';
import 'package:anad_magicar/ui/screen/register/register_screen.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/bloc/login/login.dart';
import 'package:anad_magicar/repository/center_repository.dart';

import 'package:meta/meta.dart';


@immutable
abstract class RegisterEvent {
  Future<RegisterState> applyAsync(
      {RegisterState currentState, RegisterCarBloc bloc});

}

class UnRegisterEvent extends RegisterEvent{

  String token;
  String typeId;

  UnRegisterEvent(this.token, this.typeId);

  @override
  Future<RegisterState> applyAsync({RegisterState currentState, RegisterCarBloc bloc}) async{
    return UnRegisterState();
  }

}

class InRegisterEvent extends RegisterEvent{

  String token;
  String typeId;

  InRegisterEvent(this.token, this.typeId);

  @override
  Future<RegisterState> applyAsync({RegisterState currentState, RegisterCarBloc bloc}) async{

  }

}

class LoadRegisterEvent extends RegisterEvent {

  User user;
  SaveCarModel carModel;
  BuildContext context;
  LoadRegisterEvent(this.user,this.carModel, this.context);

  @override
  String toString() => 'LoadRegisterEvent';

  @override
  Future<RegisterState> applyAsync({RegisterState currentState, RegisterCarBloc bloc}) async {



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
        RegisterState currentState, RegisterCarBloc bloc}) async {

  }
}
