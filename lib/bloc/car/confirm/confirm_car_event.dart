import 'dart:convert';

import 'package:anad_magicar/bloc/car/confirm/confirm_car_bloc.dart';
import 'package:anad_magicar/bloc/car/confirm/confirm_car_state.dart';
import 'package:anad_magicar/bloc/car/register.dart';
import 'package:anad_magicar/data/ds/car_ds.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:meta/meta.dart';


@immutable
abstract class ConfirmCarEvent {
  Future<ConfirmCarState> applyAsync(
      {ConfirmCarState currentState, ConfirmCarBloc bloc});

}

class InConfirmCarEvent extends ConfirmCarEvent{

  String token;
  String typeId;

  InConfirmCarEvent(this.token, this.typeId);

  @override
  Future<ConfirmCarState> applyAsync({ConfirmCarState currentState, ConfirmCarBloc bloc}) async{
    if(currentState is UnConfirmCarState) {
      try {
            return new LoadConfirmCarState();
      }
      catch (_, stackTrace) {
        return new ErrorConfirmCarState(_?.toString());
      }
    }
    return new InConfirmCarState();
  }

}

class LoadConfirmCarEvent extends ConfirmCarEvent {

  int userId;
  int carId;
  int roleId;
  BuildContext context;
  int statusId;

  LoadConfirmCarEvent(this.userId, this.carId, this.roleId,this.context, this.statusId);

  @override
  String toString() => 'LoadConfirmCarEvent';

  @override
  Future<ConfirmCarState> applyAsync(
      {ConfirmCarState currentState, ConfirmCarBloc bloc}) async {
    try {
      RestDatasource resDS = new RestDatasource();
      ServiceResult result = await resDS.acceptRequestByAdmin(
          userId, carId,roleId, statusId);
      if (result != null &&
          result.IsSuccessful) {
        return ConfirmedCarState();
      }
      else {
        return ErrorConfirmCarState(result.Message);
      }
    } catch (_, stackTrace) {
      return ErrorConfirmCarState(_?.toString());
    }
  }
}
class ConfirmedCarEvent extends ConfirmCarEvent {
  User user;

  ConfirmedCarEvent({this.user});
  @override
  String toString() => 'ConfirmedCarEvent';

  @override
  Future<ConfirmCarState> applyAsync(
      {
        ConfirmCarState currentState, ConfirmCarBloc bloc}) async {
    try {


      return new ConfirmedCarState();
    } catch (_, stackTrace) {

      return new ErrorConfirmCarState(_?.toString());
    }
  }
}
class ChangeCarStateEvent extends ConfirmCarEvent {
  User user;

  ChangeCarStateEvent({this.user});
  @override
  String toString() => 'ChangeCarStateEvent';

  @override
  Future<ConfirmCarState> applyAsync(
      {
        ConfirmCarState currentState, ConfirmCarBloc bloc}) async {
    try {


      return new ConfirmedCarState();
    } catch (_, stackTrace) {

      return new ErrorConfirmCarState(_?.toString());
    }
  }
}
