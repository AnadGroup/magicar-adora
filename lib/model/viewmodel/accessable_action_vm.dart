import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/apis/api_related_user_model.dart';
import 'package:anad_magicar/model/send_command_model.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:flutter/material.dart';

class AccessableActionVM {

  ApiRelatedUserModel userModel;
  int carId;
  bool isFromMainAppForCommand;
  CarStateVM carStateVM;
  SendCommandModel sendCommandModel;
  SendingCommandVM sendingCommandVM;
  NotyBloc<CarStateVM> carStateNoty;
  NotyBloc<SendingCommandVM> sendingCommandNoty;
  AccessableActionVM({
    @required this.userModel,
    @required this.carId,
    @required this.carStateVM,
    @required this.sendingCommandVM,
    @required this.sendCommandModel,
    @required this.isFromMainAppForCommand,
    @required this.carStateNoty,
    @required this.sendingCommandNoty
  });

}
