import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/send_command_model.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/service/base_commands.dart';
import 'package:anad_magicar/service/do_command.dart';
import 'package:flutter/material.dart';

class CommandBuilder  {

  //static CommandBuilder _commandBuilder=new CommandBuilder._internal();

  /*factory CommandBuilder(SendCommandModel sendCommand,
      SendingCommandVM sendingCommand,
      NotyBloc<CarStateVM> carStateNot,
      NotyBloc<SendingCommandVM> sendCommandNot,
      CarStateVM carState,
      String actionCod,
      int userID,
      int carID
      )
  {
    sendCommandModel=sendCommand;
    sendingCommandVM=sendingCommand;
    sendCommandNoty=sendCommandNot;
    carStateNoty=carStateNot;
    carStateVM=carState;
    actionCode=actionCod;
    userId=userID;
    carId=carID;
    return _commandBuilder;
  }

  CommandBuilder._internal();*/

   SendCommandModel sendCommandModel;
   SendingCommandVM sendingCommandVM;
   NotyBloc<SendingCommandVM> sendCommandNoty;
   NotyBloc<CarStateVM> carStateNoty;
   CarStateVM carStateVM;
   String actionCode;
   int userId;
   int carId;

  CommandBuilder({
    @required this.sendCommandModel,
    @required this.sendingCommandVM,
    @required this.sendCommandNoty,
    @required this.carStateNoty,
    @required this.carStateVM,
    @required this.actionCode,
    @required this.userId,
    @required this.carId,
  });

  DoCommand commandBuild() {
    return new DoCommand(commandBuilder: this
        /*sendCommandModel: sendCommandModel,
        sendingCommandVM: sendingCommandVM,
        actionCode: actionCode,
        sendCommandNoty: sendCommandNoty,
        userId: userId,
        carId: carId,
        carStateVM: carStateVM,
        carStateNoty: carStateNoty*/);
  }
}
