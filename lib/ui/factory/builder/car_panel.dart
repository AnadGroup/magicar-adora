import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/ui/factory/builder/car_vm.dart';
import 'package:anad_magicar/ui/factory/car/base_car.dart';
import 'package:anad_magicar/ui/factory/car/car_panel_widget.dart';
import 'package:flutter/material.dart';

class CarPanel extends BaseCar<CarStateVM> {


  CarVM carVM;


  @override
  Widget createCar() {
    // TODO: implement createCar
    return null;
  }

  @override
  Widget createCarWidget() {

    return new CarPanelWidget(
      carPageNoty: carVM.carPageChangedNoty,
      carStateNoty: carVM.carStateNoty,
      carStateVM: carVM.carStateVM,
      lockStatus: carVM.lock_status,
      engineStatus: carVM.engine_status ,
      sendCommandNoty: carVM.sendCommandNoty,
    );
  }

  @override
  List<Widget> createCarWidgets() {
    // TODO: implement createCarWidgets
    return null;
  }

  @override
  void init() {

  }

  @override
  CarStateVM updateCarState(CarStateVM newState) {
    // TODO: implement updateCarState
    return null;
  }

  CarPanel({
    @required this.carVM,
  });

}
