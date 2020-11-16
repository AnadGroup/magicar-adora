
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/model/send_command_model.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:flutter/material.dart';

abstract class BaseCommands<T> {

  SendCommandModel sendCommandModel;
  SendingCommandVM sendingCommandVM;
  NotyBloc<SendingCommandVM> sendCommandNoty;
  NotyBloc<CarStateVM> carStateNoty;

  CarStateVM carStateVM;

  String actionCode;
  int userId;
  int carId;

  BaseCommands({
    @required this.sendCommandModel,
    @required this.sendingCommandVM,
    @required this.sendCommandNoty,
    @required this.carStateNoty,
    @required this.carStateVM,
    @required this.actionCode,
    @required this.userId,
    @required this.carId,
  });

 Future<bool> createSendCommand();
  createSentCommand();
  createSendErrorCommand();
  createSendNoInternetCommand();

  update();
  updateCarState();

 void sendCommand() {

      createSendCommand().then((result){
        if(result)
          {
            createSentCommand();

          }
        else
          {
            createSendErrorCommand();
          }
        Future.delayed(new Duration(milliseconds: 10000)).then((value){
          sendCommandNoty.updateValue(
              new SendingCommandVM(sending: false,
                  sent: false, hasError: false));
        });
      });
    //play('', actionCode);
  }


}
