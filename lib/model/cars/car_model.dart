
import 'package:flutter/material.dart';

class CarModel {
  int carModelId;
  String carModelCode;
  String carModelTitle;
  String imageUrl;
  int brandId;
  bool isActive;
  int businessUnitId;
  int owner;
  String version;
  String createdDate;

  CarModel({
    @required this.carModelId,
    @required this.carModelCode,
    @required this.carModelTitle,
    @required this.imageUrl,
    @required this.brandId,
    @required this.isActive,
    @required this.businessUnitId,
    @required this.owner,
    @required this.version,
    @required this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'CarModelId': this.carModelId,
      'CarModelCode': this.carModelCode,
      'CarModelTitle': this.carModelTitle,
      'ImageUrl': this.imageUrl,
      'BrandId': this.brandId,
      'IsActive': this.isActive,
      'BusinessUnitId': this.businessUnitId,
      'Owner': this.owner,
      'Version': this.version,
      'CreatedDate': this.createdDate,
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return new CarModel(
      carModelId: map['CarModelId'] ,
      carModelCode: map['CarModelCode'] ,
      carModelTitle: map['CarModelTitle'] ,
      imageUrl: map['ImageUrl'] ,
      brandId: map['BrandId'] ,
      isActive: map['IsActive'] ,
      businessUnitId: map['BusinessUnitId'] ,
      owner: map['Owner'] ,
      version: map['Version'],
      createdDate: map['CreatedDate'] ,
    );
  }

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(carModelId: json["CarModelId"],
      carModelCode: json["CarModelCode"],
      carModelTitle: json["CarModelTitle"],
      imageUrl: json["ImageUrl"],
      brandId: json["BrandId"],
      isActive: json["IsActive"],
      businessUnitId: json["BusinessUnitId"],
      owner: json["Owner"],
      version: json["Version"],
      createdDate: json["CreatedDate"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "CarModelId": this.carModelId,
      "CarModelCode": this.carModelCode,
      "CarModelTitle": this.carModelTitle,
      "ImageUrl": this.imageUrl,
      "BrandId": this.brandId,
      "IsActive": this.isActive,
      "BusinessUnitId": this.businessUnitId,
      "Owner": this.owner,
      "Version": this.version,
      "CreatedDate": this.createdDate,
    };
  }

  bool operator ==(o) => o is CarModel && o.carModelCode == carModelCode;
  int get hashCode => carModelCode.hashCode;
}
