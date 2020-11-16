import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:flutter/material.dart';

class MapVM {
  int carId;
  int carCounts;
  String fromDate;
  String toDate;
  bool forReport=false;
  List<AdminCarModel> cars;

  MapVM({
    @required this.carId,
    @required this.carCounts,
    @required this.cars,
    @required this.fromDate,
    @required this.toDate,
    @required this.forReport
  });

}
