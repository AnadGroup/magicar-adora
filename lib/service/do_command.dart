import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/send_command_model.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/service/base_commands.dart';
import 'package:anad_magicar/service/command_builder.dart';
import 'package:flutter/material.dart';

class DoCommand extends BaseCommands {

  SendCommandModel sendCommandModel;
  SendingCommandVM sendingCommandVM;
  NotyBloc<SendingCommandVM> sendCommandNoty;
  NotyBloc<CarStateVM> carStateNoty;

  CarStateVM carStateVM;

  String actionCode;
  int userId;
  int carId;
  CommandBuilder commandBuilder;
  DoCommand({
    @required this.commandBuilder,
  }) {
    this.userId=this.commandBuilder.userId;
    this.carId=this.commandBuilder.carId;
    this.actionCode=this.commandBuilder.actionCode;
    this.sendCommandNoty=this.commandBuilder.sendCommandNoty;
    this.sendCommandModel=this.commandBuilder.sendCommandModel;
    this.carStateVM=this.commandBuilder.carStateVM;
    this.carStateNoty=this.commandBuilder.carStateNoty;
    this.sendingCommandVM=this.commandBuilder.sendingCommandVM;
    if(this.carStateVM==null)
      {
        this.carStateVM=centerRepository.getCarStateVMByCarId(carId);
      }
  }



  @override
 Future<bool> createSendCommand() async {

    int actionId=ActionsCommand.actionCommandsMap[actionCode];
    SendCommandModel sendCommand = new SendCommandModel(
        UserId: userId,
        ActionId: actionId,
        CarId: carId,
        Command: '');

    sendCommandNoty.updateValue(new SendingCommandVM(sending: true,
        sent: false, hasError: false));
    try {

        ServiceResult result = await restDatasource.sendCommand(sendCommand);
        if (result != null) {
          if (result.IsSuccessful) {
            updateCarState();
            return true;
          }
          else {
            return false;
          }
        } else {
          return false;
        }

    }
    catch (error) {

      //createSendErrorCommand();
      //return false;
    }

    return true;
  }

  @override
  update() {
    // TODO: implement update
    return null;
  }

  @override
  updateCarState() {
    createSentCommand();
    carStateVM.setCarStatusImages();
    centerRepository.updateCarStateVMMap(carStateVM);
    carStateNoty.updateValue(carStateVM);
    return null;
  }





  @override
  createSendErrorCommand() {
    sendCommandNoty.updateValue(
        new SendingCommandVM(sending: false,
            sent: false, hasError: true));
    return null;
  }

  @override
  createSendNoInternetCommand() {
    sendCommandNoty.updateValue(
        new SendingCommandVM(sending: false,
            sent: false, hasError: true));
    return null;
  }

  @override
  createSentCommand() {
    sendCommandNoty.updateValue(
        new SendingCommandVM(sending: false,
            sent: true, hasError: false));
    return null;
  }





}
