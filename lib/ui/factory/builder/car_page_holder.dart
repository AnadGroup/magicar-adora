import 'dart:collection';

import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/ui/factory/builder/body.dart';
import 'package:anad_magicar/ui/factory/builder/car_page.dart';
import 'package:anad_magicar/ui/factory/builder/car_page_builder.dart';
import 'package:anad_magicar/ui/factory/builder/car_vm.dart';
import 'package:flutter/material.dart';

class CarPageHolder {

  static CarPageHolder _carPageHolder=new CarPageHolder._internal();

  static int currentCarId;
  static int currentCarIndex;
  static var startEnginChangedNoty=new NotyBloc<Message>();
  static var statusChangedNoty=new NotyBloc<CarStateVM>();
  static var carPageChangedNoty=new NotyBloc<Message>();
  static var carLockPanelNoty=new NotyBloc<Message>();
  static var sendCommandNoty=new NotyBloc<SendingCommandVM>();
  static var valueNotyModelBloc=new NotyBloc<ChangeEvent>();
  static AnimationController rotationContorller;

  factory CarPageHolder()
  {
    return _carPageHolder;
  }

  CarPageHolder._internal();


  HashMap<int,CarVM> carVMByCarIDMap=new HashMap();
  HashMap<int,CarPage> carPagesByCarIDMap=new HashMap();

  List<CarPage> carPages=new List();
  List<Container> carPageContainer=new List();

  addCarPage(int carId,int carIndx)
  {
    if(carPages==null)
      carPages=new List();
    if(carPageContainer==null)
      carPageContainer=new List();
    CarVM carVM=new CarVM();
    carVM.carIndex=carIndx;
    carVM.carId=carId;
    carVM.valueNotyModelBloc=valueNotyModelBloc;
    carVM.carPageChangedNoty=carPageChangedNoty;
    carVM.carLockPanelNoty=carLockPanelNoty;
    carVM.rotationController=rotationContorller;
    //carVM.carStateNoty=statusChangedNoty;
    carVM.statusChangedNoty=statusChangedNoty;
    carVM.startEnginChangedNoty=startEnginChangedNoty;
    carVM.sendCommandNoty=sendCommandNoty;
    carPageBuilder.setCarVM(carVM);
    CarPage carPage=carPageBuilder.build();
    carPages..add(carPage);

    if(carPagesByCarIDMap==null)
      carPagesByCarIDMap=new HashMap();
    if(carVMByCarIDMap==null)
      carVMByCarIDMap=new HashMap();

    carPagesByCarIDMap.putIfAbsent(carId, () => carPage);
    carVMByCarIDMap.putIfAbsent(carId, () => carPage.carVM);

    var content=new Container(
      child: carPage.renderCarPage());
    carPageContainer..add(content);
  }


  List<Container> getPageContent()
  {
    return carPageContainer;
  }

  CarPage getCarPageByCarID(int carId)
  {
    return carPagesByCarIDMap[carId];
  }

  CarVM getCarVMByCarId(int carId)
  {
    return carVMByCarIDMap[carId];
  }


}


CarPageHolder carPageHolder=new CarPageHolder();
