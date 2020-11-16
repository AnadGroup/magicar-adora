import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:flutter/material.dart';

class CarVM {

  BuildContext context;
  CarStateVM carStateVM;
  AnimationController rotationController;
  NotyBloc<Message> carPageChangedNoty;
  NotyBloc<CarStateVM> carStateNoty;
  NotyBloc<SendingCommandVM> sendCommandNoty;


  var startEnginChangedNoty=new NotyBloc<Message>();
  var statusChangedNoty=new NotyBloc<CarStateVM>();
  var carLockPanelNoty=new NotyBloc<Message>();
  var valueNotyModelBloc=new NotyBloc<ChangeEvent>();

  Color color;

  int index;
  bool lock_status=true;
  bool power_status=false;
  bool trunk_status=false;
  bool engine_status=false;
  int carIndex;
  int carId;

  bool isCurrent=false;

  final double initFabHeight = 30.0;
  double fabHeight;
  double panelHeightOpen = 180.0;
  double panelHeightClosed = 35.0;
  Function(double pos) onSlideChange;
  NotyBloc<ChangeEvent> notySlideChanged;


  updateCarState(CarStateVM newState)
  {
    this.carStateVM=newState;
    carStateNoty.updateValue(this.carStateVM);
  }

  sendCommandUpdate(SendingCommandVM newCommand)
  {
    sendCommandNoty.updateValue(newCommand);
  }

  sendSlideChangeNoty(ChangeEvent event)
  {
    notySlideChanged.updateValue(event);
  }
}
