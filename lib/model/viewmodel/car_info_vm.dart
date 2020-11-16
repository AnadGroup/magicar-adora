import 'package:anad_magicar/model/apis/api_brand_model.dart';
import 'package:anad_magicar/model/apis/api_car_color.dart';
import 'package:anad_magicar/model/apis/api_car_mdel_detail.dart';
import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/apis/api_carmodel_model.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:flutter/material.dart';

class CarInfoVM{

  BrandModel brandModel;
  Car car;
  ApiCarColor carColor;
  ApiCarModel carModel;
  ApiCarModelDetail carModelDetail;
  String brandTitle;
  String modelTitle;
  String modelDetailTitle;
  int brandId;
  int moddelId;
  int modelDetailId;
  int colorId;
  String pelak;
  String distance;
  String color;
  int carId;
  bool isAdmin;
  bool isActive;
  int userId;
  bool hasJoind;
  String fromDate;
  String Description;
  int CarToUserStatusConstId;
  SaveCarModel editModel;
  String imageUrl;
  CarInfoVM({
    @required this.colorId,
    @required this.brandId,
    @required this.moddelId,
    @required this.modelDetailId,
    @required this.brandModel,
    @required this.car,
    @required this.carColor,
    @required this.carModel,
    @required this.carModelDetail,
    @required this.brandTitle,
    @required this.modelTitle,
    @required this.modelDetailTitle,
    @required this.carId,
    @required this.color,
    @required this.isAdmin,
    @required this.fromDate,
    @required this.Description,
    @required this.CarToUserStatusConstId,
  @required this.userId,
    @required this.editModel,
    @required this.imageUrl,
    @required this.pelak,
    @required this.distance,
    @required this.isActive,
    @required this.hasJoind
  });



}
