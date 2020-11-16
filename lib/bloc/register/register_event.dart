import 'package:anad_magicar/data/ds/car_ds.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/apis/save_user_result.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/bloc/register/register.dart';
import 'package:anad_magicar/repository/center_repository.dart';

import 'package:meta/meta.dart';


@immutable
abstract class RegisterEvent {
  RegisterState applyAsync(
      {RegisterState currentState, RegisterBloc bloc});

}

class InRegisterEvent extends RegisterEvent{

  String token;
  String typeId;

  InRegisterEvent(this.token, this.typeId);

  @override
  RegisterState applyAsync({RegisterState currentState, RegisterBloc bloc}) {

  }

}

class LoadRegisterEvent extends RegisterEvent {

  SaveUserModel user;
  CarDS carDS;
  BuildContext context;
  bool isEdit;
  LoadRegisterEvent(this.user,this.context,this.isEdit);

  @override
  String toString() => 'LoadRegisterEvent';

  @override
  RegisterState applyAsync({RegisterState currentState, RegisterBloc bloc}) {
  }

}

class RegisteredEvent extends RegisterEvent {
  User user;

  RegisteredEvent({this.user});
  @override
  String toString() => 'RegisteredEvent';

  @override
  RegisterState applyAsync(
      {
        RegisterState currentState, RegisterBloc bloc})  {

  }
}
