import 'package:anad_magicar/ui/factory/builder/car_builder.dart';
import 'package:anad_magicar/ui/factory/builder/car_product.dart';
import 'package:flutter/material.dart';

class CarFactory {
  CarPageBuilder carPageBuilder;

  CarFactory({
    @required this.carPageBuilder,
  });

  CarProduct getCarPage()
  {
    return carPageBuilder.getCar();
  }
  createCarPage()
  {
    carPageBuilder.buildBody();
    carPageBuilder.buildPanel();
    carPageBuilder.buildCarStateVM();
    carPageBuilder.buildCarVM();
    carPageBuilder.buildCurrent();
    carPageBuilder.buildCarPage();
  }

}
