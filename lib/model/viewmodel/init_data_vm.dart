import 'package:anad_magicar/model/apis/api_brand_model.dart';
import 'package:anad_magicar/model/apis/api_car_color.dart';
import 'package:anad_magicar/model/apis/api_device_model.dart';
import 'package:anad_magicar/model/apis/api_related_user_model.dart';
import 'package:anad_magicar/model/cars/car_color.dart';
import 'package:anad_magicar/model/cars/car_model.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:flutter/material.dart';

class InitDataVM {

  ApiCarColor carColor;
  CarModel carModel;
  BrandModel carBrand;
  ApiDeviceModel carDevice;
  List<CarModel> carModels;
  List<ApiCarColor> carColors;
  List<BrandModel> carBrands;
  List<ApiDeviceModel> carDevices;
  List<AdminCarModel> carsToAdmin;
  List<ApiRelatedUserModel> relatedUsers;
  InitDataVM({
    @required this.carColor,
    @required this.carModel,
    @required this.carBrand,
    @required this.carDevice,
    @required this.carModels,
    @required this.carColors,
    @required this.carBrands,
    @required this.carDevices,
    @required this.carsToAdmin,
    @required this.relatedUsers,
  });

  Map<String, dynamic> toMap() {
    return {
      'carColor': this.carColor,
      'carModel': this.carModel,
      'carBrand': this.carBrand,
      'carDevice': this.carDevice,
      'carModels': this.carModels,
      'carColors': this.carColors,
      'carBrands': this.carBrands,
      'carDevices': this.carDevices,
      'carsToAdmin': this.carsToAdmin,
      'relatedUsers': this.relatedUsers,
    };
  }

  factory InitDataVM.fromMap(Map<String, dynamic> map) {
    return new InitDataVM(
      carColor: map['carColor'] ,
      carModel: map['carModel'] ,
      carBrand: map['carBrand'] ,
      carModels: map['carModels'] ,
      carColors: map['carColors'] ,
      carBrands: map['carBrands'] ,
      carDevice: map['carDevice'],
      carDevices: map['carDevices'],
      carsToAdmin: map['carsToAdmin'],
      relatedUsers: map['relatedUsers']
    );
  }

  factory InitDataVM.fromJson(Map<String, dynamic> json) {
    return InitDataVM(carColor: ApiCarColor.fromJsonForColor(json["carColor"]),
      carModel: CarModel.fromJson(json["carModel"]),
      carBrand: BrandModel.fromJson(json["carBrand"]),
      carModels: json["carModels"].map((cm) => CarModel.fromJson(cm)).toList(),
      carColors: json["carColors"].map((c) => CarColor.fromJson(c)).toList(),
      carBrands: json["carBrands"].map((b) => BrandModel.fromJson(b)).toList(),);
  }

  Map<String, dynamic> toJson() {
    return {
      "carColor": this.carColor,
      "carModel": this.carModel,
      "carBrand": this.carBrand,
      "carModels": this.carModels,
      "carColors": this.carColors,
      "carBrands": this.carBrands,
    };
  }


}
