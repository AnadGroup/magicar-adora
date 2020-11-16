import 'package:flutter/material.dart';

class ApiCarModel {
  int CarModelId;
  String CarModelCode;
  String CarModelTitle;
  int BrandId;
  String Decription;
  ApiCarModel({
    @required this.CarModelId,
    @required this.CarModelCode,
    @required this.CarModelTitle,
    this.BrandId,
    this.Decription
  });

  Map<String, dynamic> toMap() {
    return {
      'CarModelId': this.CarModelId,
      'CarModelCode': this.CarModelCode,
      'CarModelTitle': this.CarModelTitle,
    };
  }
  Map<String, dynamic> toMapForResultGetByBrandId() {
    return {
      'CarModelId': this.CarModelId,
      'Description': this.Decription,
      'CarModelTitle': this.CarModelTitle,
    };
  }

  Map<String, dynamic> toMapForGetByBrandId() {
    return {
      'brandId': this.BrandId,
    };
  }
  factory ApiCarModel.fromMap(Map<String, dynamic> map) {
    return new ApiCarModel(
      CarModelId: map['CarModelId'] ,
      CarModelCode: map['CarModelCode'] ,
      CarModelTitle: map['CarModelTitle'] ,
    );
  }

  factory ApiCarModel.fromJson(Map<String, dynamic> json) {
    return ApiCarModel(CarModelId:json["CarModelId"],
      CarModelCode: json["CarModelCode"],
      CarModelTitle: json["CarModelTitle"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "CarModelId": this.CarModelId,
      "CarModelCode": this.CarModelCode,
      "CarModelTitle": this.CarModelTitle,
    };
  }
  
  Map<String, dynamic> toJsonForResultGetByBrandId() {
    return {
      "CarModelId": this.CarModelId,
      "Description": this.Decription,
      "CarModelTitle": this.CarModelTitle,
    };
  }

  Map<String, dynamic> toJsonForGetCarModel() {
    return {
      "carModelId": this.CarModelId,
      //"CarModelCode": this.CarModelCode,
      //"CarModelTitle": this.CarModelTitle,
    };
  }

  Map<String, dynamic> toJsonForGetCarModelByBrandId() {
    return {
      "brandId": this.BrandId,
    };
  }
}
