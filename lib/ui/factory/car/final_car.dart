/*
import 'dart:collection';

import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/ui/factory/car/base_car.dart';
import 'package:anad_magicar/ui/factory/car/car.dart';
import 'package:anad_magicar/ui/factory/car/car_builder.dart';
import 'package:anad_magicar/ui/factory/car/car_page.dart';
import 'package:flutter/material.dart';

class FinalCar  {

  static final FinalCar _carWidgetInstance=FinalCar._internal();

  FinalCar._internal();

  static List<Car> cars;
  static List<CarPageBuilder> carWidgets;
  HashMap<int,CarStateVM> carStateVMMap=new HashMap();

  factory FinalCar(){
    if(carWidgets==null)
      carWidgets=new List();
    if(cars==null)
      cars=new List();

    return _carWidgetInstance;
  }

  FinalCar addCar(Car car)
  {
    if(cars==null)
      cars=new List();
    cars.add(car);
    return _carWidgetInstance;
  }

  int getCarSize()
  {
    return cars.length;
  }

  Car getCarByIndex(int index)
  {
    return cars[index];
  }

  List<Car> getAllCars()
  {
    return cars;
  }

  updateCarState(CarStateVM state,int carId,int carIndex)
  {
    Car car=cars.where((c)=> c.carId==carId).toList().first;
    if(car!=null )
      car.carStateVM=state;
  }

  @override
  Widget createPage(CarPageBuilder entity) {
    // TODO: implement createPage
    return entity;
  }

  @override
  Widget getCarPage(CarPageBuilder entity, int carId) {
    return null;
  }


}


FinalCar finalCar=new FinalCar();
*/
