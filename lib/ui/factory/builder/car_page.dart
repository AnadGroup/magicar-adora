import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/ui/factory/builder/body.dart';
import 'package:anad_magicar/ui/factory/builder/car_page_builder.dart';
import 'package:anad_magicar/ui/factory/builder/car_vm.dart';
import 'package:anad_magicar/ui/factory/builder/car_widgets.dart';
import 'package:anad_magicar/ui/factory/builder/panel.dart';
import 'package:flutter/src/widgets/framework.dart';


class CarPage extends CarWidgets {

  CarVM carVM;
  CarPageBuilder carPageBuilder;

  CarPage({
    @required this.carVM,
    @required this.carPageBuilder,
  });

  @override
  CarStateVM createCarState() {
     carVM.carStateVM=new CarStateVM(
       arm: false,
         siren: false,
         colorIndex: null,
         color: null,
         carIndex: null,
         isDoorOpen: false,
         isTraunkOpen: false,
         isCaputOpen: false,
         bothClosed: true,
         carImage: null,
         carDoorImage: null,
         carTrunkImage: null,
         carCaputImage: null,
         carId: null,
         colorId: null);
    return carVM.carStateVM;
  }

  @override
  Widget getBody() {
    // TODO: implement getBody
    return getCarBody().creatWidget();
  }



  @override
  int getCarID() {
    // TODO: implement getCarID
    return carVM.carId;
  }

  @override
  int getCarIndex() {
    // TODO: implement getCarIndex
    return carVM.carIndex;
  }

  @override
  Panel getCarPanel() {
    // TODO: implement getCarPanel
    return createCarPanel();
  }

  @override
  CarStateVM getCarState() {
    // TODO: implement getCarState
    return carVM.carStateVM;
  }

  @override
  Widget getPanel() {
    // TODO: implement getPanel
    return getCarPanel().creatWidget();
  }

  @override
  Body getCarBody() {
    // TODO: implement getCarBody
    return createCarBody();
  }


}

