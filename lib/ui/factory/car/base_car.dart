
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/ui/factory/builder/car_vm.dart';
import 'package:flutter/material.dart';

abstract class BaseCar<T> {

  CarVM carVM;
  void init();
  Widget createCarWidget();
  List<Widget> createCarWidgets();
  Widget createCar();
  CarStateVM updateCarState(CarStateVM newState);

}
